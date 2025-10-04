/* lib/data/repositories/product_repository.dart */
import "package:cloud_firestore/cloud_firestore.dart";
import "../models/product_model.dart";

class ProductRepository {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection("products");

  Future<void> saveProduct(ProductModel product) async {
    if (product.id.isEmpty) {
      // fallback: cria com id automático
      final docRef = await _productsCollection.add(product.toMap());
      await docRef.update({"id": docRef.id});
      return;
    }
    await _productsCollection.doc(product.id).set(product.toMap());
  }

  Future<ProductModel?> getProductById(String id) async {
    final doc = await _productsCollection.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future<List<ProductModel>> getAllProducts() async {
    final snapshot = await _productsCollection.get();
    return snapshot.docs
        .map((d) => ProductModel.fromMap(d.data() as Map<String, dynamic>, d.id))
        .toList();
  }

  Future<void> deleteProduct(String id) async {
    await _productsCollection.doc(id).delete();
  }
}
