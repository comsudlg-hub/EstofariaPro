import 'package:flutter/material.dart';

class Product {
  final String id;
  final String nome;
  final double preco;
  final String descricao;

  Product({
    required this.id,
    required this.nome,
    required this.preco,
    required this.descricao,
  });
}

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(String id, Product updated) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products[index] = updated;
      notifyListeners();
    }
  }

  void removeProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
