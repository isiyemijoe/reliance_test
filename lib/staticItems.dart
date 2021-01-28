import 'dart:async';

import 'package:flutter/material.dart';

//color
const Color white = Colors.white;
const Color primaryColor = Color(0XFF094063);
const Color secondaryColor = Color(0XFF89CBF0);
const Color black = Color(0XFF000000);
const Color default_white = Color(0xfffff3f3f3);

//assets
final String ic_launcher = "assets/images/ic_logo.png";
StreamController<bool> progressController = StreamController<bool>.broadcast();
bool progressDialogShowing = false;
