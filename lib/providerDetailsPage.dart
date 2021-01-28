import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:reliance_engineer_test/network.dart';

import 'AppEngine.dart';
import 'addProvider.dart';
import 'model/provider.dart';
import 'staticItems.dart';

class ProviderDetailsPage extends StatefulWidget {
  final Provider provider;
  final String heroTag;

  const ProviderDetailsPage({
    Key key,
    this.provider,
    this.heroTag,
  }) : super(key: key);
  @override
  _ProviderDetailsPageState createState() => _ProviderDetailsPageState();
}

class _ProviderDetailsPageState extends State<ProviderDetailsPage> {
  Provider _provider;
  NetworkService _networkService = NetworkService();
  bool waasRefereshed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _provider = widget.provider;
    print(_provider.id);
  }

  refereshProvider() async {
    showProgress(true, context);
    var res =
        await _networkService.getProvider(_provider.id.toString(), context);
    if (res != null) {
      showProgress(false, context);
      _provider = res;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context, waasRefereshed);
        },
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Hero(
                      tag: widget.heroTag,
                      child: CachedNetworkImage(
                        imageUrl: imagePick(_provider, false),
                        imageBuilder: (BuildContext context, imageProvider) =>
                            Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: black.withOpacity(0.6),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                      ),
                    ),
                    Positioned(
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop(waasRefereshed);
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            child: Center(
                                child: Icon(
                              Icons.keyboard_backspace,
                              color: white,
                              size: 23,
                            )),
                          )),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _provider.name,
                            style: textStyle(true, 20, white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Text(
                                    _provider.providerType.name ?? "",
                                    style: textStyle(false, 12, white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 20,
                                child: RatingBarIndicator(
                                  rating: _provider.rating == null
                                      ? 0.0
                                      : _provider.rating.toDouble(),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  direction: Axis.horizontal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Column(
                    children: [
                      Text(
                        "${_provider.description}" ?? "",
                        style: textStyle(false, 18, black.withOpacity(0.6)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (_provider.activeStatus != null)
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                              decoration: BoxDecoration(
                                  color: _provider.activeStatus == "Active"
                                      ? Colors.green
                                      : _provider.activeStatus == "Pending"
                                          ? Colors.grey
                                          : Colors.red,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  _provider.activeStatus,
                                  style: textStyle(false, 12, white),
                                ),
                              ),
                            )
                          ],
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1, 0),
                                  color: Colors.blueGrey.withOpacity(0.5),
                                  blurRadius: 50)
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Icon(
                                        Icons.business,
                                        size: 20,
                                        color: white,
                                      ),
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "${_provider.address}",
                                  style: textStyle(false, 16, primaryColor),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                thickness: 0.5,
                                color: black.withOpacity(0.3),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Icon(
                                        Icons.room,
                                        size: 20,
                                        color: white,
                                      ),
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "${_provider.state.name}",
                                  style: textStyle(false, 16, primaryColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddProvider(
                            isUpdate: true,
                            provider: _provider,
                          ))).then((value) {
                if (value != null) {
                  refereshProvider();
                  waasRefereshed = true;
                }
              });
            },
            backgroundColor: secondaryColor,
            child: Icon(Icons.create),
          ),
        ),
      ),
    );
  }
}
