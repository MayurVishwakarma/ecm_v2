// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, avoid_print, file_names

import 'dart:io';
import 'package:ecm_v2/Widgets/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class RaiseComplaintScreen extends StatefulWidget {
  const RaiseComplaintScreen({super.key});

  @override
  State<RaiseComplaintScreen> createState() => _RaiseComplaintScreenState();
}

class _RaiseComplaintScreenState extends State<RaiseComplaintScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final List<File> _images = [];
  final List<PlatformFile> _files = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile>? picked = await _picker.pickMultiImage();
    if (picked != null && picked.isNotEmpty) {
      setState(() {
        _images.addAll(picked.map((x) => File(x.path)));
      });
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _files.addAll(result.files);
      });
    }
  }

  void _submitComplaint() {
    String title = _titleController.text.trim();
    String desc = _descController.text.trim();

    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    //print("Complaint Title: $title");
    //print("Description: $desc");
    //print("Images: ${_images.length}");
    //print("Files: ${_files.length}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Complaint submitted successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonAppbar(context, "Raise Complaint", 'Help me'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Complaint Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Complaint Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Upload Images Section
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.image),
                  label: const Text("Add Images"),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _pickFiles,
                  icon: const Icon(Icons.attach_file),
                  label: const Text("Add Files"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Show selected images
            if (_images.isNotEmpty) ...[
              const Text("Selected Images:"),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: Image.file(
                            _images[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _images.removeAt(index);
                              });
                            },
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Show selected files
            if (_files.isNotEmpty) ...[
              const Text("Selected Files:"),
              const SizedBox(height: 8),
              Column(
                children: _files.map((f) {
                  return ListTile(
                    leading: const Icon(
                      Icons.insert_drive_file,
                      color: Colors.blue,
                    ),
                    title: Text(f.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _files.remove(f);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _submitComplaint,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  backgroundColor: Colors.red,
                ),
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
