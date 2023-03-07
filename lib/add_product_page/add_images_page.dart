import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AddImagesPage extends StatefulWidget {
  const AddImagesPage({ Key? key, required this.images }) : super(key: key);

  @override
  State<AddImagesPage> createState() => _AddImagesPageState();

  final List<File> images;
}

class _AddImagesPageState extends State<AddImagesPage> {
  @override
  void initState() {
    super.initState();

    _images.addAll(widget.images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back), 
        onPressed: () => Navigator.of(context).pop<List<File>>(_images)
      ),
      title: const Text('Images')
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(child: _buildImagesList()),

        _buildAddButton()
      ]
    );
  }

  Widget _buildImagesList() {
    if(_images.isEmpty) {
      const Center(child: Text('No Images added'));
    }

    return ReorderableListView.builder(
      itemCount: _images.length,
      itemBuilder: (context, index) {
        return _buildAddedImageTile(_images[index], key: Key(_images[index].path));
      },
      onReorder: (oldIndex, newIndex) {
        setState(
          () {
            final File image = _images[oldIndex];
            _images.removeAt(oldIndex);
            _images.insert(newIndex, image);
          }
        );
      }
    );
  }

  Widget _buildAddedImageTile(final File image, {Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(        
        leading: Image(image: FileImage(image)),
        title: Text(path.basename(image.path)),
        trailing: IconButton(
          icon: const Icon(Icons.delete), 
          onPressed:() => setState(() => _images.remove(image))
        )
      ),
    );
  }

  Widget _buildAddButton() {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      height: 64.0,
      width: double.infinity,      
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder())
        ),
        child: Text('Add', style: TextStyle(fontSize: theme.textTheme.headline6!.fontSize)),
        onPressed: () async {
          final ImagePicker imagePicker = ImagePicker();
          final XFile? pickedImageXFile = await imagePicker.pickImage(source: ImageSource.gallery);
          if(pickedImageXFile == null)
            return;

          final File pickedImage = File(pickedImageXFile.path);
          setState(() => _images.add(pickedImage));
        }
      ),
    );
  }


  final List<File> _images = <File>[];
}