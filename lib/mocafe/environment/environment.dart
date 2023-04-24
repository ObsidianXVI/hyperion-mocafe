part of mocafe_mkproj;

class MocafeEnvironment extends DevelopmentEnv {
  final MocafeResourceConfigs mocafeResourceConfigs;
  final MocafeResourceManager mocafeResourceManager;

  MocafeEnvironment({
    required super.actionSpace,
    required super.stateSpace,
    required super.paramSpace,
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
  ActionResult performAction<R>(Action<R> action, ArgSet<Action<R>> argSet) {
    final MocafeState previouState = MocafeState.current(this);
    action.body(argSet);
    final MocafeState newState = MocafeState.current(this);
    return ActionResult(
      previouState: previouState,
      actionTaken: action,
      argSetUsed: argSet,
      reward: (mocafeResourceManager.ingredientTokens +
              mocafeResourceManager.memoryTokens) /
          200,
      newState: newState,
    );
  }
}
