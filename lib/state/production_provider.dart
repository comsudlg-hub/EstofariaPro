// lib/state/product_provider.dart
import 'package:flutter/foundation.dart';
import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';

/// Provider final do produto (Fornecedor).
/// Implementa fetch/add/update/delete e mantém estado localizado.
class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Busca todos os produtos
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _repository.getAllProducts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adiciona um produto (salva no Firestore e adiciona ao estado local).
  /// Observação: ProductModel.id deve estar definido pelo chamador, ou
  /// o repositório precisa gerar o id (decisão de arquitetura).
  Future<void> addProduct(ProductModel product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.saveProduct(product);
      _products.add(product);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Atualiza produto
  Future<void> updateProduct(ProductModel product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.saveProduct(product);
      final idx = _products.indexWhere((p) => p.id == product.id);
      if (idx != -1) _products[idx] = product;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Deleta produto
  Future<void> deleteProduct(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
