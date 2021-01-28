import 'package:flutter/material.dart';
import 'package:reliance_engineer_test/AppEngine.dart';

import '../staticItems.dart';

class ListDialog extends StatefulWidget {
  String title;
  List items;

  List selections;
  ListDialog({this.items, this.title, this.selections});
  @override
  _ListDialogState createState() => _ListDialogState();
}

class _ListDialogState extends State<ListDialog> {
  BuildContext context;
  List selections = [];
  bool multiple;
  bool showCancel = false;
  FocusNode _searchNode;
  TextEditingController _searchController;
  ScrollController _scrollController = ScrollController();
  List allItems = [];
  List items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController();
    _searchNode = FocusNode();
    multiple = widget.selections != null;
    selections = widget.selections ?? [];
    allItems = widget.items;

    reload();
    if (allItems.isEmpty) {
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.pop(context);
        alertDialog(context, "Empty", "Nothing to Display", Icons.error,
            iconColor: Colors.red);
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    _searchNode.dispose();
    super.dispose();
  }

  reload() {
    String search = _searchController.text.trim();
    items.clear();
    if (search.isNotEmpty) {
      for (String s in allItems) {
        if (!s.toLowerCase().contains(search.toLowerCase())) continue;
        items.add(s);
      }
    } else {
      items.addAll(allItems);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return GestureDetector(
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
    );
  }

  page() {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(25, 45, 25, 45),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
            decoration: BoxDecoration(
                color: white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Image.asset(ic_launcher, height: 14, width: 14),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          child: widget.title == null
                              ? Text(
                                  "ProZone",
                                  style: textStyle(
                                      false, 11, black.withOpacity(0.1)),
                                )
                              : Text(
                                  widget.title,
                                  style: textStyle(true, 18, black),
                                ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                if (allItems.length > 3)
                  Container(
                    height: 45,
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        color: white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            color: primaryColor.withOpacity(0.4), width: 1)),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: primaryColor.withOpacity(0.4),
                          size: 17,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            textCapitalization: TextCapitalization.sentences,
                            autofocus: false,
                            onSubmitted: (_) {},
                            decoration: InputDecoration(
                                hintText: "Search",
                                hintStyle: textStyle(
                                    false, 16, primaryColor.withOpacity(0.4)),
                                border: InputBorder.none,
                                isDense: true),
                            style: textStyle(
                                false, 16, primaryColor.withOpacity(0.4)),
                            controller: _searchController,
                            cursorColor: black,
                            cursorWidth: 1,
                            focusNode: _searchNode,
                            keyboardType: TextInputType.text,
                            onChanged: (s) {
                              showCancel = s.trim().isNotEmpty;
                              setState(() {
                                reload();
                              });
                            },
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _searchNode.unfocus();
                                showCancel = false;
                                _searchController.text = "";
                              });
                              reload();
                            },
                            child: showCancel
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.close,
                                      color: black,
                                      size: 20,
                                    ),
                                  )
                                : Container())
                      ],
                    ),
                  ),
                Divider(
                  height: 1,
                  color: black.withOpacity(.3),
                ),
                Flexible(
                    child: Scrollbar(
                  controller: _scrollController,
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      controller: _scrollController,
                      itemCount: items.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            index == 0
                                ? Container()
                                : Divider(
                                    height: 1,
                                    color: black.withOpacity(.3),
                                  ),
                            GestureDetector(
                              onTap: () {
                                if (multiple) {
                                  bool selected =
                                      selections.contains(items[index]);

                                  if (selected) {
                                    selections.remove(items[index]);
                                  } else {
                                    selections.add(items[index]);
                                  }
                                  setState(() {});
                                  return;
                                }
                                Navigator.of(context).pop(items[index]);
                              },
                              child: Container(
                                color: white,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      items[index],
                                      style: textStyle(
                                          false, 16, black.withOpacity(0.8)),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      }),
                )),
                Divider(
                  height: 1,
                  color: black.withOpacity(.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
