import 'package:yuvrajpipes/ui/admin/AdminADD/CreateSalesQuotation.dart';
import 'package:yuvrajpipes/ui/admin/AdminADD/EditSalesQuotation.dart';
import 'package:yuvrajpipes/ui/view/SalesQuotationView.dart';

import '../base/libraryExport.dart';

class PMUserSalesQuatationScreen extends StatefulWidget {
  final id;

  const PMUserSalesQuatationScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PMUserSalesQuatationState();
}

class _PMUserSalesQuatationState extends State<PMUserSalesQuatationScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Map> _allList;
  List<Map> _list;
  List<Map> search = List<Map>();
  ProgressDialog pr;
  @override
  void initState() {
    super.initState();
    updateQuotation();
    _tabController = new TabController(initialIndex: 0, length: 2, vsync: this);

  }
  void updateQuotation() {
    ApiClient().getPartyMasterQuotation( widget.id.toString()).then((value) => {
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

          });
        }
        search.addAll(_list);
        print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaa$response');
      }),
    });
  }
  onChanged(String value) {
    _list= List<Map>();
    search.forEach((item) {
      String q1= item['name'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())){

          print('search item name ${item['name']} == ${value} ');
          _list.add(item);
        }
      });

    });



  }

  Widget appBarTitle = new Text("Sales Quotation");
  Icon actionIcon = new Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title:appBarTitle,
          actions: <Widget>[
            new IconButton(icon: actionIcon,onPressed:(){
              setState(() {
                if ( this.actionIcon.icon == Icons.search){
                  this.actionIcon = new Icon(Icons.close);
                  this.appBarTitle =   new TextFormField(
                    autofocus: false,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Search Here...',
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                  );}
                else {
                  this.actionIcon = new Icon(Icons.search);
                  this.appBarTitle = new Text("Sales Quotation/ Purchase Invoice");
                }


              });
            } ,),],

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
                String valueindex = index == 0 ? 'sale' : 'purchase';
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
              child: Container(
                alignment:Alignment.center,
                height: 200,
                child: Center(

                  heightFactor:  MediaQuery.of(context).size.height-0,
                  widthFactor:   MediaQuery.of(context).size.width-0,
                  child:Image(image: AssetImage('images/nodatafound.png'),
                  ),
                ),
              ),
            )
                :  ListView(
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
          )]));
  }


}
