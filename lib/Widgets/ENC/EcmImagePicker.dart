import 'package:easy_localization/easy_localization.dart';
import '../../../Core/Models/ECMReportModel.dart';
import '../../../Core/Providers/AuthProvider.dart';
import '../../../Core/Providers/ProjectProvider.dart';
import '../../../Utils/Functions/ImagePriviewWidget.dart';
import '../../../Utils/Themes/color_manager.dart';
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
    final imageList = (ep.checklistModel ?? [])
        .where((e) => e.inputType == 'image')
        .toList();

    if (imageList.isEmpty) return const SizedBox.shrink();

    final uploadedCount = imageList.where(_hasImage).length;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: _showImageDialog,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              _buildStackedImages(imageList),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$uploadedCount/${imageList.length} ${'img'.tr()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      uploadedCount > 0 ? 'image'.tr() : 'Noimage'.tr(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ColorManager.ecoGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: ColorManager.ecoGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStackedImages(List<EcmReportMasterModel> imageList) {
    final visibleImages = imageList.take(4).toList();

    return SizedBox(
      width: 150,
      height: 76,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < visibleImages.length; i++)
            Positioned(
              left: i * 28,
              child: _buildStackedThumbnail(
                visibleImages[i],
                showMore: i == visibleImages.length - 1 && imageList.length > 4,
                remaining: imageList.length - 4,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStackedThumbnail(
    EcmReportMasterModel imageItem, {
    required bool showMore,
    required int remaining,
  }) {
    return Container(
      width: 66,
      height: 76,
      decoration: BoxDecoration(
        color: ColorManager.pureWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorManager.pureWhite, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageItem.imageByteArray != null)
              Image.memory(imageItem.imageByteArray!, fit: BoxFit.cover)
            else
              Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.all(14),
                child: Image.asset(
                  'assets/images/upload-image.png',
                  fit: BoxFit.contain,
                ),
              ),
            if (showMore)
              Container(
                color: Colors.black.withValues(alpha: 0.52),
                alignment: Alignment.center,
                child: Text(
                  '+$remaining',
                  style: const TextStyle(
                    color: ColorManager.pureWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog() {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: SizedBox(
          width: 500,
          child: Consumer<ProjectProvider>(
            builder: (context, ep, _) {
              final imageList = (ep.checklistModel ?? [])
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
  }

  Widget _buildImageListItem(EcmReportMasterModel imageItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: ColorManager.pureWhite,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        trailing: SizedBox(
          width: 56,
          height: 56,
          child: imageItem.imageByteArray != null
              ? InkWell(
                  onTap: () => _previewAlert(imageItem),
                  borderRadius: BorderRadius.circular(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      imageItem.imageByteArray!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () => _uploadAlert(imageItem),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorManager.ecoGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/images/upload-image.png',
                      width: 56,
                      height: 56,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              imageItem.description ?? '',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
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

  bool _hasImage(EcmReportMasterModel item) {
    final value = item.value?.toString().trim();
    return item.imageByteArray != null || (value != null && value.isNotEmpty);
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
                            [40040, 40030, 40042].contains(ap.selectedProject?.id))
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
                [40040, 40030,40042].contains(
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
