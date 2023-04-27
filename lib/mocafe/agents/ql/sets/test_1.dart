library ql_test_1;

import '../../agents.dart';
import '../../../mkproj.dart';

void main(List<String> args) {
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
  final Timeline timeline = Timeline(timelineConfigs: TimelineConfigs());

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
          states.add(
              MocafeState(memoryTokens: memToks, ingredientTokens: ingToks));
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
  );

  env.addHook(TimestepHook(
      env: env,
      body: (Environment _) {
        final int ingredientToksConsumed;
        if (env.mocafeDataStore.menuCell.data.isEmpty) {
          ingredientToksConsumed = 0;
        } else {
          ingredientToksConsumed = env.mocafeDataStore.menuCell.data
              .map((Drink drink) => drink.ingredientToksNeeded)
              .reduce((total, toksOfDrink) => total + toksOfDrink);
        }

        env.mocafeResourceManager.ingredientTokens -= ingredientToksConsumed;

        final int memoryToksConsumed = env.mocafeDataStore.menuCell.size();
        env.mocafeResourceManager.memoryTokens -= memoryToksConsumed;
      }));

  // HYPERPARAMETERS CONFIGURATION
  final MocafeQLAgent qlAgent = MocafeQLAgent(
    env: env,
    runConfigs: QLRunConfigs(
      learningRate: 0.1,
      discountFactor: 0.9,
      epsilonValue: 1,
      epochs: 1,
      episodes: 10,
    ),
  );

  qlAgent.run(MocafeState.current(env));
}
