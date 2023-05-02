library ql_test_1;

import '../../agents.dart';
import '../../../mkproj.dart';

void main(List<String> args) async {
  // ENVIRONMENT CONFIGURATION
  final MocafeResourceConfigs resourceConfigs = MocafeResourceConfigs(
    memoryTokens: 99,
    ingredientTokens: 99,
  );

  final MocafeDataStore mocafeDataStore = MocafeDataStore();
  mocafeDataStore.menuCell.addHook(DataCellEvent.update, (_) {
    throw StackTrace.current;
  });
  final Observatory observatory =
      Observatory(observatoryConfigs: ObservatoryConfigs());
  final Timeline timeline =
      Timeline(timelineConfigs: TimelineConfigs(liveReport: true));
  timeline.listenOn(observatory);

  final MocafeEnvironment env = MocafeEnvironment(
    actionSpace: ActionSpace(actions: [
      FetchMenuAction(),
    ]),
    stateSpaceGenerator: ((
      MocafeResourceConfigs mocafeResourceConfigs,
      ParamSpace paramSpace,
      ActionSpace actionSpace,
    ) {
      final List<MocafeState> states = [];
      for (int memToks = 0;
          memToks < mocafeResourceConfigs.memoryTokens!;
          memToks++) {
        for (int ingToks = 0;
            ingToks < mocafeResourceConfigs.ingredientTokens;
            ingToks++) {
          states.add(MocafeState(
            memoryTokens: memToks,
            ingredientTokens: ingToks,
            isTerminal: memToks == 0 && ingToks == 0,
          ));
        }
      }
      return states;
    }),
    paramSpace: ParamSpace(argSets: [
      FetchMenuArgSet.size0(mocafeDataStore.menuCell),
      FetchMenuArgSet.size1(mocafeDataStore.menuCell),
      FetchMenuArgSet.size2(mocafeDataStore.menuCell),
      FetchMenuArgSet.size3(mocafeDataStore.menuCell),
      FetchMenuArgSet.size4(mocafeDataStore.menuCell),
    ]),
    mocafeResourceConfigs: resourceConfigs,
    mocafeResourceManager: MocafeResourceManager(resourceConfigs),
    networkConfigs: NetworkConfigs(),
    mocafeDataStore: mocafeDataStore,
    observatory: observatory,
    qlRunConfigs: QLRunConfigs(
      learningRate: 0.1,
      learningRateDecay: -0.00005,
      discountFactor: 0.9,
      epsilonValue: 0.8,
      epochs: 1,
      episodes: 10,
      timestepPause: Duration.zero,
    ),
  );

  env.addHook(TimestepHook(
      env: env,
      body: (Environment _) {
        // Decrease the resource tokens
        final int ingredientToksConsumed;
        if (env.mocafeDataStore.menuCell.data.isEmpty) {
          ingredientToksConsumed = 0;
        } else {
          ingredientToksConsumed = env.mocafeDataStore.menuCell.data
              .map((Drink drink) => drink.ingredientToksNeeded)
              .reduce((total, toksOfDrink) => total + toksOfDrink);
        }

        env.mocafeResourceManager.ingredientTokens -= ingredientToksConsumed;
        if (env.mocafeResourceManager.ingredientTokens < 0) {
          env.mocafeResourceManager.ingredientTokens = 0;
        }

        final int memoryToksConsumed = env.mocafeDataStore.menuCell.size();
        env.mocafeResourceManager.memoryTokens -= memoryToksConsumed;
        if (env.mocafeResourceManager.memoryTokens < 0) {
          env.mocafeResourceManager.memoryTokens = 0;
        }

        // Decay the learning rate
        env.qlRunConfigs.learningRate -= env.qlRunConfigs.learningRateDecay;
      }));

  // HYPERPARAMETERS CONFIGURATION
  final MocafeQLAgent qlAgent = MocafeQLAgent(
    env: env,
    runConfigs: env.qlRunConfigs,
  );

  await qlAgent.run(MocafeState.current(env));
  print("Data exported to: ${await timeline.exportCSV('test_1_3')}");
}
