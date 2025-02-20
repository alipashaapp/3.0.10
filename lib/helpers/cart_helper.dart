import 'package:ali_pasha_graph/Global/main_controller.dart';
import 'package:ali_pasha_graph/models/cart_model.dart';
import 'package:ali_pasha_graph/models/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

import '../models/product_model.dart';

class CartHelper {
  static Future<List<CartModel>> increaseQty({required int productId}) async {
    GetStorage storage = GetStorage('ali-pasha');
    List<CartModel> cart = [];
    if (storage.hasData('cart')) {
      var data = await storage.read('cart');

      for (var item in data) {
        CartModel cartItem = CartModel.fromJson(item);
        if (cartItem.product?.id == productId) {
          cartItem.addQty();
        }
        cart.add(cartItem);
      }
    }
    await saveCart(cart);
    return cart;
  }

  static Future<List<CartModel>> decreaseQty({required int productId}) async {
    GetStorage storage = GetStorage('ali-pasha');
    List<CartModel> cart = [];
    if (storage.hasData('cart')) {
      var data = await storage.read('cart');
      for (var item in data) {
        CartModel cartItem = CartModel.fromJson(item);
        if (cartItem.product?.id == productId) {
          cartItem.minQty();
        }
        cart.add(cartItem);
      }
    }
    await saveCart(cart);
    return cart;
  }

  static Future<List<CartModel>> addToCart(
      {required ProductModel product}) async
  {
    GetStorage storage = GetStorage('ali-pasha');
    List<CartModel> cart = [];
    if (storage.hasData('cart')) {
      var data = await storage.read('cart');
      bool IsFound = false;
      for (var item in data) {
        CartModel cartItem = CartModel.fromJson(item);
        if (cartItem.product?.id == product.id) {
          cartItem.addQty();
          IsFound = true;
        }
        cart.add(cartItem);
      }
      if (IsFound == false) {
        CartModel cartItem = CartModel(
            product: product,
            qty: 1,
            seller: product.user);
        cart.add(cartItem);
      }
    } else {
      CartModel cartItem = CartModel(
          product: product,
          qty: 1,
          seller: product.user);
      cart.add(cartItem);
    }
    await saveCart(cart);

    return cart;
  }

  static Future<List<CartModel>> minFromCart(
      {required ProductModel product}) async
  {
    GetStorage storage = GetStorage('ali-pasha');
    if (storage.hasData('cart')) {
      var data = await storage.read('cart');
      List<CartModel> cart = [];
      for (var item in data) {
        CartModel cartItem = CartModel.fromJson(item);
        if (cartItem.product?.id == product.id) {
          cartItem.minQty();
        }
        cart.add(cartItem);
      }
      await saveCart(cart);
      return cart;
    }
    return [];
  }

  static saveCart(List<CartModel> carts) async {
    GetStorage storage = GetStorage('ali-pasha');
    List data = carts.map((el) => el.toJson()).toList();
    if (storage.hasData('cart')) {
      await storage.remove('cart');
    }
    await storage.write('cart', data);
  }

  static Future<List<CartModel>> getCart() async {
    GetStorage storage = GetStorage('ali-pasha');
    List<CartModel> cart = [];
    if (storage.hasData('cart')) {
      var data = await storage.read('cart');
      for (var item in data) {
        CartModel cartItem = CartModel.fromJson(item);
        cart.add(cartItem);
      }
    }
    await saveCart(cart);
    return cart;
  }

  static Future<List<CartModel>> removeBySeller({ int? sellerId}) async {
    GetStorage storage = GetStorage('ali-pasha');
    List<CartModel> cart = [];
    if (storage.hasData('cart')) {
      var data = await storage.read('cart');
      for (var item in data) {
        print("REMOVE");
        print("${item['seller']?['id'] } - $sellerId");
        if ( int.tryParse("${item['seller']?['id']}") == sellerId) {
          print("REMOVE@2");
          continue;
        }

        CartModel cartItem = CartModel.fromJson(item);
        cart.add(cartItem);
      }
    }
    await saveCart(cart);
    return cart;
  }

  static Future<List<CartModel>> removeCart(
      {required ProductModel product}) async {

    GetStorage storage = GetStorage('ali-pasha');
    List<CartModel> cart = [];

    if (storage.hasData('cart')==true) {
      var data = await storage.read('cart');
      Logger().f(data);
      for (var item in data) {
        CartModel cartItem = CartModel.fromJson(item);
        if (cartItem.product?.id == product.id) {

          continue;
        }
        cart.add(cartItem);
      }
    }
    await saveCart(cart);
    return cart;
  }

  static Future<List<CartModel>> emptyCart() async {
    GetStorage storage = GetStorage('ali-pasha');
    if (storage.hasData('cart')) {
      storage.remove('cart');
    }
    return [];
  }
}
