part of mocafe_mkproj;

class MocafeEnvironment extends DevelopmentEnv {
  final MocafeResourceConfigs mocafeResourceConfigs;
  final MocafeResourceManager mocafeResourceManager;
  final MocafeDataStore mocafeDataStore;
  final QLRunConfigs qlRunConfigs;

  MocafeEnvironment({
    required super.actionSpace,
    required List<MocafeState> Function(
            MocafeResourceConfigs, ParamSpace, ActionSpace)
        stateSpaceGenerator,
    required super.paramSpace,
    required super.networkConfigs,
    required this.mocafeResourceConfigs,
    required this.mocafeResourceManager,
    required this.mocafeDataStore,
    required this.qlRunConfigs,
    super.observatory,
  }) : super(
          stateSpace: StateSpace<MocafeState>(
            states: stateSpaceGenerator(
                mocafeResourceConfigs, paramSpace, actionSpace),
          ),
          resourceConfigs: mocafeResourceConfigs,
          resourceManager: mocafeResourceManager,
          dataStore: mocafeDataStore,
          runConfigs: qlRunConfigs,
        ) {
    MocafeState._actions.addAll(actionSpace.actions);
  }

  @override
  MocafeGlobalState get globalState => MocafeGlobalState();

  @override
  ActionResult performAction(Action action, ArgSet argSet) {
    final MocafeState previouState = MocafeState.current(this);
    //print(argSet.toInstanceLabel());
    action.body(action.convertArgSet(argSet));
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
    final Random random = Random();
    final List<Drink> currentMenu = mocafeDataStore.menuCell.data;
    final double customerReward;
    if (currentMenu.isEmpty) {
      customerReward = 0;
    } else {
      /* final int randInt = random.nextInt(currentMenu.length);

      customerReward = currentMenu[randInt].monetaryValue; */
      customerReward = currentMenu.reduce((Drink v, Drink e) {
        return v.monetaryValue > e.monetaryValue ? v : e;
      }).monetaryValue;
    }
    return customerReward;
  }

  @override
  Map<MocafeQVector, double> initialiseQTable() {
    Map<MocafeQVector, double> qTable = {};

    for (MocafeState state in stateSpace.states as List<MocafeState>) {
      for (Action action in actionSpace.actions) {
        for (ArgSet argSet in paramSpace.argSets) {
          qTable[MocafeQVector(state, action, argSet)] = 0;
        }
      }
    }
    return qTable;
  }

  @override
  void reset() {
    mocafeResourceManager.reset();
    mocafeDataStore.reset();
  }
}
