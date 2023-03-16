part of mocafe;

class Order {
  final String orderId;
  final String selection;
  final int qty;

  Order(this.selection, this.qty) : orderId = Utils.genId();
}
