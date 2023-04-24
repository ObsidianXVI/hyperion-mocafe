library ql_agent_test;

import '../agents.dart';
import '../../mkproj.dart';

void main(List<String> args) {
  // ENVIRONMENT CONFIGURATION
  final MocafeResourceConfigs resourceConfigs = MocafeResourceConfigs(
    memoryTokens: 100,
    ingredientTokens: 100,
  );

  final MocafeEnvironment env = MocafeEnvironment(
    actionSpace: ActionSpace(actions: [
      FetchMenuAction(),
    ]),
    stateSpace: StateSpace(states: <MocafeState>[]),
    paramSpace: ParamSpace(argSets: [
      FetchMenuArgSet.size0(),
      FetchMenuArgSet.size1(),
      FetchMenuArgSet.size2(),
      FetchMenuArgSet.size3(),
      FetchMenuArgSet.size4(),
    ]),
    mocafeResourceConfigs: resourceConfigs,
    mocafeResourceManager: MocafeResourceManager(resourceConfigs),
    networkConfigs: NetworkConfigs(),
  );

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
