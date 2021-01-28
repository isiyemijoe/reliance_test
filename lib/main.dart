import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:reliance_engineer_test/AppEngine.dart';
import 'package:reliance_engineer_test/addProvider.dart';
import 'package:reliance_engineer_test/network.dart';
import 'package:reliance_engineer_test/providerDetailsPage.dart';
import 'package:reliance_engineer_test/staticItems.dart';
import 'model/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  NetworkService _networkService = NetworkService();
  List<Provider> items = [];
  List<Provider> allItems = [];
  TextEditingController _searchController;
  RefreshController _refreshController;
  FocusNode _searchNode;
  String providerTypeFilter = "";
  String statusFilter = "";
  bool filter = false;

  bool _loading = true;
  bool showCancel = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProviders();
    _searchController = TextEditingController();
    _searchNode = FocusNode();
    _refreshController = RefreshController();
  }

  fetchProviders() async {
    setState(() {});
    allItems = await _networkService.getProviders(context) ?? [];
    _refreshController.refreshCompleted();
    _loading = false;
    print(allItems);
    reload();
    if (mounted) setState(() {});
  }

  reload() {
    String search = _searchController.text.trim().toLowerCase();
    items.clear();

    for (Provider item in allItems) {
      if (item.activeStatus == null ||
          item.providerType == null ||
          item.name == null ||
          item.address == null ||
          item.state == null) continue;
      print(item.providerType.name);
      if (search.isNotEmpty) {
        if (item.name.toLowerCase().contains(search) ||
            item.address.toLowerCase().contains(search) ||
            item.state.name.toLowerCase().contains(search)) {
          items.add(item);
        }
      } else {
        items.addAll(allItems);
      }
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: _loading
              ? Center(child: loadingLayout())
              : Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 15, 15),
                            child: Row(
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ProZone",
                                        style:
                                            textStyle(true, 18, Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "Healthcare Providers",
                                        style: textStyle(false, 14, white),
                                      )
                                    ]),
                              ],
                            ),
                          ),
                          Container(
                            height: 45,
                            margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                            decoration: BoxDecoration(
                                //  boxShadow: [BoxShadow(offset: Offset(3,0), color: primaryColor.withOpacity(1))],
                                color: primaryColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                    color: _searchNode.hasFocus
                                        ? white
                                        : Colors.grey,
                                    width: 1)),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.search,
                                  color: white.withOpacity(.5),
                                  size: 17,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                new Flexible(
                                  flex: 1,
                                  child: new TextField(
                                    textInputAction: TextInputAction.search,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    autofocus: false,
                                    onSubmitted: (_) {
                                      reload();
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Search",
                                        hintStyle: textStyle(
                                          false,
                                          16,
                                          white,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true),
                                    style: textStyle(false, 16, white),
                                    controller: _searchController,
                                    cursorColor: white,
                                    cursorWidth: 1,
                                    focusNode: _searchNode,
                                    keyboardType: TextInputType.text,
                                    onChanged: (s) {
                                      showCancel = _searchController.text
                                          .trim()
                                          .isNotEmpty;
                                      setState(() {});
                                      reload();
                                    },
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      if (showCancel) {
                                        _searchNode.unfocus();
                                        showCancel = false;
                                        _searchController.text = "";
                                        reload();
                                      }
                                      setState(() {});
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 15, 0),
                                        child: showCancel
                                            ? Icon(
                                                Icons.close,
                                                color: white,
                                                size: 20,
                                              )
                                            : Container()))
                                // ,   GestureDetector(
                                //           onTap: () {
                                //             if (filter) {
                                //               filter = false;
                                //               reload();
                                //               setState(() {});
                                //               return;
                                //             }
                                //           },
                                //           child: Padding(
                                //               padding: const EdgeInsets.fromLTRB(
                                //                   0, 0, 15, 0),
                                //               child: showCancel
                                //                   ? Icon(
                                //                       Icons.close,
                                //                       color: white,
                                //                       size: 20,
                                //                     )
                                //                   : Container())),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SmartRefresher(
                        enablePullDown: true,
                        onRefresh: fetchProviders,
                        controller: _refreshController,
                        child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Dismissible(
                                confirmDismiss: (direction) async {
                                  await alertDialog(
                                      context,
                                      "Delete",
                                      "Are you sure you want to delete ${items[index].name} from your network?",
                                      Icons.info,
                                      iconColor: Colors.red,
                                      yesText: "Delete",
                                      noText: "Cancel", result: (_) async {
                                    print(_);
                                    if (_) {
                                      showProgress(true, context);
                                      await _networkService
                                          .deleteProvider(
                                              items[index].id.toString(),
                                              context)
                                          .then((value) => {
                                                showProgress(false, context),
                                                if (value != null)
                                                  {
                                                    items.removeAt(index),
                                                    allItems
                                                        .remove(items[index]),
                                                    alertDialog(
                                                        context,
                                                        "Successful",
                                                        "${value.name} has been deleted successfully",
                                                        Icons.check,
                                                        iconColor: Colors.green)
                                                  },
                                                fetchProviders()
                                              });
                                    }
                                  });
                                },
                                background: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Icon(
                                                Icons.delete,
                                                color: white,
                                              ),
                                              Text(
                                                "Delete",
                                                style:
                                                    textStyle(false, 14, white),
                                              )
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Text(
                                                "Delete",
                                                style:
                                                    textStyle(false, 14, white),
                                              ),
                                              Icon(
                                                Icons.delete,
                                                color: white,
                                              ),
                                              SizedBox(
                                                width: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                key: Key(items[index].id.toString()),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minWidth:
                                          MediaQuery.of(context).size.width),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProviderDetailsPage(
                                                    provider: items[index],
                                                    heroTag: index.toString(),
                                                  ))).then((value) {
                                        if (value != null) {
                                          fetchProviders();
                                        }
                                      });
                                    },
                                    title: Text(items[index].name,
                                        style: textStyle(false, 14, black)),
                                    leading: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Hero(
                                        tag: "$index",
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              imagePick(items[index], true),
                                          imageBuilder: (BuildContext context,
                                                  imageProvider) =>
                                              Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) => Center(
                                              child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1.5,
                                                  ))),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            decoration: BoxDecoration(
                                                color: secondaryColor,
                                                shape: BoxShape.circle),
                                            child: Icon(Icons.business),
                                          ),
                                        ),
                                      ),
                                    ),
                                    trailing: SizedBox(
                                      height: 20,
                                      width: 70,
                                      child: Container(
                                        height: 20,
                                        width: 70,
                                        padding:
                                            EdgeInsets.fromLTRB(8, 3, 8, 3),
                                        decoration: BoxDecoration(
                                            color: items[index].activeStatus ==
                                                    "Active"
                                                ? Colors.green
                                                : items[index].activeStatus ==
                                                        "Pending"
                                                    ? Colors.grey
                                                    : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Center(
                                          child: Text(
                                            items[index].activeStatus,
                                            style: textStyle(false, 12, white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(
                                      items[index].providerType == null
                                          ? ""
                                          : items[index].providerType.name,
                                      style: textStyle(
                                          false, 12, black.withOpacity(0.6)),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                ),
          floatingActionButton: _loading
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddProvider())).then((value) {
                      if (value != null) {
                        fetchProviders();
                      }
                    });
                  },
                  backgroundColor: secondaryColor,
                  child: Icon(Icons.add),
                ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }
}
