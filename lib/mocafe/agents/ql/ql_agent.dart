part of agents;

class QL_Agent {
  final MocafeEnvironment env;
  final List<State> states;
  final List<Action> actions;
  final List<ArgSet> argSets;
  final double learningRate;
  final double discountFactor;
  final double epsilonValue;
  final int episodes;
  final int epochs;
  int episodeCount = 0;
  int timeStep = 0;

  /// Key is a 3-dimensional vector (stateIndex, actionIndex, argSetIndex),
  /// which will be called a [QVector] henceforth.
  /// Respective value is the Q-value for that QVector.
  /// As such, a 3-dimensional Q-table is implemented.
  final Map<QVector, double> qTable = {};

  QL_Agent(
    this.env, {
    required this.learningRate,
    required this.discountFactor,
    required this.epsilonValue,
    required this.episodes,
    required this.epochs,
  })  : states = env.stateSpace.states,
        actions = env.actionSpace.actions,
        argSets = env.parameterSpace.argSets;

  void beginEpoch(State initialState) {
    for (int i = 0; i < epochs; i++) {
      for (; episodeCount < episodes; episodeCount++) {
        beginEpisode(initialState);
      }
    }
  }

  /// Activate the agent by providing an initial state to begin with.
  void beginEpisode(State initialState) {
    if (initialState.isTerminal) throw Exception("Initial state is terminal");
    perform(initialState);
    MocafeState state = MocafeState.current(env);
    while (!state.isTerminal) {
      perform(state);
      state = MocafeState.current(env);
    }
  }

  void perform(State state) {
    timeStep++;
    // fetch all available Q-values
    final Map<QVector, double> qValuesOfState = fetchHistoricalQValues(state);

    // select action
    final int comboIndex = qValuesOfState.values.toList().indexOfMaxValue();
    final Action selectedAction = select<Action>(
      state.actionsAvailable,
      qValuesOfState.keys.toList()[comboIndex].action,
    );
    // select arg
    final ArgSet selectedArgSet = select<ArgSet>(
      argSets,
      qValuesOfState.keys.toList()[comboIndex].argSet,
    );
    // perform action
    final double reward = env.performAction(
      selectedAction,
      selectedArgSet,
    );
    // calculate temporal difference
    final State newState = MocafeState.current(env);
    final double maxFutureValue = computeMaxFutureQValue(newState);
    final double historicalQValue = qValuesOfState[comboIndex]!;
    final double newQValue = reward + discountFactor * maxFutureValue;
    final double temporalDifference = newQValue - historicalQValue;
    // update q value in table
    final doubleUpdatedQValue =
        historicalQValue + learningRate * temporalDifference;
  }

  /// Fetches the past Q-value stored from the last time this S-A-A vector was
  /// considered. The keys for all S-A-A vectors will exist in the table from the
  /// time it is initialised. Only the values start at null, and this is used to
  /// check whether an S-A-A vector is being explored for the first time.
  /* double fetchHistoricalQValue(
    State stateIn,
    Action actionToBeTaken,
    ArgSet argSet,
  ) {
    final int stateIndex = states.indexWhere((State s) => s == stateIn);
    final int actionIndex =
        actions.indexWhere((Action a) => a == actionToBeTaken);
    final int argSetIndex = argSets.indexWhere((ArgSet arg) => arg == argSet);
    final List<int> qTableKey = [stateIndex, actionIndex, argSetIndex];
    if (qTable.containsKey(qTableKey)) {
      return qTable[qTableKey]!;
    } else {
      qTable[qTableKey] = 0;
      return 0;
    }
  } */
  double fetchHistoricalQValue(
    State stateIn,
    Action actionToBeTaken,
    ArgSet argSetUsed,
  ) {
    final State state = states.firstWhere((State s) => s == stateIn);
    final Action action =
        actions.firstWhere((Action a) => a == actionToBeTaken);
    final ArgSet argSet = argSets.firstWhere((ArgSet arg) => arg == argSetUsed);
    final QVector qTableKey = QVector(state, action, argSet);
    if (qTable.containsKey(qTableKey)) {
      return qTable[qTableKey]!;
    } else {
      qTable[qTableKey] = 0;
      return 0;
    }
  }

  double computeMaxFutureQValue(State newState) {
    final Map<QVector, double> qValuesOfState =
        fetchHistoricalQValues(newState);
    final double maxQValue = qValuesOfState.values.toList().reduce(math.max);
    return maxQValue;
  }

  Map<QVector, double> fetchHistoricalQValues(State state) {
    final Map<QVector, double> qValuesOfState = {};
    for (Action action in state.actionsAvailable) {
      for (ArgSet argSet in argSets) {
        qValuesOfState[QVector(state, action, argSet)] =
            fetchHistoricalQValue(state, action, argSet);
      }
    }
    return qValuesOfState;
  }

  /// This method defines the action selection policy. Set [epsilonValue] to 1
  /// to obtain ε-greedy/optimal policy.
  T select<T>(List<T> possibleChoices, T optimalChoice) {
    final math.Random random = math.Random();
    if (random.nextDouble() < epsilonValue) {
      return possibleChoices[random.nextInt(possibleChoices.length - 1)];
    } else {
      return optimalChoice;
    }
  }
}

extension ListUtils on List<double> {
  int indexOfMaxValue() {
    final double maxValue = reduce(math.max);
    return indexWhere((double value) => value == maxValue);
  }
}
