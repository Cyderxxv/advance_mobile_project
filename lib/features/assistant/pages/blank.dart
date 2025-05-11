import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class BlankPage extends StatefulWidget {
  const BlankPage({super.key});

  @override
  State<BlankPage> createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  String? _fileName;
  String? _filePath;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _fileName = result.files.single.name;
        _filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blank File Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Pick a File'),
            ),
            const SizedBox(height: 24),
            if (_fileName != null) ...[
              Text('File Name: $_fileName'),
              const SizedBox(height: 8),
              Text('File Path: $_filePath'),
            ]
          ],
        ),
      ),
    );
  }
}
