import '../base/libraryExport.dart';

class AdminSalesInvoiceScreen extends StatefulWidget {
  final KonnectDetails konnectDetails;

  const AdminSalesInvoiceScreen({Key key, this.konnectDetails})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminSalesInvoiceState();
}

class _AdminSalesInvoiceState extends State<AdminSalesInvoiceScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController= new ScrollController();
  TabController _tabController;
  List<Map> _list;
List<Map> search = List<Map>();
  int valuepag=1;
  @override
  void initState() {
    super.initState();

    _scrollController.addListener( _scrollListener);
    _tabController = new TabController(initialIndex: 0, length: 2, vsync: this);
    ApiAdmin().getSaleInvoice('ERP',valuepag).then((value) => {
      setState(() {
        Map<String, dynamic> response = value.data;

        _list = List<Map>();
        if (response['status'] == '200') {
          response['result'].forEach((value) {
            _list.add(value);
          });
        }
        search.addAll(_list);
        print(response);
      }),
    });
  }
  fetch(){

  }
  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        valuepag++;
        fetch();
        debugPrint("reach the top");
      });
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if(valuepag>1){
          valuepag--;}
        fetch();
        debugPrint("reach the top");
      });
    }
  }
  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }
  Widget appBarTitle = new Text("Sales Invoice");
  Icon actionIcon = new Icon(Icons.search);
  onChanged(String value) {
    _list= List<Map>();
    search.forEach((item) {
      String q1= item['invoice_name'];
      String q2= item['invoice_no'].toString();

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())||q2.toLowerCase().contains(value.toLowerCase())){

          print('search item name ${item['invoice_name']} == ${value} ');
          _list.add(item);
        }
      });

    });



  }
  @override
  Widget build(BuildContext context) {
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
    this.appBarTitle = new Text("Sales Invoice");
    }


    });
    } ,),],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),

        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: <Widget>[
            Tab(text: 'ERP'),
            Tab(text: 'KMB'),
          ],
          onTap: (index) {
            setState(() {
              _list = null;
              String value = index == 0 ? 'ERP' : 'KMB';
              ApiAdmin().getSaleInvoice(value,valuepag).then((value) => {
                    setState(() {
                      _list = List<Map>();
                      Map<String, dynamic> response = value.data;
                      if (response['status'] == '200') {
                        response['result'].forEach((value) {
                          _list.add(value);
                        });
                      }
                      search.clear();
                      search.addAll(_list);
                      print(response);
                    }),
                  });
            });
          },
          controller: _tabController,
        ),
      ),
      body:  Column(children: <Widget>[

    Expanded(
    child:_list == null
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
                    heightFactor:  MediaQuery.of(context).size.height-0,
                    widthFactor:   MediaQuery.of(context).size.width-0,
                    child:Image(image: AssetImage('images/nodatafound.png'),
                    ),
                  ),
                )
              : ListView(
        controller: _scrollController,
                  children: _list.map((item) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          print('${item['invoice_id']}');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SalesInvoiceViewScreen(
                                    id: item['invoice_id'].toString(),
                              ),
                            ),
                          );
                        },
                        title: Text(item['invoice_name'],style: (TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 14))),
                        subtitle: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(item['invoice_no'],style: (TextStyle(fontWeight: FontWeight.bold,fontSize: 10))),
                            ),
                            Text(item['invoice_date'],style: (TextStyle(fontWeight: FontWeight.bold,fontSize: 8)))
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }).toList()),
    )]));
  }
}
