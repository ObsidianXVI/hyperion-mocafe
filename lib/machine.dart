part of mocafe;

class Machine {
  static late Timer serveLoop;
  static void init() async {
    serveLoop =
        Timer.periodic(const Duration(seconds: machineFetchRate), (Timer t) {
      if (Mocafe.isActive && Tracker._orders.isNotEmpty) {
        serveNext();
      }
    });
  }

  static void deinit() => serveLoop.cancel();

  static Future<void> serveNext() async {
    return await Delay.action<void>(() {
      final Order? order = Tracker.getNextOrder();
      if (order != null) {
        Tracker.fulfillOrder(order);
      }
    }, Duration(seconds: Utils.genInt(3, 8) + 2));
  }
}

class Coffee {}
