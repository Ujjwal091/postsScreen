import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _isSelected = false;
  final String _dpUrl =
      "https://images.unsplash.com/photo-1674653297566-8b9b7dcccf56?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0MHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60";
  final List<String> _clubs = ['Football', 'Codding', 'Singing', 'ToastMaster'];
  final List<String> _choices = ['Discard', 'Save as draft'];

  void changeStateToTrue() {
    setState(() {
      _isSelected = true;
    });
  }

  void changeStateToFalse() {
    setState(() {
      _isSelected = false;
    });
  }

  void post() {
    print('User hit the post button ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: (() => Navigator.of(context).pop()),
        ),
        title: const Text("Upload"),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                child: ElevatedButton(
                  onPressed: _isSelected ? post : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Post(
          post: post,
          changeStateTOTrue: changeStateToTrue,
          changeStateToFalse: changeStateToFalse,
          clubs: _clubs,
          choices: _choices,
          dpUrl: _dpUrl,
        ),
      ),
    );
  }
}

class Post extends StatefulWidget {
  final VoidCallback post;
  final VoidCallback changeStateTOTrue;
  final VoidCallback changeStateToFalse;
  final List<String> clubs;
  final List<String> choices;
  final String dpUrl;

  const Post({
    super.key,
    required this.post,
    required this.changeStateTOTrue,
    required this.changeStateToFalse,
    required this.clubs,
    required this.choices,
    required this.dpUrl,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  String? _dropdownValue;
  bool _isSelected = false;

  void handleClick(String popUpOption) {
    switch (popUpOption) {
      case 'Discard':
        break;
      case 'Save as draft':
        break;
    }
  }

  late File _image;

  Future _pickCameraImage() async {
    try {
      final image = (await ImagePicker().pickImage(source: ImageSource.camera));
      if (image == null) return;

      final imageTemporary = File(image.path);
      _image = imageTemporary;
      _editImage();
      setState(() {
        _isSelected = true;
        widget.changeStateTOTrue();
      });
    } on PlatformException {
      print('failed to pick image');
    }
  }

  Future _pickGalleryImage() async {
    try {
      final image =
          (await ImagePicker().pickImage(source: ImageSource.gallery));
      if (image == null) return;

      late File imageTemporary;
      imageTemporary = File(image.path);
      _image = imageTemporary;
      _editImage();
      setState(() {
        _isSelected = true;
        widget.changeStateTOTrue();
      });

    } on PlatformException {
      print('failed to pick image');
    }
  }

  Future _editImage() async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: _image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit Photo',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          activeControlsWidgetColor: Colors.blue,
          // statusBarColor:
        ),
        IOSUiSettings(
          title: 'Edit Photo',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedImage == null) {
      return;
    } else {
      setState(() {
        _image = File(croppedImage.path);
      });
    }
  }

  void _cancelPost() {
    setState(() {
      _isSelected = false;
      widget.changeStateToFalse();
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double width = mediaQuery.size.width;
    double height = mediaQuery.size.height - mediaQuery.padding.top;

    return Card(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        print("dp clicked!!");
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        height: width < height ? width * 0.1 : height * 0.1,
                        width: width < height ? width * 0.1 : height * 0.1,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(230, 230, 230, 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(80)),
                          image: DecorationImage(
                            image: NetworkImage(widget.dpUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Posting to:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.only(left: 8),
                      height: width < height ? width * 0.09 : height * 0.09,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                      ),
                      child: DropdownButton(
                        hint: const Text(
                          "Select a Club",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        underline: Container(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        value: _dropdownValue,
                        items: widget.clubs
                            .map<DropdownMenuItem<String>>((String club) {
                          return DropdownMenuItem(
                            value: club,
                            child: Text(club),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _dropdownValue = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                PopupMenuButton(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  padding: const EdgeInsets.only(right: 20),
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    return widget.choices.map((choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  maxLines: 1,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20, top: 20),
                    hintText: "What's in your mind?",
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                  maxLength: 200,
                  cursorColor: Colors.black,

                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {
                    print("emoji button clicked");
                  },
                  icon: const Icon(Icons.emoji_emotions),
                  // style: const ButtonStyle(),
                ),
              )
            ],
          ),
          _isSelected
              ? Container(
                  height: height < width ? height : width,
                  width: height < width ? height : width,
                  padding: const EdgeInsets.only(top: 10, right: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: const Color.fromRGBO(200, 200, 200, 1),
                    image: DecorationImage(image: FileImage(_image)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: _editImage,
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: IconButton(
                            onPressed: _cancelPost,
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _pickCameraImage,
                      icon: const Icon(Icons.camera_alt),
                      iconSize: height < width ? height * 0.07 : width * 0.07,
                    ),
                    IconButton(
                      onPressed: _pickGalleryImage,
                      icon: const Icon(Icons.photo_library),
                      iconSize: height < width ? height * 0.07 : width * 0.07,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bar_chart_outlined),
                      iconSize: height < width ? height * 0.07 : width * 0.07,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _isSelected,
                child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: ElevatedButton(
                    onPressed: widget.post,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Post",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
