part of mocafe_mkproj;

class MocafeEnvironment extends Environment {
    MocafeEnvironment({
    required super.actionSpace,
    required super.parameterSpace,
    required super.stateSpace,
    required super.resourceConfigs,
    required super.networkConfigs,
  });

  @override
  MocafeResourceManager get resourceManager => MocafeResourceManager(this);

  @override
  MocafeGlobalState get globalState => MocafeGlobalState();
}
