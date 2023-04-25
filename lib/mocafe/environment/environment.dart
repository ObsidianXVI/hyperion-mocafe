part of mocafe_mkproj;

class MocafeEnvironment extends DevelopmentEnv {
  final MocafeResourceConfigs mocafeResourceConfigs;
  final MocafeResourceManager mocafeResourceManager;
  final MocafeDataStore mocafeDataStore;

  MocafeEnvironment({
    required super.actionSpace,
    required super.stateSpace,
    required super.paramSpace,
    required super.networkConfigs,
    required this.mocafeResourceConfigs,
    required this.mocafeResourceManager,
    required this.mocafeDataStore,
    super.observatory,
  }) : super(
          resourceConfigs: mocafeResourceConfigs,
          resourceManager: mocafeResourceManager,
          dataStore: mocafeDataStore,
        );

  @override
  MocafeGlobalState get globalState => MocafeGlobalState();

  @override
  ActionResult performAction(Action action, ArgSet argSet) {
    final MocafeState previouState = MocafeState.current(this);
    action.body(argSet);
    final MocafeState newState = MocafeState.current(this);
    return ActionResult(
      previouState: previouState,
      actionTaken: action,
      argSetUsed: argSet,
      reward: computeReward(),
      newState: newState,
    );
  }

  double computeReward() {
    final double resourceConservationReward =
        (mocafeResourceManager.ingredientTokens +
                mocafeResourceManager.memoryTokens) /
            (mocafeResourceConfigs.ingredientTokens +
                mocafeResourceConfigs.memoryTokens!);
    final Random random = Random();
    final List<Drink> currentMenu = mocafeDataStore.menuCell.data;
    final int randInt = random.nextInt(currentMenu.length);
    final double customerReward = currentMenu[randInt].monetaryValue;
    return resourceConservationReward + customerReward;
  }
}
