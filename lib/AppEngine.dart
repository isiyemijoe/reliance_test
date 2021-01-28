import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:reliance_engineer_test/dialogs/inputDialog.dart';
import 'package:reliance_engineer_test/dialogs/listDialog.dart';
import 'package:reliance_engineer_test/dialogs/progress.dart';
import 'model/provider.dart';
import 'staticItems.dart';
import 'package:http/http.dart' as http;

import 'stringAssets.dart';

//This function creates a loading dialog
loadingLayout({bool trans = false}) {
  return new Container(
//    color: trans ? transparent : white,
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Center(
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    white.withOpacity(0.2), BlendMode.dstATop),
                image: AssetImage(
                  ic_launcher,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: CircularProgressIndicator(
            //value: 20,
            valueColor:
                AlwaysStoppedAnimation<Color>(trans ? white : primaryColor),
            strokeWidth: 2,
          ),
        ),
      ],
    ),
  );
}

//This function creates a TextStyle widget with the pasded parameter
textStyle(
  bool bold,
  double size,
  color, {
  underlined = false,
}) {
  return TextStyle(
      color: color,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontSize: size,
      decoration: underlined ? TextDecoration.underline : TextDecoration.none);
}

//This function returns a picture link for a provider
//returns a No_Image link if provider contains no image
String imagePick(Provider provider, bool small) {
  String url = "";
  if (provider.images.isNotEmpty) {
    switch (small) {
      case true:
        if (provider.images[0].formats.thumbnail != null) {
          url = provider.images[0].formats.thumbnail.url ?? NO_IMAGE;
        } else if (provider.images[0].formats.small != null) {
          url = provider.images[0].formats.small.url ?? NO_IMAGE;
        } else if (provider.images[0].formats.large != null) {
          url = provider.images[0].formats.large.url ?? NO_IMAGE;
        } else {
          url = NO_IMAGE;
        }
        break;
      case false:
        if (provider.images[0].formats.large != null) {
          url = provider.images[0].formats.large.url ?? NO_IMAGE;
        } else if (provider.images[0].formats.medium != null) {
          url = provider.images[0].formats.medium.url ?? NO_IMAGE;
        } else if (provider.images[0].formats.small != null) {
          url = provider.images[0].formats.small.url ?? NO_IMAGE;
        } else {
          url = NO_IMAGE;
        }
        break;
      default:
        url = NO_IMAGE;
    }
  } else {
    url = NO_IMAGE;
  }
  print(url);
  return url;
}

//This function returns a alertDialog
Future<String> alertDialog(
    BuildContext context, String title, String message, IconData icon,
    {String yesText,
    Function onYes,
    String noText,
    Function onNo,
    Color iconColor,
    result,
    int milliseconds = 250,
    double iconButton}) {
  AlertDialog alertDialog = AlertDia
    contentPadding: EdgeInsets.all(20.0),
    content: SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: iconColor ?? primaryColor, shape: BoxShape.circle),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: Icon(
              icon,
              color: white,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: textStyle(true, 16, iconColor),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: textStyle(false, 12, black.withOpacity(0.5)),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
            height: 35,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: RaisedButton(
                  color: primaryColor,
                  splashColor: white,
                  onPressed: onYes ??
                      () {
                        Navigator.pop(context, true);
                      },
                  child: Text(
                    yesText ?? "Ok",
                    style: textStyle(false, 14, white),
                  )),
            )),
        if (noText != null)
          SizedBox(
            height: 10,
          ),
        if (noText != null)
          Container(
              height: 35,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: RaisedButton(
                    color: iconColor,
                    splashColor: white,
                    onPressed: onYes ??
                        () {
                          Navigator.pop(context, false);
                        },
                    child: Text(
                      noText ?? "Cancel",
                      style: textStyle(false, 14, white),
                    )),
              ))
      ],
    )),
  );
  Future.delayed(Duration(milliseconds: milliseconds)).then((value) {
    popOver(context, alertDialog, result: result);
  });
}

//This function returns the state of network connectivity
Future<bool> isConnected() async {
  try {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none) {
      return Future<bool>.value(false);
    } else {
      return Future<bool>.value(true);
    }
  } catch (e) {
    return Future<bool>.value(false);
  }
}

//This function handle all http calls and handles error
callApi(
    String url, BuildContext context, onComplete(http.Response response, error),
    {Map<String, dynamic> post,
    bool getMethod = false,
    bool putMethod = false,
    bool postMethod = false,
    bool patchMetod = false,
    bool deleteMethod = false}) async {
  if (await isConnected() == false) {
    onComplete(null, "No Internet Connectivity");
    return;
  }

  var error;
  if (getMethod) {
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $TOKEN',
    }).catchError((e) {
      error = e;
    });

    if (response == null) {
      onComplete(null, "Error Occured");
      return;
    }
    print(url);
    print(response.body);
    var body = jsonDecode(response.body);
    if (body.toString().toLowerCase().contains("error")) error = body;
    onComplete(response, error);
    return;
  }

  if (postMethod) {
    print("inside post method");
    final response = await http
        .post(url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $TOKEN',
            },
            body: jsonEncode(post))
        .catchError((e) {
      error = e;
      print(e);
    });

    print("response  is $response");
    if (response == null) {
      onComplete(null, "Error Occured");
      return;
    }

    print(url);
    print(response.body);
    var body = jsonDecode(response.body);
    if (body.toString().toLowerCase().contains("error")) error = body;
    onComplete(response, error);
    return;
  }

  if (putMethod) {
    print("inside put method");
    print(url);
    final response = await http
        .put(url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $TOKEN',
            },
            body: jsonEncode(post))
        .catchError((e) {
      error = e;
      print(e);
    });

    print("response  is $response");
    if (response == null) {
      onComplete(null, "Error Occured");
      return;
    }

    print(url);
    print(response.body);
    var body = jsonDecode(response.body);
    if (body.toString().toLowerCase().contains("error")) error = body;
    onComplete(response, error);
    return;
  }
  if (deleteMethod) {
    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $TOKEN',
    }).catchError((e) {
      error = e;
    });

    if (response == null) {
      onComplete(null, "Error Occured");
      return;
    }
    print(url);
    print(response.body);
    var body = jsonDecode(response.body);
    if (body.toString().toLowerCase().contains("error")) error = body;
    onComplete(response, error);
    return;
  }
}

popOver(context, item, {result}) {
  showModal(
      context: context,
      configuration: const FadeScaleTransitionConfiguration(),
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) => item)).then((value) {
    if (value != null) {
      if (result != null) result(value);
    }
  });
}

//This function create a pop up list o
Future<String> showListDialog(BuildContext context, String title, List items,
    {result}) {
  popOver(
      context,
      ListDialog(
        title: title,
        items: items,
      ),
      result: result);
}

//This function returns a loading layout
showProgress(bool show, BuildContext context,
    {String message, bool cancellable}) {
  if (!show) {
    progressDialogShowing = false;
    progressController.add(false);
    return;
  }

  progressDialogShowing = true;
  popOver(
    context,
    progressDialog(
      message: message,
      cancelable: cancellable,
    ),
  );
}

handleError(context, String error) {
  alertDialog(context, "Error!", error, Icons.error,
      iconColor: Colors.red, milliseconds: 300);
}

List getListFromMap(String key, List list) {
  List items = [];
  for (Map map in list) {
    var item = map[key];
    print(map["name"]);
    if ((item == null) || (item is String && item.toString().isEmpty)) continue;
    items.add(item);
  }
  return items;
}

inputDialog(BuildContext context, String title,
    {String hint = "",
    String message = "",
    String okText = "Done",
    TextInputType inputType,
    int maxLength = 1000,
    bool allowEmpty = true,
    result}) {
  //print("$hint , $message ,  $okText , $maxLength , $allowEmpty $title");
  popOver(
      context,
      InputDialog(
          title: title,
          message: message,
          hint: hint,
          okTest: okText,
          allowEmpty: allowEmpty,
          maxLength: maxLength,
          inputType: inputType),
      result: result);
}

inputTextView(
  String title,
  String hint,
  TextEditingController controller, {
  FocusNode node,
  int maxline = 1,
  bool isNum,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textStyle(true, 14, primaryColor),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        decoration: BoxDecoration(
            color: default_white, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: TextField(
            textInputAction: TextInputAction.search,
            textCapitalization: TextCapitalization.sentences,
            autofocus: false,
            onSubmitted: (_) {
              //reload();
            },
            decoration: InputDecoration(
                hintStyle: textStyle(
                  false,
                  15,
                  black,
                ),
                border: InputBorder.none,
                isDense: true),
            style: textStyle(false, 15, black),
            controller: controller,
            cursorColor: black,
            cursorWidth: 1,
            focusNode: node,
            maxLines: maxline,
            keyboardType: isNum ? TextInputType.number : TextInputType.text,
            onChanged: (s) {},
          ),
        ),
      )
    ],
  );
}

clickText(
  String title,
  String text,
  onClicked, {
  double height = 45,
  clickAdd,
}) {
  return Column(
    children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: textStyle(true, 14, primaryColor),
            ),
            if (clickAdd != null)
              GestureDetector(
                onTap: () {
                  clickAdd();
                },
                child: Container(
                  child: Icon(
                    Icons.add_circle,
                    color: primaryColor,
                  ),
                ),
              )
          ],
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      GestureDetector(
          onTap: () {
            onClicked();
          },
          child: Container(
            decoration: BoxDecoration(
                color: default_white, borderRadius: BorderRadius.circular(25)),
            height: 45,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Text(
                  text,
                  style: textStyle(false, 14, black),
                ),
              ],
            ),
          ))
    ],
  );
}

getItemFromMap(value, String itemKey, List list) {
  for (Map map in list) {
    if (map.containsValue(value)) {
      print(map[itemKey]);
      return map[itemKey];
    }
  }
  return null;
}

void callApiWithFile(List<File> files, String id, BuildContext context,
    String url, onComplete(response, error)) async {
  print("this is id from inside upload data $id");
  var headers = {'Authorization': 'Bearer $TOKEN'};
  var request = http.MultipartRequest('POST', Uri.parse(url));

  for (File file in files) {
    request.files.add(await http.MultipartFile.fromPath('files', file.path));
  }

  request.fields["ref"] = "provider";
  request.fields["refId"] = id;
  request.fields["field"] = "images";
  request.headers.addAll(headers);
  http.StreamedResponse response;
  try {
    response = await request.send();
  } catch (e) {
    handleError(context, e);
    return;
  }

  if (response == null) {
    onComplete(null, "Error occured");
    return;
  }

  if (response.statusCode == 200) {
    http.Response res = await http.Response.fromStream(response);
    print(res.body);
    onComplete(res, null);

    return;
  } else {
    print(response.reasonPhrase);
    onComplete(null, response.reasonPhrase);
  }
}
