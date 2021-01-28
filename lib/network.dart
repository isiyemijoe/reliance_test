import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reliance_engineer_test/model/provider.dart';
import 'package:http/http.dart' as http;
import 'package:reliance_engineer_test/stringAssets.dart';

import 'AppEngine.dart';

class NetworkService {
  Future<List<Provider>> getProviders(BuildContext context) async {
    http.Response res;
    var err;
    String url = "${BASE_URL}providers";

    await callApi(url, context, (response, error) {
      print("$error and $response");
      res = response;
      err = error;
    }, getMethod: true);
    print(res);
    print(err);
    if (err != null) {
      alertDialog(context, "Error", err.toString(), Icons.error,
          iconColor: Colors.red);
      return null;
    }
    if (res.statusCode == 200) {
      return await compute(parseProvider, res.body.toString());
    }
  }

  Future<Provider> getProvider(String id, BuildContext context) async {
    http.Response res;
    var err;
    String url = "${BASE_URL}providers/$id";

    await callApi(url, context, (response, error) {
      print("$error and $response");
      res = response;
      err = error;
    }, getMethod: true);

    if (err != null) {
      alertDialog(context, "Error", err.toString(), Icons.error,
          iconColor: Colors.red);
      return null;
    }
    if (res.statusCode == 200) {
      print(res.body);
      Map map = jsonDecode(res.body);
      Provider provider = Provider.fromJson(map);
      print("provider has been gotten ${provider.name}");
      return provider;
    }
    return null;
  }

  Future<Provider> deleteProvider(String id, BuildContext context) async {
    http.Response res;
    var err;
    String url = "${BASE_URL}providers/$id";

    await callApi(url, context, (response, error) {
      print("$error and $response");
      res = response;
      err = error;
    }, deleteMethod: true);

    if (err != null) {
      alertDialog(context, "Error", err.toString(), Icons.error,
          iconColor: Colors.red);
      return null;
    }
    if (res.statusCode == 200) {
      print(res.body);
      Map map = jsonDecode(res.body);
      Provider provider = Provider.fromJson(map);
      print("provider has been deleted ${provider.name}");
      return provider;
    }
    return null;
  }

  Future<dynamic> saveProvider(
      bool isUpdate,
      String id,
      BuildContext context,
      String name,
      String status,
      String state,
      String providerType,
      String description,
      String address,
      String rating) async {
    http.Response res;
    var err;
    String url = "${BASE_URL}providers";
    if (isUpdate) {
      url = url + "/$id";
    }

    Map<String, String> data = {
      "name": name,
      "description": description,
      "rating": rating,
      "address": address,
      "active_status": status,
      "provider_type": providerType,
      "state": state
    };
    print(data);

    await callApi(url, context, (response, error) {
      print("$error and $response");
      res = response;
      err = error;
    },
        postMethod: isUpdate ? false : true,
        putMethod: isUpdate ? true : false,
        post: data);
    print(res);
    print(err);
    if (err != null) {
      alertDialog(context, "Error", err.toString(), Icons.error,
          iconColor: Colors.red);
      return null;
    }
    print(res.statusCode);
    if (res.statusCode == 200) {
      print(res.body);
      Map map = jsonDecode(res.body);
      return map;
    }
    return null;
    //return await compute(parseProvider, res.body.toString());
  }
}

List<Provider> parseProvider(String responseBody) {
  print("gotten into isolate");
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print("form inside isolate");
  return parsed.map<Provider>((json) => Provider.fromJson(json)).toList();
}
