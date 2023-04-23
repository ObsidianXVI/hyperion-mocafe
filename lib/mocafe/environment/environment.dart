part of mocafe_mkproj;

class MocafeEnvironment extends DevelopmentEnv {
  final MocafeResourceConfigs mocafeResourceConfigs;
  final MocafeResourceManager mocafeResourceManager;

  MocafeEnvironment({
    required super.actionSpace,
    required super.parameterSpace,
    required super.stateSpace,
    required super.networkConfigs,
    required this.mocafeResourceConfigs,
    required this.mocafeResourceManager,
  }) : super(
          resourceConfigs: mocafeResourceConfigs,
          resourceManager: mocafeResourceManager,
        );

  @override
  MocafeGlobalState get globalState => MocafeGlobalState();

  @override
  double performAction<R, P extends ParamSet<Action<R>>>(
    Action<R> action,
    ArgSet<P> argSet,
  ) {
    action.body(argSet);
    MocafeState.current(this);
    return (mocafeResourceManager.ingredientTokens +
            mocafeResourceManager.memoryTokens) /
        200;
  }
}
