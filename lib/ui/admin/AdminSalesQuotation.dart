import 'package:yuvrajpipes/ui/admin/AdminADD/CreateSalesQuotation.dart';
import 'package:yuvrajpipes/ui/view/SalesQuotationView.dart';

import '../base/libraryExport.dart';
import 'AdminADD/EditSalesQuotation.dart';

class AdminSalesQuotationScreen extends StatefulWidget {
  final KonnectDetails konnectDetails;

  const AdminSalesQuotationScreen({Key key, this.konnectDetails})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminSalesQuotationState();
}

class _AdminSalesQuotationState extends State<AdminSalesQuotationScreen>
    with SingleTickerProviderStateMixin {
  ProgressDialog pr;
  String valueindex="sale";
  TabController _tabController;
  List<Map> _allList;
  List<Map> _list;
  List<Map> search = List<Map>();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(initialIndex: 0, length: 2, vsync: this);
    updateQuotation();
  }
void updateQuotation(){
  ApiAdmin().getQuotation().then((value) => {
    setState(() {
      Map<String, dynamic> response = value.data;

      _allList = List<Map>();
      _list = List<Map>();
      if (response['status'] == '200') {
        response['result'].forEach((v) {
          _allList.add(v);
          if (v['type'] == 'sale') {
            _list.add(v);
          }
         // _list.add(v);
        });
      }
      search.addAll(_list);
      print(response);
    }),
  });
}
  onChanged(String value) {
    _list = List<Map>();
    search.forEach((item) {
      String q1 = item['name'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())) {
          print('search item name ${item['name']} == ${value} ');
          _list.add(item);
        }
      });
    });
  }

  Widget appBarTitle = new Text("Sales Quotation");
  Icon actionIcon = new Icon(Icons.search);

  deleteSalesQuotationDialog(BuildContext context, id) {
    AlertDialog alert = new AlertDialog(
      content: Container(
          child: ListTile(
        title: Text("Are U sure want to Delete?"),
        leading: Icon(
          Icons.delete,
          color: Colors.red,
          size: 40,
        ),
      )),
      actions: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {

                   // updateQuotation();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    ApiAdmin().deleteQuotation(id).then((value) => {
                          setState(() {
                            Map<String, dynamic> response = value.data;
                            if (response['status'] == '200') {
                              pr.show();
                              Future.delayed(
                                  Duration(seconds: 1))
                                  .then((value) {
                                pr.hide().whenComplete(() {
                                  updateQuotation();
                                  Navigator.of(context).pop();
                                });
                              });



                            }
                            print(value);
                          })
                        });
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: appBarTitle,
          actions: <Widget>[
            new IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = new Icon(Icons.close);
                    this.appBarTitle = new TextFormField(
                      autofocus: false,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Search Here...',
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(color: Colors.blue.shade300),
                        ),
                      ),
                    );
                  } else {
                    this.actionIcon = new Icon(Icons.search);
                    this.appBarTitle =
                        new Text("Sales Quotation/ Purchase Invoice");
                  }
                });
              },
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () { Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SplashScreen(),
              ),
            );}
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Colors.amber,
            tabs: <Widget>[
              Tab(text: 'SALES QUOTATION'),
              Tab(text: 'PURCHASE ORDER'),
            ],
            onTap: (index) {
              setState(() {
                _list = null;
                 valueindex = index == 0 ? 'sale' : 'purchase';
                _list = List<Map>();
                _allList.forEach((v) {
                  if (v['type'] == valueindex) {
                    _list.add(v);
                  }
                });
                search.clear();
                search.addAll(_list);
              });
            },
            controller: _tabController,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => CreateSalesQuotationScreen(id: valueindex,),
              ),
            );
          },
          child: new Icon(Icons.add),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: _list == null
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: GFLoader(loaderColorOne: Colors.white),
                    ),
                  )
                : _list.isEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          heightFactor: MediaQuery.of(context).size.height - 0,
                          widthFactor: MediaQuery.of(context).size.width - 0,
                          child: Image(
                            image: AssetImage('images/nodatafound.png'),
                          ),
                        ),
                      )
                    : ListView(
                        children: _list.map((item) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              child: Column(
                            children: <Widget>[
                              ListTile(
                                title: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SalesQuotationViewScreen(
                                          id: item['id'].toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text('${item['name']}',
                                            style: (TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text('${item['mobile_number']}',
                                          style: (TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14))),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          InkWell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  height: 20,
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: Colors.red,
                                                    ),
                                                  )),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      EditSalesQuotationScreen(
                                                    id: item['id'].toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              height: 20,
                                              child: IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  deleteSalesQuotationDialog(context, item['id'].toString());

                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 16.0, 0),
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(child: Text("")),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 16.0, 0),
                                        child: Text(item['date'],
                                            style: (TextStyle(fontSize: 10))),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                        );
                      }).toList()),
          )
        ]));
  }
}
