part of mocafe;

class Machine {
  static late Timer serveLoop;
  static void init() async {
    serveLoop = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (Mocafe.isActive && Tracker._orders.isNotEmpty) {
        serveNext();
      }
    });
  }

  static void deinit() => serveLoop.cancel();

  static Future<void> serveNext() async {
    await Future.delayed(Duration(seconds: Utils.genInt()), () {
      final Order? order = Tracker.getNextOrder();
      if (order != null) {
        Tracker.fulfillOrder(order);
      }
    });
  }
}

class Coffee {}
