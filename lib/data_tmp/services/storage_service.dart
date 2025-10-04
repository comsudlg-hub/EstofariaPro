// Upload/download do Firebase Storage
// lib/data/services/storage_service.dart
// UTF-8

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Faz upload de um arquivo (imagem, PDF etc.)
  /// Retorna a URL pública para download.
  Future<String?> uploadFile({
    required File file,
    required String folder,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      final ref = _storage.ref().child('$folder/$fileName');

      final uploadTask = await ref.putFile(file);
      final url = await uploadTask.ref.getDownloadURL();

      return url;
    } on FirebaseException catch (e) {
      print('Erro Firebase Storage: ${e.message}');
      return null;
    } catch (e) {
      print('Erro inesperado no upload: $e');
      return null;
    }
  }

  /// Faz download do arquivo e salva localmente.
  /// Retorna o arquivo salvo.
  Future<File?> downloadFile({
    required String url,
    required String savePath,
  }) async {
    try {
      final ref = _storage.refFromURL(url);
      final file = File(savePath);
      await ref.writeToFile(file);
      return file;
    } on FirebaseException catch (e) {
      print('Erro Firebase Storage (download): ${e.message}');
      return null;
    } catch (e) {
      print('Erro inesperado no download: $e');
      return null;
    }
  }

  /// Exclui um arquivo do Storage a partir da URL.
  Future<bool> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
      return true;
    } on FirebaseException catch (e) {
      print('Erro Firebase Storage (delete): ${e.message}');
      return false;
    } catch (e) {
      print('Erro inesperado no delete: $e');
      return false;
    }
  }
}
