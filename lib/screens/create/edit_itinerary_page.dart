import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class EditItineraryPage extends StatefulWidget {
  EditItineraryPage(this.itinerary, {Key key}) : super(key: key);

  final Itinerary itinerary;

  @override
  _EditItineraryPageState createState() => _EditItineraryPageState();
}

class _EditItineraryPageState extends State<EditItineraryPage> {
  File _image;
  String _title;
  String _description;
  final picker = ImagePicker();
  String base64Image;
  String errMessage = 'Error Uploading Image';

  bool originalImageDeleted = false;

  @override
  void initState() {
    if (widget.itinerary == null) {
      Provider.of<AppState>(context, listen: false)
          .notificationService
          .showSnackBar(context, '暂时无法获取行程，请稍后再试一试呀！');
    }
    _title = widget.itinerary.title;
    _description = widget.itinerary.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('修改行程'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Builder(builder: (BuildContext context) {
          return ListView(
            children: [
              Container(
                child: getImageBox(),
                width: ScreenUtils.screenWidth(context),
                height: 350,
                decoration:
                    BoxDecoration(color: ColorConstants.BACKGROUND_WHITE),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              Container(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: '标题', border: InputBorder.none),
                      onChanged: (text) {
                        _title = text;
                      },
                      initialValue: widget.itinerary.title,
                    ),
                    Divider(),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: '亮点 / 简介', border: InputBorder.none),
                      onChanged: (text) {
                        _description = text;
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      minLines: 10,
                      initialValue: widget.itinerary.description,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10),
                color: ColorConstants.BACKGROUND_WHITE,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              ),
              TextButton(
                child: Text('修改'),
                onPressed: () async {
                  try {
                    Itinerary itinerary = await appState.editItinerary(
                        itineraryId: widget.itinerary.id,
                        fields: {'title': _title, 'description': _description},
                        filePaths: _image == null ? [] : [_image.path]);
                    Navigator.pop(context, itinerary);
                  } catch (e) {
                    appState.notificationService
                        .showSnackBar(context, '暂时无法修改行程哦，请稍后再试一试呀。');
                  }

                  return;
                },
                style: TextButton.styleFrom(
                    backgroundColor: ColorConstants.BUTTON_PRIMARY,
                    primary: Colors.white,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    )),
              )
            ],
          );
        }),
        backgroundColor: ColorConstants.BACKGROUND_PRIMARY,
      );
    });
  }

  Widget getImageBox() {
    if (widget.itinerary.image != null &&
        widget.itinerary.image.isNotEmpty &&
        !originalImageDeleted) {
      return Stack(
        children: [
          FittedBox(
            child: Container(
              child: Image.network(widget.itinerary.image),
            ),
            fit: BoxFit.cover,
          ),
          Positioned(
            child: IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: ColorConstants.TEXT_RED,
              ),
              onPressed: () {
                setState(() => originalImageDeleted = true);
              },
              padding: EdgeInsets.symmetric(vertical: 30),
            ),
            top: 0,
            right: 0,
          )
        ],
        fit: StackFit.expand,
      );
    } else {
      return _image == null
          ? MaterialButton(
              onPressed: chooseImage,
              child: Text('选择图片'),
            )
          : Stack(
              children: [
                FittedBox(
                  child: Container(
                    child: Image.file(_image),
                  ),
                  fit: BoxFit.cover,
                ),
                Positioned(
                  child: IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: ColorConstants.TEXT_RED,
                    ),
                    onPressed: () {
                      setState(() => _image = null);
                    },
                    padding: EdgeInsets.symmetric(vertical: 30),
                  ),
                  top: 0,
                  right: 0,
                )
              ],
              fit: StackFit.expand,
            );
    }
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
  }
}
