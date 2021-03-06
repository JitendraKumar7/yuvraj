import 'package:yuvrajpipes/ui/admin/AdminLinkView/AdminLinkPartymasterView.dart';
import 'package:yuvrajpipes/ui/base/libraryExport.dart';
import 'package:table_calendar/table_calendar.dart';




class AdminLinkPartyMasterScreen extends StatefulWidget {
  Map id;


  AdminLinkPartyMasterScreen({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminLinkPartyMasterState();
}

class _AdminLinkPartyMasterState extends State<AdminLinkPartyMasterScreen> {
  List<Map> _list;
  List<Map> search = List<Map>();
  CalendarController _controller;
  // List<ProductDetails> mainDataList = List<ProductDetails>();
  // List<CartSummery> cart = List<CartSummery>();
  // List<ProductDetails> products;
  @override
  void initState() {

    super.initState();
    String LinkuserID=widget.id['userid'].toString();
    String LinkuserKntID= widget.id['Konnectid'].toString();
    ApiAdmin().getPartyDetails(LinkuserKntID,LinkuserID).then((value) => {
      setState(() {
        Map<String, dynamic> response = value.data;

        _list = List<Map>();
        if (response['status'] == '200') {
          response['result'].forEach((value) {
            _list.add(value);
          });
        }
        search.addAll(_list);
        print('assdf$search');
        print('Dio Response $response');
      }),
    });
  }
  Widget appBarTitle = new Text(" Link User Party Master");
  Icon actionIcon = new Icon(Icons.search);
  onChanged(String value) {
    _list= List<Map>();
    search.forEach((item) {
      String q1= item['Name'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())){

          print('search item name ${item['Name']} == ${value} ');
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
                  this.appBarTitle = new Text('Party Master');
                }


              });
            } ,),],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),

        ),
        body: Column(children: <Widget>[
          TableCalendar(
            initialCalendarFormat: CalendarFormat.month,
            calendarStyle: CalendarStyle(
                todayColor: Colors.blue,
                selectedColor: Theme.of(context).primaryColor,
                todayStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    color: Colors.white)
            ),
            headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              formatButtonDecoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.circular(22.0),
              ),
              formatButtonTextStyle: TextStyle(color: Colors.white),
              formatButtonShowsNext: false,
            ),
            startingDayOfWeek: StartingDayOfWeek.monday,
            /*onDaySelected: (date, events) {
              print(date.toUtc());
            },*/
            builders: CalendarBuilders(
              selectedDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  )),
              todayDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            calendarController: _controller,
          ),
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
                child: Text(
                  'Empty',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
                :ListView(
                children: _list.map((item) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AdminLinkPartyMasterViewScreen (id: item['master_id']),
                            ),
                          );
                        },
                        title: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                              item['Name'] ?? 'Name Error',style: (TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 16))
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }).toList()),


          )]));
  }
}
