part of 'order_cubit.dart';

enum OrderStatus { success,error,processing,init,expire}

class OrderState extends Equatable {
  final String orderId;
  final String deliveryType;
  final String sellerId;
  final String buyerId;
  final String orderStatus;
  final String dateTime;
  final String menuId;
  final OrderStatus? status;

  const OrderState(
      {required this.orderId,required this.deliveryType,required this.sellerId,required this. buyerId, required this.orderStatus,required this.menuId, required this.dateTime,this.status});

  factory OrderState.initial() {
    return const OrderState(
      orderId: '',
      deliveryType: '',
      sellerId: '',
      buyerId: '',
      orderStatus: '',
      menuId: '',
      dateTime: '',
      status: OrderStatus.init
    );
  }

  OrderState copyWith(
      {String? orderId, String? sellerId, String? buyerId, String? deliveryType, String? menuId, String? orderStatus, String? dateTime, OrderStatus? status }) {
    return OrderState(
        orderId: orderId ?? this.orderId,
        sellerId: sellerId ?? this.sellerId,
        buyerId: buyerId ?? this.buyerId,
        deliveryType: deliveryType ?? this.deliveryType,
        menuId: menuId ?? this.menuId,
        orderStatus: orderStatus ?? this.orderStatus,
        dateTime: dateTime ?? this.dateTime,
        status:  status ?? this.status,
    );
  }

  @override
  List<Object> get props => [orderId,sellerId,buyerId,deliveryType,menuId,orderStatus,dateTime,status ?? OrderStatus.init];
}
