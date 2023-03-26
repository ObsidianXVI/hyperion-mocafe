library mocafe;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:markhor/markhor.dart';

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

const int machineFetchRate = 3;
const int screenRefreshRate = 1;
const int menuRefreshRate = 5;
int energyTokensConsumed = 0;
void main(List<String> args) {
  MarkhorConfigs.network.responseInterceptors.addAll({
    Uri.https("api.sampleapis.com", "/coffee/hot"):
        (Uri _, HttpClientResponse res) async {
      return await Future.delayed(const Duration(seconds: 12), () => res);
    }
  });
  Mocafe.init();
}
