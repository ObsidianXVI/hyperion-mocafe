library ql_agent.types;

import 'package:mocafe/mocafe/mkproj.dart';

class QVector {
  final State state;
  final Action action;
  final ArgSet argSet;

  QVector(this.state, this.action, this.argSet);

  @override
  bool operator ==(Object other) {
    if (other is! QVector) {
      return false;
    } else {
      return (state == other.state &&
          action == other.action &&
          argSet == other.argSet);
    }
  }
}
