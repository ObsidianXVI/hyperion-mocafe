library ql_agent.types;

import 'package:mocafe/mocafe/mkproj.dart';

class MocafeQVector extends QVector {
  final ArgSet argSet;
  final MocafeState mocafeState;

  MocafeQVector(this.mocafeState, Action action, this.argSet)
      : super(mocafeState, action, dimensions: 3, values: [
          mocafeState,
          action,
          argSet,
        ]);

  @override
  bool equalityComparator(Object other) {
    if (other is! MocafeQVector) {
      return false;
    } else {
      return (state == other.state &&
          action == other.action &&
          argSet == other.argSet);
    }
  }
}
