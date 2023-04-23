part of mocafe_mkproj;

class MocafeState extends State {
  final int memoryTokens;
  final int ingredientTokens;
  static final List<Action> _actions = [];

  MocafeState({
    required this.memoryTokens,
    required this.ingredientTokens,
  }) : super(actionsAvailable: _actions);

  MocafeState.current(MocafeEnvironment env)
      : memoryTokens = env.mocafeResourceManager.memoryTokens,
        ingredientTokens = env.mocafeResourceManager.ingredientTokens,
        super(actionsAvailable: _actions);
}
