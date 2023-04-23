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
    actionSpace: ActionSpace(actions: []),
    parameterSpace: ParameterSpace(paramSets: [], argSets: []),
    stateSpace: StateSpace(states: <MocafeState>[]),
    mocafeResourceConfigs: resourceConfigs,
    mocafeResourceManager: MocafeResourceManager(resourceConfigs),
    networkConfigs: NetworkConfigs(),
  );
  final QL_Agent qlAgent = QL_Agent(
    env,
    learningRate: 0.1,
    discountFactor: 0.9,
    epsilonValue: 1,
    epochs: 1,
    episodes: 10,
  );
  qlAgent.beginEpoch(MocafeState.current(env));
}
