import 'package:flutter/material.dart';

import 'ProductDetails.dart';

class SalesQuotation {
  int id;
  String price;
  String productname;
  String description;
  String quantity;


  SalesQuotation(
      this.id,
      this.price,
      this.productname,
      this.description,
     ) {
    //this.controller.text = quantity ?? '1';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['productname'] = this.productname;
    data['description'] = this.description;

    return data;
  }

 /* SalesQuotation.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    quantity = json['quantity'];
    disc = json[''];
    discountOn = json['discountOn'];

    id = json['id'];

    controller.text = json['quantity'];
  }

  SalesQuotation.fromProductDetails(ProductDetails details) {
    price = details.price;
    discount = details.discount;
    discountOn = details.discountOn;

    checkStock = details.checkStock;
    amount = details.tradePrice;
    gstRate = details.gstRate;
    minOrder = details.moq;
    product = details.name;
    stock = details.stock;
    image = details.image;
    unit = details.unit;
    id = details.id;

    extraParams = '';

  }

  TextEditingController controller = TextEditingController(text: '1');*/
}
