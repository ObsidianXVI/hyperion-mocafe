part of mocafe;

class Interface {
  static late Timer screenRefresher;
  static late Timer drinksAvailabilityRefresher;
  static List<String> availableDrinks = ['Please wait while we fetch data...'];
  static List<String> sel = [];
  static String yourOrder = '';

  static void init() {
    screenRefresher =
        Timer.periodic(const Duration(milliseconds: 1000), (Timer t) {
      renderScreen();
    });
    drinksAvailabilityRefresher =
        Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      availableDrinks = (await API.getDrinksAvailable());
    });
    stdin.lineMode = false;
    stdin.listen((event) {
      final String str = String.fromCharCodes(event);
      if (str != '\n') {
        sel.add(str);
      } else {
        if (sel.join() == '!exit') Mocafe.deinit();
        final int qty = int.tryParse(sel.join().trim().split(' ').first) ?? 1;
        final Order order = Order(sel.join(), qty);
        Tracker.addOrder(order);
        yourOrder = order.orderId;
        sel.clear();
      }
    });
  }

  static void deinit() {
    screenRefresher.cancel();
    print("Mocafe is closed");
  }

  static void renderScreen() {
    print("\x1B[2J\x1B[0;0H");
    print("== QUEUED ${'=' * 10}");
    print(Tracker._orders.keys.join(', #'));
    print("== READY ${'=' * 10}");
    print(Tracker.ready.map((Order o) => o.orderId).toList().join(', ') + '\n');
    print("== AVAILABLE DRINKS ${'=' * 10}");
    print(availableDrinks.join(', ') + '\n');
    print("== SELECTION ${'=' * 10}");
    print("Enter your choice: ${sel.join()}");
    print("=" * 20);
    if (yourOrder.isNotEmpty) print("Your order: #$yourOrder");
  }
}
