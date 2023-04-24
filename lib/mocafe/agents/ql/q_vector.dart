library ql_agent.types;

import 'package:mocafe/mocafe/mkproj.dart';

class MocafeQVector extends QVector {
  final ArgSet argSet;

  MocafeQVector(super.state, super.action, this.argSet)
      : super(dimensions: 3, values: [
          state,
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
