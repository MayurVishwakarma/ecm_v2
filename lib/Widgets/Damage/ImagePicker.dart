import '../../../Core/Providers/DamageProvider.dart';
import '../../../Utils/Functions/ImagePriviewWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageDialogs {
  /// Preview Image Dialog
  static Future<void> showPreviewAlert({
    required BuildContext context,
    required dynamic model,
    required bool isEdit,
    required VoidCallback onRefresh,
  }) async {
    final provider = Provider.of<DamageProvider>(context, listen: false);
    if (model.imageByteArray == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          iconColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PreviewImageWidget(model.imageByteArray!),
                    ),
                  ),
                  child: Image.memory(
                    model.imageByteArray!,
                    fit: BoxFit.fitWidth,
                    width: 250,
                    height: 250,
                  ),
                ),
                const SizedBox(height: 20),
                if (isEdit)
                  Column(
                    children: [
                      _actionBtn(
                        label: "Delete",
                        icon: Icons.delete,
                        bgColor: Colors.red,
                        onPressed: () {
                          provider.deleteImage(model);
                          Navigator.pop(context);
                          onRefresh();
                        },
                      ),
                      _actionBtn(
                        label: "From Gallery",
                        icon: Icons.image,
                        onPressed: () {
                          Navigator.pop(context);
                          provider.pickImage(
                            ImageSource.gallery,
                            model,
                            context,
                          );
                          onRefresh();
                        },
                      ),
                      _actionBtn(
                        label: "From Camera",
                        icon: Icons.camera,
                        onPressed: () {
                          Navigator.pop(context);
                          provider.pickImage(
                            ImageSource.camera,
                            model,
                            context,
                          );
                          onRefresh();
                        },
                      ),
                    ],
                  )
                else
                  const Text(
                    "Enable edit button first to change image",
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Upload Dialog
  static Future<void> showUploadAlert({
    required BuildContext context,
    required dynamic imageItem,
    required VoidCallback onRefresh,
  }) async {
    final provider = Provider.of<DamageProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text("Please choose media to select"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (provider.selectedMenu!.toLowerCase().contains("damage"))
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text("From Gallery"),
                onPressed: () {
                  Navigator.pop(context);
                  provider.pickImage(ImageSource.gallery, imageItem, context);
                  onRefresh();
                },
              ),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Take Picture"),
              onPressed: () {
                Navigator.pop(context);
                provider.pickImage(ImageSource.camera, imageItem, context);
                onRefresh();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Common Button Builder
  static Widget _actionBtn({
    required String label,
    required IconData icon,
    Color bgColor = Colors.blue,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(backgroundColor: bgColor),
      ),
    );
  }
}
