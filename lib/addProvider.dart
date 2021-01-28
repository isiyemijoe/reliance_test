import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reliance_engineer_test/dialogs/inputDialog.dart';
import 'package:reliance_engineer_test/network.dart';
import 'package:reliance_engineer_test/stringAssets.dart';

import 'AppEngine.dart';
import 'model/provider.dart';
import 'staticItems.dart';

class AddProvider extends StatefulWidget {
  bool isUpdate;
  Provider provider;
  AddProvider({this.isUpdate, this.provider});
  @override
  _AddProviderState createState() => _AddProviderState();
}

class _AddProviderState extends State<AddProvider> {
  String error = "";
  List states = [];
  List providerTypes = [];
  TextEditingController stateController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _ratingController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  FocusNode _nameNode = FocusNode();
  String state = "";
  String status = "";
  String providerType = "";
  double rating = 1.0;
  File _image;
  String providerType_id;
  String state_id;
  List<File> files = [];
  List<dynamic> images = [];
  bool isUpdate;
  final picker = ImagePicker();
  NetworkService _networkService = NetworkService();
  Provider _provider;
  String successMessage = "is now registered on your network";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isUpdate = widget.isUpdate ?? false;
    if (isUpdate) {
      _provider = widget.provider;
      successMessage = "has been updated successfully";
      populateFields();
    }
  }

  populateFields() {
    _nameController.text = _provider.name;
    _addressController.text = _provider.address ?? "";
    state = _provider.state.name ?? "";
    providerType = _provider.providerType.name ?? "";
    status = _provider.activeStatus ?? "";
    _descController.text = _provider.description ?? "";
    state_id = _provider.state.id.toString();
    providerType_id = _provider.providerType.id.toString();
    rating = _provider.rating.toDouble() ?? 1.0;

    if (_provider.images.isNotEmpty) {
      for (Images img in _provider.images) {
        images.add(img.url);
        print(img.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: Column(
          children: [
            Container(
              color: white,
              width: double.infinity,
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Center(
                            child: Icon(
                          Icons.keyboard_backspace,
                          color: black,
                          size: 23,
                        )),
                      )),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: new Text(
                      "New Provider",
                      style: textStyle(true, 18, black),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 350),
              width: double.infinity,
              height: error.isEmpty ? 0 : 40,
              color: Colors.red,
              child: Center(
                child: Text(
                  error,
                  style: textStyle(false, 16, white),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            DottedBorder(
                                dashPattern: [8, 4],
                                strokeWidth: 2,
                                strokeCap: StrokeCap.round,
                                color: secondaryColor.withOpacity(0.6),
                                child: Container(
                                  color: secondaryColor.withOpacity(0.20),
                                  width: double.infinity,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            getImage();
                                          },
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.add_a_photo,
                                                size: 30,
                                                color: secondaryColor,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Click to add Image",
                                                style: textStyle(false, 16,
                                                    black.withOpacity(0.6)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (images.isNotEmpty)
                                          Container(
                                            height: 70,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                20,
                                            margin: EdgeInsets.fromLTRB(
                                                10, 10, 10, 0),
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: images.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Stack(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10, right: 10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        height: 60,
                                                        width: 60,
                                                        child: ClipRRect(
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: images[index]
                                                                    is File
                                                                ? Image.file(
                                                                    images[
                                                                        index],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : CachedNetworkImage(
                                                                    placeholder: (context, url) => Center(
                                                                        child: SizedBox(
                                                                            height: 20,
                                                                            width: 20,
                                                                            child: CircularProgressIndicator(
                                                                              strokeWidth: 1.5,
                                                                            ))),
                                                                    imageUrl:
                                                                        images[
                                                                            index],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )),
                                                      ),
                                                      Positioned(
                                                        right: 0,
                                                        top: 0,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            if (images
                                                                is File) {
                                                              files.remove(
                                                                  files[index]);
                                                            } else {}
                                                            images.remove(
                                                                images[index]);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            height: 20,
                                                            width: 20,
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    shape: BoxShape
                                                                        .circle),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.clear,
                                                                color: white,
                                                                size: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                }),
                                          ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                )),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              child: RatingBar.builder(
                                initialRating: _provider == null
                                    ? 0.0
                                    : _provider.rating.toDouble(),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rate) {
                                  rating = rate;
                                  setState(() {});
                                },
                              ),
                            ),
                            inputTextView("Name", "", _nameController,
                                node: _nameNode, isNum: false),
                            clickText("State", state, () {
                              {
                                _nameNode.unfocus();

                                if (states.isEmpty) {
                                  print("before showProgress");
                                  showProgress(
                                    true,
                                    context,
                                  );
                                  callApi(
                                    BASE_URL + "states",
                                    context,
                                    (result, error) async {
                                      showProgress(false, context);
                                      if (error != null) {
                                        handleError(context, error.toString());
                                        return;
                                      }
                                      await Future.delayed(
                                          Duration(milliseconds: 200));
                                      states = jsonDecode(result.body);
                                      showListDialog(context, "States",
                                          getListFromMap("name", states),
                                          result: (_) {
                                        state = _;
                                        state_id =
                                            getItemFromMap(_, "id", states)
                                                .toString();
                                        setState(() {});
                                      });
                                    },
                                    getMethod: true,
                                  );
                                } else {
                                  showListDialog(context, "States",
                                      getListFromMap("name", states),
                                      result: (_) {
                                    state = _;
                                    state_id = getItemFromMap(_, "id", states)
                                        .toString();
                                    setState(() {});
                                  });
                                }
                              }
                            }, clickAdd: () {
                              inputDialog(context, "Add State", result: (_) {
                                print("$_ is the state added");
                              });
                            }),
                            clickText("provider Type", providerType, () {
                              {
                                _nameNode.unfocus();
                                if (providerTypes.isEmpty) {
                                  showProgress(
                                    true,
                                    context,
                                  );
                                  callApi(
                                    BASE_URL + "provider-types",
                                    context,
                                    (result, error) async {
                                      showProgress(false, context);
                                      if (error != null) {
                                        handleError(context, error.toString());
                                        return;
                                      }
                                      await Future.delayed(
                                          Duration(milliseconds: 200));
                                      providerTypes = jsonDecode(result.body);
                                      showListDialog(context, "Provider Types",
                                          getListFromMap("name", providerTypes),
                                          result: (_) {
                                        providerType = _;
                                        providerType_id = getItemFromMap(
                                                _, "id", providerTypes)
                                            .toString();
                                        setState(() {});
                                      });
                                    },
                                    getMethod: true,
                                  );
                                } else {
                                  showListDialog(context, "Provider Types",
                                      getListFromMap("name", providerTypes),
                                      result: (_) {
                                    providerType = _;
                                    providerType_id =
                                        getItemFromMap(_, "id", providerTypes)
                                            .toString();
                                    setState(() {});
                                  });
                                }
                              }
                            }, clickAdd: () {
                              inputDialog(context, "Add Provider Type",
                                  result: (_) {
                                print("$_ is the Provider added");
                              });
                            }),
                            clickText(
                              "Status",
                              status,
                              () {
                                showListDialog(context, "Status", [
                                  "Active",
                                  "Pending",
                                  "Deleted"
                                ], result: (_) {
                                  status = _;
                                  setState(() {});
                                });
                              },
                            ),
                            inputTextView("Description", "", _descController,
                                maxline: 3, isNum: false),
                            inputTextView("Address", "", _addressController,
                                maxline: 3, isNum: false),
                            Container(
                              width: double.infinity,
                              height: 50,
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: FlatButton(
                                color: primaryColor,
                                onPressed: () {
                                  saveProvider();
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Text(
                                  "Save",
                                  style: textStyle(false, 16, white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        files.add(_image);
        images.add(_image);
        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void saveProvider() async {
    String name = _nameController.text;
    String description = _descController.text;
    String address = _addressController.text;

    if (name.isEmpty) {
      showError("Provider Name cannot be empty");
      return;
    }
    if (state.isEmpty) {
      showError("Provider's State cannot be empty");
      return;
    }
    if (providerType.isEmpty) {
      showError("Provider type cannot be empty");
      return;
    }
    if (status.isEmpty) {
      showError("Provider status cannot be empty");
      return;
    }
    if (description.isEmpty) {
      showError("Provider description cannot be empty");
      return;
    }
    if (address.isEmpty) {
      showError("Provider address cannot be empty");
      return;
    }
    showProgress(
      true,
      context,
    );
    print("before sending request");
    await _networkService
        .saveProvider(
            isUpdate,
            _provider == null ? "0" : _provider.id.toString(),
            context,
            name,
            status,
            state_id,
            providerType_id,
            description,
            address,
            rating.toString())
        .then((dynamic value) async {
      print("after sending request ${value["id"]}");

      if (value != null) {
        if (files.isNotEmpty) {
          callApiWithFile(
              files, value["id"].toString(), context, BASE_URL + "upload/",
              (response, error) async {
            showProgress(
              false,
              context,
            );
            if (error != null) {
              await alertDialog(
                  context,
                  " Partialy Successful",
                  "$name $successMessage, \n error loading images",
                  Icons.error_outline,
                  iconColor: Colors.green,
                  yesText: "Ok", result: (_) {
                print("got here");
                Navigator.pop(context, true);
                return;
              });
              Navigator.pop(context, true);
              return;
            }
            await alertDialog(context, "Successful", "$name $successMessage",
                Icons.error_outline, iconColor: Colors.green, yesText: "Ok",
                result: (_) {
              print("got here");
              Navigator.pop(context, true);
              return;
            });
          });
          return;
        }
        await alertDialog(
            context, "Successful", "$name $successMessage", Icons.check,
            iconColor: Colors.green, yesText: "Ok", result: (_) {
          print("got here");
          Navigator.pop(context, true);
          return;
        });

        Navigator.pop(context, true);
        return;
      }
    });
    return;
  }

  showError(String text) {
    setState(() {
      error = text;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        error = "";
      });
    });
  }
}
