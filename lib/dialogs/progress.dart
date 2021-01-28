import 'package:flutter/material.dart';
import 'package:reliance_engineer_test/AppEngine.dart';
import 'package:reliance_engineer_test/staticItems.dart';

class progressDialog extends StatefulWidget {
  String message;
  bool cancelable;
  progressDialog({this.message, this.cancelable});

  @override
  _progressDialogState createState() => _progressDialogState();
}

class _progressDialogState extends State<progressDialog> {
  String message;
  bool cancellable;
  var sub;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    message = widget.message ?? "";
    cancellable = widget.cancelable ?? true;
    sub = progressController.stream.listen((event) {
      progressDialogShowing = false;
      Navigator.pop(context);
      return;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (cancellable) {
          Navigator.pop(context);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: black.withOpacity(.8),
          ),
          page()
        ],
      ),
    );
  }

  page() {
    return Stack(
      children: [
        Center(
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(color: white, shape: BoxShape.circle),
          ),
        ),
        Center(
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(ic_launcher))),
          ),
        ),
        Center(
          child: CircularProgressIndicator(
            backgroundColor: primaryColor,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    message,
                    style: textStyle(false, 15, white),
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
