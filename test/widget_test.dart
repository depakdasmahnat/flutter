import 'package:flutter_test/flutter_test.dart';
import 'package:gaas/controllers/orders/cart_controller.dart';
import 'package:gaas/models/dashboard/producer_details_model.dart';

void main() {
  group('Testing App Provider', () {
    var cartController = CartController();

    test('A new item should be added', () {
      ProducerDetailsData? cartItem = ProducerDetailsData(id: 1);
      cartController.setCartItems([cartItem]);
      expect(cartController.cartItems?.where((element) => element?.id == cartItem.id).isNotEmpty, true);
      cartController.cartItems?.removeWhere((element) => element?.id == cartItem.id);
      cartController.notifyListeners();
      expect(cartController.cartItems?.where((element) => element?.id == cartItem.id).isNotEmpty, true);
    });
  });
}
