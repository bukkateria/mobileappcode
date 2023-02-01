import 'package:bloc/bloc.dart';
import 'package:bukateria/repository/auth_repository.dart';
import 'package:bukateria/repository/order_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';


part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;
  OrderCubit({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(OrderState.initial());

  void changeOrderId(String value) {
    emit(state.copyWith(orderId: value, status: OrderStatus.init));
  }
  void changeDateTime(String value) {
    emit(state.copyWith(dateTime: value, status: OrderStatus.init));
  }
  void changeOrderStatus(String value) {
    emit(state.copyWith(orderStatus: value, status: OrderStatus.init));
  }
  void changeDeliveryType(String value) {
    emit(state.copyWith(deliveryType: value, status: OrderStatus.init));
  }
  void changeSellerId(String value) {
    emit(state.copyWith(sellerId: value, status: OrderStatus.init));
  }
  void changeBuyerId(String value) {
    emit(state.copyWith(buyerId: value, status: OrderStatus.init));
  }
  void changeMenuId(String value) {
    emit(state.copyWith(menuId: value, status: OrderStatus.init));
  }


  void placeOrder() async {
    emit(state.copyWith(status: OrderStatus.processing));
    try {
      await _orderRepository.placeOrder(
        orderId: state.orderId,
        orderStatus: state.orderStatus,
        deliveryType: state.deliveryType,
        dateTime: state.dateTime,
        buyerId: state.buyerId,
        sellerId: state.sellerId,
        menuId: state.menuId
      ).then((value) {
        print("------success------");
        emit(state.copyWith(status: OrderStatus.success));
      }).onError((error, stackTrace) {
        emit(state.copyWith(status: OrderStatus.error));
      });

    } catch (_) {
      emit(state.copyWith(status: OrderStatus.error));
    }
  }

  void updateOrderStatus() async {
    emit(state.copyWith(status: OrderStatus.processing));
    try {
      Map<String,dynamic>? result = await _orderRepository.updateOrderStatus(
          orderId: state.orderId,
          orderStatus: state.orderStatus,
      );

      emit(state.copyWith(status: OrderStatus.success));
    } catch (_) {
      emit(state.copyWith(status: OrderStatus.error));
    }
  }

  void expireOrderStatus() async {
    //emit(state.copyWith(status: OrderStatus.processing));
    try {
      Map<String,dynamic>? result = await _orderRepository.updateOrderStatus(
          orderId: state.orderId,
          orderStatus: state.orderStatus,
      );

      //emit(state.copyWith(status: OrderStatus.success));
    } catch (_) {
      emit(state.copyWith(status: OrderStatus.error));
    }
  }
  getChefOrderList(String sellerId){
    _orderRepository.sellerId = sellerId;
    return _orderRepository.getChefOrdersList;
  }

  getFoodieOrderList(String buyerId){
    _orderRepository.buyerId = buyerId;
    return _orderRepository.getFoodieOrdersList;
  }

  sendNotification(String token ,String name, context, String message){
    _orderRepository.sendNotificationToDriver(token, name, context, message);
  }

  giveReview(
      String description,
      double rating,
      String buyerId,
      String sellerId,
      String menuId
      ) async {
    _orderRepository.giveReviews(description, rating, buyerId, sellerId, menuId);
  }
}
