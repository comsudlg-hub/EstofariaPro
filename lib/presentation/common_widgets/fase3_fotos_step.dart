// lib/presentation/common_widgets/fase3_fotos_step.dart
//
// Ajustes aplicados:
// - Substituição de ElevatedButton por CustomButton padronizado.
// - Uso de EmptyState quando não houver fotos.
// - Mantida compressão, suporte web, feedback UX e arquitetura.

import 'dart:io' show File, Platform;
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../data/services/pedido_orcamento_helper.dart';
import '../common_widgets/custom_button.dart';
import '../common_widgets/empty_state.dart';

class Fase3FotosStep extends StatefulWidget {
  final String docId;
  final VoidCallback? onStepComplete;

  const Fase3FotosStep({super.key, required this.docId, this.onStepComplete});

  @override
  State<Fase3FotosStep> createState() => _Fase3FotosStepState();
}

class _Fase3FotosStepState extends State<Fase3FotosStep> {
  final List<String> _fotosUrls = [];
  final List<UploadTask> _uploadsAtivos = [];
  static const int _maxFotos = 5;

  Future<void> _adicionarFoto() async {
    if (_fotosUrls.length >= _maxFotos) return;

    try {
      XFile? pickedFile;

      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final picker = ImagePicker();
        pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
        if (pickedFile == null) return;
      } else {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );
        if (result == null) return;
        if (result.files.single.path != null) {
          pickedFile = XFile(result.files.single.path!);
        } else {
          final bytes = result.files.single.bytes;
          if (bytes == null) return;
          pickedFile = XFile.fromData(bytes,
              name: "${DateTime.now().millisecondsSinceEpoch}.jpg");
        }
      }

      final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("pedidos_orcamento/${widget.docId}/$fileName");

      if (kIsWeb) {
        final bytes = await pickedFile!.readAsBytes();
        final uploadTask =
            storageRef.putData(bytes, SettableMetadata(contentType: "image/jpeg"));
        setState(() => _uploadsAtivos.add(uploadTask));
        final snapshot = await uploadTask.whenComplete(() {});
        final url = await snapshot.ref.getDownloadURL();
        setState(() {
          _fotosUrls.add(url);
          _uploadsAtivos.remove(uploadTask);
        });
        await PedidoOrcamentoHelper().salvarFotos(
          docId: widget.docId,
          fotos: _fotosUrls,
        );
      } else {
        final file = File(pickedFile!.path);
        Uint8List? compressedBytes;
        try {
          compressedBytes = await FlutterImageCompress.compressWithFile(
            file.absolute.path,
            quality: 75,
            format: CompressFormat.jpeg,
            keepExif: false,
          );
        } catch (e) {
          compressedBytes = await file.readAsBytes();
        }
        final bytesToUpload = compressedBytes ?? await file.readAsBytes();
        final uploadTask =
            storageRef.putData(bytesToUpload, SettableMetadata(contentType: "image/jpeg"));
        setState(() => _uploadsAtivos.add(uploadTask));
        final snapshot = await uploadTask.whenComplete(() {});
        final url = await snapshot.ref.getDownloadURL();
        setState(() {
          _fotosUrls.add(url);
          _uploadsAtivos.remove(uploadTask);
        });
        await PedidoOrcamentoHelper().salvarFotos(
          docId: widget.docId,
          fotos: _fotosUrls,
        );
      }

      widget.onStepComplete?.call();
    } catch (e, st) {
      debugPrint("Erro ao enviar foto: $e\n$st");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao enviar foto: ${e.toString()}")),
      );
    }
  }

  void _removerFoto(int index) async {
    final url = _fotosUrls[index];
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
      setState(() => _fotosUrls.removeAt(index));
      await PedidoOrcamentoHelper().salvarFotos(
        docId: widget.docId,
        fotos: _fotosUrls,
      );
    } catch (e) {
      debugPrint("Erro ao remover foto: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao remover foto: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outlineVariant, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              initiallyExpanded: true,
              leading: Icon(Icons.camera_alt_outlined, color: scheme.primary),
              title: Text(
                "Envie suas fotos",
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle:
                  const Text("Adicione até 5 fotos para ajudar na avaliação."),
              children: [
                if (_fotosUrls.isEmpty && _uploadsAtivos.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: EmptyState(
                      icon: Icons.photo_library_outlined,
                      message: "Nenhuma foto enviada ainda",
                      action: CustomButton(
                        label: "Adicionar Foto",
                        onPressed: _adicionarFoto,
                        icon: Icons.add_a_photo,
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (int i = 0; i < _fotosUrls.length; i++)
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                _fotosUrls[i],
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                color: Colors.white,
                                onPressed: () => _removerFoto(i),
                                tooltip: 'Remover foto',
                              ),
                            ),
                          ],
                        ),
                      if (_fotosUrls.length < _maxFotos)
                        GestureDetector(
                          onTap: _adicionarFoto,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: scheme.outline),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add_a_photo_outlined,
                                      color: scheme.primary),
                                  const SizedBox(height: 8),
                                  Text("Adicionar",
                                      style: textTheme.bodySmall),
                                ],
                              ),
                            ),
                          ),
                        ),
                      for (final up in _uploadsAtivos)
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: Center(
                            child: StreamBuilder<TaskSnapshot>(
                              stream: up.snapshotEvents,
                              builder: (context, snap) {
                                final data = snap.data;
                                final progress = data != null &&
                                        data.totalBytes > 0
                                    ? data.bytesTransferred / data.totalBytes
                                    : 0.0;
                                return CircularProgressIndicator(value: progress);
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: "Adicionar Foto",
                          onPressed: _adicionarFoto,
                          icon: Icons.upload_file,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          label: "Salvar",
                          onPressed: () async {
                            try {
                              await PedidoOrcamentoHelper().salvarFotos(
                                docId: widget.docId,
                                fotos: _fotosUrls,
                              );
                              widget.onStepComplete?.call();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Fotos salvas com sucesso.")),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Erro ao salvar fotos: $e")),
                              );
                            }
                          },
                          icon: Icons.save,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
