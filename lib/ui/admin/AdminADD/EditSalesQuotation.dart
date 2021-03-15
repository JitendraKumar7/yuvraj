import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:yuvrajpipes/ui/admin/AdminSalesQuotation.dart';
import 'package:yuvrajpipes/ui/base/libraryExport.dart';
import 'package:yuvrajpipes/ui/link/LinkUserSalesQuatation.dart';

class EditSalesQuotationScreen extends StatefulWidget {
  final String id;

  const EditSalesQuotationScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditSalesQuotationState();
  }
}

class EditSalesQuotationState extends State<EditSalesQuotationScreen> {
  ProgressDialog pr;
  TextEditingController _partyname = TextEditingController();
  TextEditingController _partyAddress = TextEditingController();
  TextEditingController _partygstNumber = TextEditingController();
  TextEditingController _partydate = TextEditingController();

  TextEditingController _partymobile = TextEditingController();
  List<String> _quantity ;
  List<String> _desc;

  List<String> _item ;
  List<String> _amount ;
  List<TextEditingController> _partytrc = [];


  List<String> totalitems1 = List();
  List<String> totalquantits1=List();
  List<String> totalrate1=List();
  List<String> totaldes1= List();
  String totalitems= "";
  String totalquantits= "";
  String totalrate= "";
  String totaldes= "";
  //TextEditingController _additemindex =TextEditingController();
  List<String> totaltrc=List();
  String totaltrcstring="";
  UserProfile profiles;
  String paymentCode;
  var orderNumber;
  String _tradePrice;
  String _price;
  List<ProductDetails> products;
  List<ProductDetails> mainDataList = List<ProductDetails>();
  final List<CartSummery> cart = List<CartSummery>();
  final List<String> images = List<String>();
  ProductDetails _productDetails;
  Map profile;
  List<Map> _list;
  bool flag = false;
  List<Widget> _childrenlink = List();
  List<Widget> _childrentrc = List();
  KonnectDetails konnectDetails;
  Map<String, dynamic> result;
  int _countlink = 1;
  List<Map> search = List<Map>();
  Widget appBarTitle = new Text(" Your Parties");
  Icon actionIcon = new Icon(Icons.search);
  UserAdmin adminprofile;
  String adminkonnectid, linkkonnectid, linkuserid;
  Map linkresult;



  int _counttrc=1;
  @override
  void initState() {
    super.initState();
    String keya = AppConstants.USER_LOGIN_DATA;
    AppPreferences.getString(keya).then((value) => {
          setState(() {
            Map<String, dynamic> response = jsonDecode(value);
            adminprofile = UserAdmin.fromJson(response);
            linkuserid = adminprofile.id.toString();
            // print("vikas");
            // print(adminprofile.id);
            ApiAdmin().getLinkUserKonnectid(adminprofile.id).then((value) => {
                  setState(() {
                    Map<String, dynamic> response = value.data;
                    linkresult = response['result'][0];
                    linkkonnectid = linkresult['link_user_konnect_id'].toString();
                    adminkonnectid = linkresult['konnect_id'].toString();
                    List<String> itemslist = result['item'].cast<String>();
                    List<String> quantieslist  = result['quantity'].cast<String>();
                    List<String> ratelist = result[' price'].cast<String>();
                    List<String> deslist = result['description'].cast<String>();

                    //  print(linkkonnectid);
                    // print(ab);
                  })
                });
            print("vikas");
          })
        });
    // pr.show();
    Future.delayed(Duration(seconds: 1)).then((value) {
      pr.hide().whenComplete(() {
        updateEditdata();
      });
    });
  }
  _addLinkup(){ Fluttertoast.showToast(
    msg: "Fill Upform first",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,

  );}
  updateEditdata() {
    pr.show();
    Future.delayed(Duration(seconds: 1)).then((value) {
      pr.hide().whenComplete(() {
        ApiClient().getProductCart().then((value) => {
              setState(() {
                Map<String, dynamic> response = value.data;
                products = List<ProductDetails>();
                if (response['status'] == '200') {
                  response['result'].forEach((v) {
                    products.add(ProductDetails.fromJson(v));
                  });
                }
                mainDataList.addAll(products);
                print(response);
              })
            });

        setState(() {
          ApiAdmin().getQuotationById(widget.id).then((value) => {
                setState(() {
                  print(value.data);
                  Map<String, dynamic> response = value.data;
                  if (response['status'] == '200') {
                    result = response['result'][0];
                    _item=List();
                    _desc=List();
                    _quantity=List();
                    _amount=List();
                     _quantity = result['quantity'].cast<String>();
                    _desc = result['description'].cast<String>();
                     _item = result['item'].cast<String>();
                     _amount = result['price'].cast<String>();
                    _partyname.text = result['name'];
                    _partygstNumber.text = result['gst_number'];
                    _partydate.text = result['date'];
                    _partyAddress.text = result['address'];
                     _partymobile.text=result['mobile_number'];
                   // totaltrcstring= result['tnc'].split('//');

                    List<String> trc= result['tnc'].toString().split("//");
                    for(int i=0;i<_item.length;i++) {


                      _getRowWidget('${_item[i]}', '${_amount[i]}', '${_quantity[i]}', '${_desc[i]}',);



                    }
          for(int i=0;i<trc.length;i++) {
                    _getRowtrcWidget('${trc[i]}');}
                    print('outputresultvikas$result');
                  }
                })
              });
        });

        String key = AppConstants.USER_LOGIN_CREDENTIAL;
        _list = List<Map>();
        AppPreferences.getString(key).then((credential) {
          UserLogin login = UserLogin.formJson(credential);
          String key = AppConstants.USER_LOGIN_DATA;
          AppPreferences.getString(key).then((value) {
            setState(() {
              Map response = jsonDecode(value);
              profiles = UserProfile.fromJson(response);
              if (login.isLinked && login.isLinked) {
                flag = true;

                ApiAdmin()
                    .getLinkUserPartyMaster(response['id'])
                    .then((value) => {
                          setState(() {
                            Map<String, dynamic> response = value.data;
                            _list = List();
                            if (response['status'] == '200') {
                              response['result'].forEach((value) {
                                _list.add(value);
                              });
                            }
                            search.addAll(_list);

                            print('aaaaaaaaaaaa${_list}');
                            print('ssssssssss${response}');
                            // _settingModalBottomSheet(context);
                          }),
                        });
                //Navigator.of(context).pop();

              } else {
                ApiAdmin().getPartyMaster().then((value) => {
                      setState(() {
                        Map<String, dynamic> response = value.data;
                        _list = List();
                        if (response['status'] == '200') {
                          response['result'].forEach((value) {
                            _list.add(value);
                          });
                        }
                        search.addAll(_list);

                        print('aaaaaaaaaaaa${_list}');
                        print('ssssssssss${response}');
                        // _settingModalBottomSheetAdmin(context);
                      }),
                    });
                //Navigator.of(context).pop();

              }
            });
          });
        });
      });
    });
  }

  onChang(String value) {
    setState(() {
      products = mainDataList
          .where(
            (item) => item.name.toLowerCase().contains(
                  value.toLowerCase(),
                ),
          )
          .toList();
    });
  }
  void _AllProductItemList(context,_item) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  autofocus: false,
                  onChanged: onChang,
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
                ),
              ),
              Expanded(
                child: products == null
                    ? Center(
                  child: GFLoader(),
                )
                    : products.isEmpty
                    ? Center(
                  child: Text(
                    'Empty',
                    style: TextStyle(
                        fontSize: 48, color: Colors.black87),
                  ),
                )
                    : ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {



                      return Card(
                        elevation: 8.0,
                        child: InkWell(
                          onTap: () {
                            final int id = products[index].id;
                            ApiClient().getItemById(id).then((value) =>
                            {
                              setState(() {
                                Map<String, dynamic> response =
                                    value.data;

                                if (response['status'] == '200') {
                                  setState(() {
                                    _productDetails =
                                        ProductDetails.fromJson(
                                            response['result']);
                                    _tradePrice =
                                        _productDetails.tradePrice;
                                    _item['_controller1'].text =
                                        _productDetails.name;
                                    //textEditingControllers[_countlink].text=_productDetails.name??"";

                                    _item['_controller2'].text =
                                        _productDetails.tradePrice;
                                    _price = _productDetails.price;
                                    print(response['result']);
                                    pr.show();
                                    Future.delayed(
                                        Duration(seconds: 1))
                                        .then((value) {
                                      pr.hide().whenComplete(() {
                                        Navigator.of(context).pop();
                                      });
                                    });

                                    images
                                        .add(_productDetails.image);
                                    if (_productDetails
                                        .image2.length >
                                        45) {
                                      images.add(
                                          _productDetails.image2);
                                    }
                                    if (_productDetails
                                        .image3.length >
                                        45) {
                                      images.add(
                                          _productDetails.image3);
                                    }
                                  });
                                }

                                print(value.data);
                              }),
                            });
                          },
                          child: ListTile(
                            leading: FadeInImage.assetNetwork(
                              image: products[index].image,
                              placeholder: 'images/iv_empty.png',
                              height: 80,
                              width: 60,
                            ),
                            title: Text(
                              '${products[index].name}',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '₹ ${products[index].tradePrice}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ]),
          );
        });
  }

  onChanged(String value) {
    _list = List<Map>();
    search.forEach((item) {
      String q1 = item['party_master_name'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())) {
          print('search item name ${item['party_master_name']} == ${value} ');
          _list.add(item);
        }
      });
    });
  }
  updatelink(String id) async {
    dynamic result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LinkUserPartyMasterScreenin(id:id ,),

      ),
    );
    print('result 1 $result');

    if(result!=null){
      setState(() {
        _partyAddress.text =
        "${result['address'].trim() + result['address2'].trim() + result['address3']}";
        _partygstNumber.text =
            result['gstin'].trim();
        //_ema.text = result['party_master_email'].trim();
        _partymobile.text =
            result['contact_number'].trim();
        _partyname.text =
            result['party_master_name'].trim();
        print('vikas${result}');
      });

    }
  }
  update() async {
    dynamic result=await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => PartyMasterScreenforin(),
      ),
    );


    if(result!=null){
      print('result $result');


      print(result);
      setState(() {
        _partyAddress.text =
        "${result['address'].trim() + result['address2'].trim() + result['address3']}";
        _partygstNumber.text =
            result['gstin'].trim();
        //  _p.text = result['party_master_email'].trim();
        _partymobile.text =
            result['contact_number'].trim();
        _partyname.text =
            result['party_master_name'].trim();
      });

    }
  }
  onChangedAdmin(String value) {
    _list = List<Map>();
    search.forEach((item) {
      String q1 = item['Name'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())) {
          print('search item name ${item['Name']} == ${value} ');
          _list.add(item);
        }
      });
    });
  }

  List<Map<String, TextEditingController>> _listItem = List();

  Widget _getRowWidget(String value1, String value2, String value3,
      String value4) {
    print('_get Row Widget call _get Row Widget');
    TextEditingController _controller1 = TextEditingController();
    TextEditingController _controller2 = TextEditingController();
    TextEditingController _controller3 = TextEditingController();
    TextEditingController _controller4 = TextEditingController();
    _controller1.text = value1;
    _controller2.text = value2;
    _controller3.text = value3;
    _controller4.text = value4;

    Map<String, TextEditingController> _item = Map();
    _item['_controller1'] = _controller1;
    _item['_controller2'] = _controller2;
    _item['_controller3'] = _controller3;
    _item['_controller4'] = _controller4;

    setState(() {

      _childrenlink.add(Container(


        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Add Item';
                      }
                      return null;},                      // readOnly: true,
                    controller: _controller1,
                    onTap: () {
                      _AllProductItemList(context,_item);
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    //  validator: _validateEmail,
                    onFieldSubmitted: (String value) {
                      //   FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                    decoration: InputDecoration(
                      labelText: 'ITEM ADD',
                      // filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      //prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  child: TextFormField(
                    controller: _controller2,
                    onTap: () {},
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    //  validator: _validateEmail,
                    onFieldSubmitted: (String value) {
                      //   FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                    decoration: InputDecoration(
                      labelText: 'PRICE',
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      //prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  child: TextFormField(
                    //  readOnly: true,
                    controller: _controller3,
                    onTap: () {
                      //  _AllProductItemList(context);
                    },
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    //  validator: _validateEmail,
                    onFieldSubmitted: (String value) {
                      //   FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                    decoration: InputDecoration(
                      labelText: 'QUANTITY',
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      //prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  child: TextFormField(
                    controller: _controller4,

                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.next,
                    //  validator: _validateEmail,
                    onFieldSubmitted: (String value) {
                      //   FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                    decoration: InputDecoration(
                      labelText: 'DESCRIPTION',
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      //prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ))
      ;
      _listItem.add(_item);
    });
  }
  List<Map<String, TextEditingController>> _listItemtrc = List();

  Widget _getRowtrcWidget(String value1) {
    print('_get Row Widget call _get Row Widget');
    TextEditingController _controller1 = TextEditingController();

    _controller1.text = value1;


    Map<String, TextEditingController> _itemtrc = Map();
    _itemtrc['_controller1'] = _controller1;


    setState(() {

      _childrentrc.add(Container(


        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child:    Container(
                  child: TextFormField(
                    controller: _controller1,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.next,
                    //  validator: _validateEmail,
                    onFieldSubmitted: (String value) {
                      //   FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                    decoration: InputDecoration(
                        labelText: 'Terms & Conditions',
                        //prefixIcon: Icon(Icons.email),
                        icon: Icon(Icons.comment)),
                  ),
                ),
              ),
            ),

          ],
        ),
      ))
      ;
      _listItemtrc.add(_itemtrc);
    });
  }

  void _partyListAdmin(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        // backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  autofocus: false,
                  onChanged: onChangedAdmin,
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
                ),
              ),
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
                        ? Center(
                            child: Container(
                              alignment: Alignment.center,
                              width: 200,
                              height: 200,
                              child: Center(
                                child: Image(
                                  image: AssetImage('images/nodatafound.png'),
                                ),
                              ),
                            ),
                          )
                        : ListView(
                            children: _list.map((item) {
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  onTap: () async {
                                    Map response = (await ApiClient()
                                            .getPartyMasterProfile(
                                                item['master_id']))
                                        .data;

                                    profile = Map();
                                    print(response['result']);

                                    Map result = response['result'];
                                    _partyAddress.text =
                                        "${result['address'].trim() + result['address2'].trim() + result['address3']}";
                                    _partygstNumber.text =
                                        result['gstin'].trim();
                                    //  _p.text = result['party_master_email'].trim();
                                    _partymobile.text =
                                        result['contact_number'].trim();
                                    _partyname.text =
                                        result['party_master_name'].trim();
                                    pr.show();
                                    Future.delayed(Duration(seconds: 1))
                                        .then((value) {
                                      pr.hide().whenComplete(() {
                                        Navigator.of(context).pop();
                                      });
                                    });

                                    profile['id'] = result['id'];
                                    profile['name'] =
                                        result['party_master_name'];
                                    profile['address1'] = result['address'];
                                    profile['address2'] = result['address2'];
                                    profile['address3'] = result['address3'];
                                    profile['country'] = result['country'];
                                    profile['state'] = result['state'];
                                    profile['city'] = result['city'];
                                    profile['contact_number'] =
                                        result['contact_number'];
                                    profile['email'] =
                                        result['party_master_email'];
                                    profile['bank_name'] = result['bank_name'];
                                    profile['gstin'] = result['gstin'];
                                    profile['ifsc_code'] = result['ifsc_code'];
                                    profile['account_number'] =
                                        result['account_number'];
                                    profile['account_name'] =
                                        result['account_name'];
                                    profile['opening_balance'] =
                                        result['opening_balance'];
                                    profile['debit_credit'] =
                                        result['debit_credit'];
                                    profile['credit_period'] =
                                        result['credit_period'];
                                    profile['credit_days'] =
                                        result['credit_days'];
                                    profile['credit_amount'] =
                                        result['credit_amount'];
                                    profile['password'] = result['password'];
                                    profile['confirm_password'] =
                                        result['password'];
                                    profile['image'] = result['image'];
                                    profile['party_master_id'] = result['id'];
                                    profile['alternative_contact_number'] =
                                        result['alternative_contact_number'];
                                    profile['add_from'] = result['add_from'];
                                    profile['group_type'] =
                                        result['group_type'];
                                    profile['closingBalance'] =
                                        result['closingBalance'];
                                  },
                                  title: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      item['Name'] ?? 'Name Error',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          }).toList()),
              )
            ]),
          );
        });
  }

  void _partyListLink(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        // backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
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
                ),
              ),
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
                        ? Center(
                            child: Container(
                              alignment: Alignment.center,
                              width: 200,
                              height: 200,
                              child: Center(
                                child: Image(
                                  image: AssetImage('images/nodatafound.png'),
                                ),
                              ),
                            ),
                          )
                        : ListView(
                            children: _list.map((item) {
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  onTap: () async {
                                    Map response = (await ApiClient()
                                            .getPartyMasterProfile(item['id']))
                                        .data;

                                    profile = Map();
                                    print(response['result']);

                                    Map result = response['result'];
                                    _partyAddress.text =
                                        "${result['address'].trim() + result['address2'].trim() + result['address3']}";
                                    _partygstNumber.text =
                                        result['gstin'].trim();
                                    //_ema.text = result['party_master_email'].trim();
                                    _partymobile.text =
                                        result['contact_number'].trim();
                                    _partyname.text =
                                        result['party_master_name'].trim();
                                    pr.show();
                                    Future.delayed(Duration(seconds: 1))
                                        .then((value) {
                                      pr.hide().whenComplete(() {
                                        Navigator.of(context).pop();
                                      });
                                    });

                                    profile['id'] = result['id'];
                                    profile['name'] =
                                        result['party_master_name'];
                                    profile['address1'] = result['address'];
                                    profile['address2'] = result['address2'];
                                    profile['address3'] = result['address3'];
                                    profile['country'] = result['country'];
                                    profile['state'] = result['state'];
                                    profile['city'] = result['city'];
                                    profile['contact_number'] =
                                        result['contact_number'];
                                    profile['email'] =
                                        result['party_master_email'];
                                    profile['bank_name'] = result['bank_name'];
                                    profile['gstin'] = result['gstin'];
                                    profile['ifsc_code'] = result['ifsc_code'];
                                    profile['account_number'] =
                                        result['account_number'];
                                    profile['account_name'] =
                                        result['account_name'];
                                    profile['opening_balance'] =
                                        result['opening_balance'];
                                    profile['debit_credit'] =
                                        result['debit_credit'];
                                    profile['credit_period'] =
                                        result['credit_period'];
                                    profile['credit_days'] =
                                        result['credit_days'];
                                    profile['credit_amount'] =
                                        result['credit_amount'];
                                    profile['password'] = result['password'];
                                    profile['confirm_password'] =
                                        result['password'];
                                    profile['image'] = result['image'];
                                    profile['party_master_id'] = result['id'];
                                    profile['alternative_contact_number'] =
                                        result['alternative_contact_number'];
                                    profile['add_from'] = result['add_from'];
                                    profile['group_type'] =
                                        result['group_type'];
                                    profile['closingBalance'] =
                                        result['closingBalance'];
                                  },
                                  title: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      item['party_master_name'] ?? 'Name Error',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          }).toList()),
              )
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    return Scaffold(
        appBar: AppBar(title: Text("Edit SalesQuotation")),
        body: ListView(
          shrinkWrap: true,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5),
                child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 10.0,
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          // key: _keyValidationForm,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _partyname,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (String value) {
                                    //FocusScope.of(context).requestFocus(_passwordEmail);
                                  },
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.contact_page_sharp),
                                        color: Colors.blue,
                                        iconSize: 30,
                                        onPressed: () {
                                          pr.show();
                                          Future.delayed(Duration(seconds: 1))
                                              .then((value) {
                                            pr.hide().whenComplete(() {
                                              if (flag == true) {
                                                updatelink(linkuserid);
                                              } else {
                                                update();
                                              }
                                            });
                                          });
                                        },
                                      ),
                                      labelText: 'PARTY NAME',
                                      //prefixIcon: Icon(Icons.email),
                                      icon: Icon(Icons.business)),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _partygstNumber,
                               //   readOnly: true,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  //  validator: _validateEmail,
                                  onFieldSubmitted: (String value) {
                                    //   FocusScope.of(context).requestFocus(_passwordFocus);
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'GST NO',
                                      //prefixIcon: Icon(Icons.email),
                                      icon: Icon(Icons.g_translate)),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _partymobile,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  //  validator: _validateEmail,
                                  onFieldSubmitted: (String value) {
                                    //   FocusScope.of(context).requestFocus(_passwordFocus);
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'MOBILE NO',
                                      //prefixIcon: Icon(Icons.email),
                                      icon: Icon(Icons.phone)),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                               //   readOnly: true,
                                  controller: _partyAddress,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (String value) {
                                    //FocusScope.of(context).requestFocus(_passwordEmail);
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'ADDRESS',
                                      //prefixIcon: Icon(Icons.email),
                                      icon: Icon(Icons.location_on)),
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: _partydate,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1947, 12),
                                      lastDate: DateTime(2199, 12),
                                    ).then((pickedDate) {
                                      _partydate.text =
                                          DateFormat.yMMMd().format(pickedDate);
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (String value) {
                                    //FocusScope.of(context).requestFocus(_passwordEmail);
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'DATE',

                                      //prefixIcon: Icon(Icons.email),
                                      icon: Icon(Icons.date_range)),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  child: Column(
                                    children: _childrenlink,
                                  )),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _listItem.length>1? Expanded(
                                        child: IconButton(
                                          icon: Icon(Icons.remove),
                                          iconSize: 28,
                                          color: Colors.blue,
                                          onPressed: () {
                                            setState(() {if(_listItem.length>1){
                                              _childrenlink.removeLast();
                                              _listItem.removeLast();}
                                            });
                                          },
                                        )): Expanded(child: Text("")),
                                    Expanded(child: Text("")),
                                    Expanded(child: Text("")),
                                    Expanded(child: Text("")),
                                    IconButton(
                                        icon: Icon(Icons.add),
                                        iconSize: 28,
                                        color: Colors.blue,
                                        onPressed: () {

                                          _getRowWidget('', '', '', '');
                                        }                                  )
                                  ],
                                ),
                              ),

                              Container(
                                  child: Column(
                                    children: _childrentrc,
                                  )),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    _listItemtrc.length>1?Expanded(
                                        child: IconButton(
                                          icon: Icon(Icons.remove),
                                          iconSize: 28,
                                          color: Colors.blue,
                                          onPressed:(){
                                            setState(() {if(_listItemtrc.length>1){
                                              _childrentrc.removeLast();
                                              _listItemtrc.removeLast();}
                                            });
                                          } ,
                                        )):  Expanded(child: Text("")),

                                    Expanded(child: Text("")),
                                    Expanded(child: Text("")),
                                    Expanded(child: Text("")),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      iconSize: 28,
                                      color: Colors.blue,
                                      onPressed:(){
                                        _getRowtrcWidget('');
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 32.0, left: 30, right: 30, bottom: 30),
                                width: double.infinity,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  // color: AppColors.colorAccent,
                                  textColor: Colors.white,
                                  elevation: 5.0,

                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 20.0),
                                  child: Text(
                                    'SAVE',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  onPressed: () {
                                    for (int i = 0; i < _listItem.length; i++) {
                                      Map<String, TextEditingController> _item = _listItem[i];
                                      totalitems=totalitems+'${_item['_controller1'].text}//';
                                      totalrate=totalrate+'${_item['_controller2'].text}//';
                                      totalquantits=totalquantits+'${_item['_controller3'].text}//';
                                      totaldes=totaldes+'${_item['_controller4'].text}//';

                                      print(totalitems);
                                      print(
                                          '==> $i _controller1 ${_item['_controller1'].text}');
                                      print(
                                          '==> $i _controller2 ${_item['_controller2']
                                              .text}');
                                      print(
                                          '==> $i _controller3 ${_item['_controller3']
                                              .text}');
                                      print(
                                          '==> $i _controller4 ${_item['_controller4']
                                              .text}');
                                    }
                                    for (int i = 0; i < _listItemtrc.length; i++) {

                                      Map<String, TextEditingController> _item = _listItemtrc[i];
                                      totaltrcstring=totaltrcstring+'${_item['_controller1'].text}//';
                                      print(
                                          '==> $i _controller1 ${_item['_controller1']
                                              .text}');}


                                    Map<String, dynamic> params =
                                        Map<String, dynamic>();
                                    params['id']=widget.id.toString();
                                    params['name'] = _partyname.text;
                                    params['gst_number'] = _partygstNumber.text;
                                    params['get_date'] = _partydate.text;
                                    params['address'] = _partyAddress.text;
                                   params['item'] = totalitems;
                                    params['quantity'] = totalquantits;
                                    params['price'] =totalrate;
                                    params['mobileno'] = _partymobile.text;
                                    params['description'] =totaldes
                                       ;
                                    params['tnc'] =  totaltrcstring;
                                    if (flag != true) {
                                      params['konnect_id'] = adminkonnectid;

                                      ApiAdmin()
                                          .editQuotation(params)
                                          .then((value) => {
                                                setState(() {
                                                  // dialog.hide();
                                                  print(value.data);
                                                  Map<String, dynamic>
                                                      response = value.data;
                                                  if (response['status'] ==
                                                      '200') {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            AdminSalesQuotationScreen(),
                                                      ),
                                                    );

                                                  }
                                                //  Navigator.of(context).pop();
                                                  print(value);
                                                })
                                              });
                                    } else {
                                      params['konnect_id'] = adminkonnectid;

                                      ApiAdmin()
                                          .editQuotation(params)
                                          .then((value) => {
                                                setState(() {
                                                  // dialog.hide();
                                                  print(value.data);
                                                  Map<String, dynamic>
                                                      response = value.data;
                                                  if (response['status'] ==
                                                      '200') {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            LinkUserSalesQuatationScreen(
                                                                id: linkuserid),
                                                      ),
                                                    );

                                                  }
                                                //  Navigator.of(context).pop();

                                                  print(value);
                                                })
                                              });
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                ),
                              ),
                            ],
                          ),
                        )))),
          ],
        ));
  }
}
