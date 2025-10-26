// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Models/Routine/RoutineReportModel.dart';
import 'package:ecm_v2/Core/Providers/RoutineProvider.dart';
import 'package:ecm_v2/Utils/Functions/ImagePriviewWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

final ImagePicker picker = ImagePicker();

class RoutineImageDialog extends StatefulWidget {
  const RoutineImageDialog({super.key});

  @override
  State<RoutineImageDialog> createState() => _DamageImagePickerState();
}

class _DamageImagePickerState extends State<RoutineImageDialog> {
  @override
  Widget build(BuildContext context) {
    final ep = Provider.of<RoutineProvider>(context);
    List<RoutineReportModel>? imageList = ep.routineReport!
        .where((e) => e.inputType == 'image')
        .toList();
    final hasImage = imageList.any(
      (e) =>
          e.id ==
              ep.routineReport!
                  .where((e) => e.inputType == 'image')
                  .toList()
                  .first
                  .id &&
          e.inputType == 'image' &&
          e.value != null,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  icon: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  content: SizedBox(
                    width: 500,
                    child: Consumer<RoutineProvider>(
                      builder: (context, ep, _) {
                        final imageList = ep.routineReport!
                            .where((e) => e.inputType == 'image')
                            .toList();
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: imageList.length,
                          itemBuilder: (_, index) =>
                              _buildImageListItem(imageList[index]),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            child: Image.asset(
              hasImage
                  ? 'assets/images/view-image.png'
                  : 'assets/images/upload-image.png',
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            hasImage ? 'image'.tr() : 'Noimage'.tr(),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildImageListItem(dynamic imageItem, {bool isInfo = false}) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        trailing: SizedBox(
          width: 50,
          height: 50,
          child: imageItem.imageByteArray != null
              ? InkWell(
                  onTap: () => _previewAlert(imageItem),
                  child: Image.memory(
                    imageItem.imageByteArray!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              : GestureDetector(
                  onTap: () => _uploadAlert(imageItem),
                  child: Image.asset(
                    'assets/images/upload-image.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getImageTitle(item: imageItem, isInfo: isInfo),
              // imageItem.damage ?? '',
              style: const TextStyle(color: Colors.green, fontSize: 15),
            ),
            if (imageItem.imageByteArray != null)
              Text(
                "Size: ${(imageItem.imageByteArray!.lengthInBytes / 1024).toStringAsFixed(2)} KB",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  String getImageTitle({dynamic item, bool isInfo = false}) {
    try {
      var title = isInfo ? item.infoDescription : item.damage;
      return title;
    } catch (e) {
      return 'Image';
    }
  }

  void _previewAlert(dynamic model) {
    final provider = Provider.of<RoutineProvider>(context, listen: false);
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
          content: Container(
            margin: const EdgeInsets.only(left: 4, right: 4, bottom: 7),
            child: Padding(
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

                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            provider.deleteImage(model);
                            Navigator.pop(context);
                            setState(() {}); // refresh immediately
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            provider.pickImage(
                              ImageSource.gallery,
                              model,
                              context,
                            );
                            setState(() {});
                          },
                          icon: const Icon(Icons.image),
                          label: const Text('From Gallery'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            provider.pickImage(
                              ImageSource.camera,
                              model,
                              context,
                            );
                            setState(() {});
                          },
                          icon: const Icon(Icons.camera),
                          label: const Text('From Camera'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _uploadAlert(dynamic imageItem) {
    final provider = Provider.of<RoutineProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text('Please choose media to select'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /*ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('From Gallery'),
              onPressed: () {
                Navigator.pop(context);
                provider.pickImage(ImageSource.gallery, imageItem, context);
                setState(() {});
              },
            ),*/
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Picture'),
              onPressed: () {
                Navigator.pop(context);
                provider.pickImage(ImageSource.camera, imageItem, context);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
