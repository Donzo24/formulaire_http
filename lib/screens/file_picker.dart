import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilePickerPage extends StatefulWidget {
  const FilePickerPage({super.key});

  @override
  State<FilePickerPage> createState() => _FilePickerPageState();
}

class _FilePickerPageState extends State<FilePickerPage>
    with SingleTickerProviderStateMixin {
    late AnimationController _controller;

    List<PlatformFile> files = [];

    @override
    void initState() {
      super.initState();
      _controller = AnimationController(vsync: this);
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            selectFile();
          },
          child: Icon(Icons.file_download),
        ),
        body: SafeArea(
          child: ListView(
            children: files.map((file) {
              return Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  child: ListTile(
                    title: Text(file.name),
                    subtitle: Text(file.path!),
                  ),
                ),
              );
            }).toList(),
          )
        ),
      );
    }
    
    Future<void> selectFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if(result != null) {
        // result.files
        result.files.forEach((item) {
          files.add(item);
        });

        setState(() {});
      }
    }
}