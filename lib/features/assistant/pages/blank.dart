import 'package:chatbot_ai/features/assistant/bloc/knowledge_bloc.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_event.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_state.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

class BlankPage extends StatefulWidget {
  const BlankPage({super.key});

  @override
  State<BlankPage> createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  KnowledgeBloc bloc = KnowledgeBloc();

  List<String?> _fileNames = [];
  List<String?> _filePaths = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _fileNames = result.files.map((f) => f.name).toList();
        _filePaths = result.files.map((f) => f.path).toList();
      });
    }
  }

  void _uploadFiles() {
    if (_filePaths.isNotEmpty) {
      final files = _filePaths.whereType<String>().map((path) => File(path)).toList();
      bloc.add(EventUploadFiles(files: files));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocListener<KnowledgeBloc, KnowledgeState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is StateUploadFiles) {
            if (state.isSuccess == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Files uploaded successfully!')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File upload failed.')),
              );
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Blank File Picker'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _pickFiles,
                  child: const Text('Pick Files'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _filePaths.isNotEmpty ? _uploadFiles : null,
                  child: const Text('Upload Files'),
                ),
                const SizedBox(height: 24),
                if (_fileNames.isNotEmpty) ...[
                  const Text('Selected Files:'),
                  ..._fileNames.map((name) => Text(name ?? 'Unknown')).toList(),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
