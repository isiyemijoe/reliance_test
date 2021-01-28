import 'package:flutter/material.dart';
import 'package:reliance_engineer_test/AppEngine.dart';

import '../staticItems.dart';

class InputDialog extends StatefulWidget {
  String title;
  String message;
  String hint;
  String okTest;
  TextInputType inputType;
  int maxLength;
  bool allowEmpty;

  InputDialog(
      {this.title,
      this.message,
      this.hint,
      this.okTest,
      this.inputType,
      this.allowEmpty,
      this.maxLength});
  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  String title;
  String message;
  String hint;
  String okText;
  TextEditingController _editingController;
  TextInputType inputType;
  String errorText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editingController = TextEditingController(text: message);
    title = widget.title;
    hint = widget.hint;
    okText = widget.okTest;
    inputType = widget.inputType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: black.withOpacity(0.6),
            ),
            page()
          ],
        ),
      ),
    );
  }

  page() {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(25, 45, 25, 45),
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                title,
                style: textStyle(true, 16, black),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: double.infinity,
              height: errorText.isEmpty ? 0 : 40,
              color: Colors.red,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Center(
                child: Text(
                  errorText,
                  style: textStyle(true, 16, white),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: default_white,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SingleChildScrollView(
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    maxLength: null,
                    decoration: InputDecoration(
                      hintText: hint,
                      border: InputBorder.none,
                      hintStyle: textStyle(false, 18, black.withOpacity(0.6)),
                    ),
                    style: textStyle(false, 18, black),
                    controller: _editingController,
                    cursorColor: black,
                    cursorWidth: 1,
                    maxLines: null,
                    keyboardType:
                        inputType == null ? TextInputType.multiline : inputType,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.all(15),
              child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                color: primaryColor,
                onPressed: () {
                  String text = _editingController.text;

                  if (text.isEmpty && !widget.allowEmpty) {
                    showError("nothing to update");
                    return;
                  }

                  if (text.length > widget.maxLength) {
                    showError(
                        "Text should not be greater than ${widget.maxLength} characters");
                  }
                  Navigator.pop(context, text);
                },
                child: Text(
                  okText,
                  style: textStyle(false, 16, white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showError(String s) {
    errorText = s;
    setState(() {});
    Future.delayed(Duration(seconds: 1), () {
      errorText = "";
      setState(() {});
    });
  }
}
