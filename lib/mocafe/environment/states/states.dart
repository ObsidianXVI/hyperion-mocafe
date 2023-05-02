part of mocafe_mkproj;

class MocafeState extends State {
  final int memoryTokens;
  final int ingredientTokens;
  static final List<Action> _actions = [];

  MocafeState({
    required this.memoryTokens,
    required this.ingredientTokens,
    super.isTerminal,
  }) : super(actionsAvailable: _actions, dimensions: 3, values: [
          memoryTokens,
          ingredientTokens,
          _actions,
        ]);

  MocafeState.current(MocafeEnvironment env)
      : memoryTokens = env.mocafeResourceManager.memoryTokens,
        ingredientTokens = env.mocafeResourceManager.ingredientTokens,
        super(
            actionsAvailable: _actions,
            dimensions: 3,
            isTerminal: env.mocafeResourceManager.memoryTokens == 0 &&
                env.mocafeResourceManager.ingredientTokens == 0,
            values: [
              env.mocafeResourceManager.memoryTokens,
              env.mocafeResourceManager.ingredientTokens,
              _actions,
            ]);

  @override
  bool equalityComparator(Object other) {
    if (other is! MocafeState) {
      return false;
    } else {
      if (memoryTokens == other.memoryTokens &&
          ingredientTokens == other.ingredientTokens) {
        return true;
      } else {
        return false;
      }
    }
  }
}
