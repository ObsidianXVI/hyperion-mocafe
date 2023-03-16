library mocafe;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

part './interface.dart';
part './api.dart';
part './order.dart';
part './tracker.dart';
part './machine.dart';
part './utils.dart';

class Mocafe {
  static bool isActive = true;
  static void init() async {
    Machine.init();
    Interface.init();
  }

  static void deinit() {
    Machine.deinit();
    Interface.deinit();
    exit(0);
  }
}

void main(List<String> args) {
  Mocafe.init();
}
