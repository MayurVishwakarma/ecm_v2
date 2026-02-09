import 'package:easy_localization/easy_localization.dart';
import '../../../Core/Models/ECMReportModel.dart';
import '../../../Core/Providers/AuthProvider.dart';
import '../../../Core/Providers/ProjectProvider.dart';
import '../../../Utils/Functions/ImagePriviewWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

final ImagePicker picker = ImagePicker();

class EcmImagePicker extends StatefulWidget {
  final bool isEdit;
  const EcmImagePicker({super.key, required this.isEdit});

  @override
  State<EcmImagePicker> createState() => _EcmImagePickerState();
}

class _EcmImagePickerState extends State<EcmImagePicker> {
  @override
  Widget build(BuildContext context) {
    final ep = Provider.of<ProjectProvider>(context);
    List<EcmReportMasterModel>? imageList = ep.checklistModel!
        .where((e) => e.inputType == 'image')
        .toList();
    final hasImage = imageList.any(
      (e) =>
          e.processId ==
              ep.checklistModel!
                  .where((e) => e.inputType == 'image')
                  .toList()
                  .first
                  .processId &&
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
                    child: Consumer<ProjectProvider>(
                      builder: (context, ep, _) {
                        final imageList = ep.checklistModel!
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

  Widget _buildImageListItem(EcmReportMasterModel imageItem) {
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
              imageItem.description ?? '',
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

  void _previewAlert(EcmReportMasterModel model) {
    final provider = Provider.of<ProjectProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false);
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
                  if (widget.isEdit)
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

                        if (ap.selectedProject != null &&
                            [40040, 40030].contains(ap.selectedProject?.id))
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

  void _uploadAlert(EcmReportMasterModel imageItem) {
    final provider = Provider.of<ProjectProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text('Please upload media'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if ((ap.selectedProject?.id) != null &&
                [40040, 40030].contains(
                  ap.selectedProject?.id,
                )) // For specific projects only
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('From Gallery'),
                onPressed: () {
                  Navigator.pop(context);
                  provider.pickImage(ImageSource.gallery, imageItem, context);
                  setState(() {});
                },
              ),

            ElevatedButton.icon(
              icon: const Icon(Icons.camera),
              label: Text('Take Picture'.tr()), //From Camera
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
