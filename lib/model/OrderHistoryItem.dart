class OrderHistoryItem {
  final String orderId;
  final Map<String, int> items;
  final double totalPrice;
  final DateTime orderDate;

  OrderHistoryItem({
    required this.orderId,
    required this.items,
    required this.totalPrice,
    required this.orderDate,
  });
}