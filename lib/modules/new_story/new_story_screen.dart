
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_maker/story_maker.dart';

class NewStoryScreen extends StatefulWidget {
  const NewStoryScreen({Key? key}) : super(key: key);

  @override
  State<NewStoryScreen> createState() => _NewStoryScreenState();
}

class _NewStoryScreenState extends State<NewStoryScreen> {
  File? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Designer Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final pickedFile =
                await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  final editedFile = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StoryMaker(
                        filePath: pickedFile.path,
                      ),
                    ),
                  );
                  setState(() {
                    image = editedFile;
                  });
                  print('editedFile: ${image?.path}');
                }
              },
              child: const Text('Pick Image'),
            ),
            if (image != null)
              Expanded(
                child: Image.file(image!),
              ),
          ],
        ),
      ),
    );
  }
}
