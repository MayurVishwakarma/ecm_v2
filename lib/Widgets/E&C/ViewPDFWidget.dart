// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:ecm_v2/Core/Models/ECMReportModel.dart';
import 'package:ecm_v2/Core/Providers/ProjectProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class PdfWidget extends StatefulWidget {
  final dynamic report;
  const PdfWidget({super.key, required this.report});

  @override
  State<PdfWidget> createState() => _PdfWidgetState();
}

class _PdfWidgetState extends State<PdfWidget> {
  EcmReportMasterModel? item;

  @override
  void initState() {
    super.initState();
    item = widget.report;
  }

  @override
  Widget build(BuildContext context) {
    final ep = Provider.of<ProjectProvider>(context, listen: false);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.all(12),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "PDF Actions",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SizedBox(
        width: 300,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildActionButton(
              icon: Icons.upload_file,
              label: "Upload PDF",
              color: Colors.green,
              onTap: () async {
                try {
                  XFile? file = await _pickPdf(item!);
                  if (file != null) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a valid PDF file."),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              },
            ),
            if (item?.image != null && item?.value == null)
              _buildActionButton(
                icon: Icons.picture_as_pdf,
                label: "View PDF",
                color: Colors.blue,
                onTap: () async {
                  await OpenFile.open(item?.image?.path);
                },
              ),
            if (item?.value != null)
              _buildActionButton(
                icon: Icons.picture_as_pdf,
                label: "View PDF",
                color: Colors.blue,
                onTap: () async {
                  ep.viewPdfByFileName(
                    item!.imageByteArray,
                    ep.getNodeName(ep.source!, ep.selectedNode!),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// Pick only PDF files and save a copy into external storage
  Future<XFile?> _pickPdf(EcmReportMasterModel model) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.single;

      if (pickedFile.path != null &&
          pickedFile.extension?.toLowerCase() == 'pdf') {
        final savedFile = XFile(pickedFile.path!);

        model.image = savedFile;
        model.imageByteArray = await savedFile.readAsBytes();

        return savedFile;
      }
    }
    return null;
  }
}
