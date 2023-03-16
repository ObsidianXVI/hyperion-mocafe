part of mocafe;

class Tracker {
  static final Map<String, Order> _orders = {};
  static final List<Order> ready = [];

  static void addOrder(Order order) {
    _orders.addAll({order.orderId: order});
  }

  static Order? getNextOrder() {
    return _orders.isNotEmpty ? _orders.values.first : null;
  }

  static void fulfillOrder(Order order) {
    ready.add(_orders.remove(order.orderId)!);
  }
}
