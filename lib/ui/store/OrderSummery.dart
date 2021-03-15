import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../base/libraryExport.dart';

class OrderSummeryScreen extends StatefulWidget {
  final List<dynamic> orderFormData;
  final List<CartSummery> summery;

  const OrderSummeryScreen({
    Key key,
    this.summery,
    this.orderFormData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderSummeryState();
}

class _OrderSummeryState extends State<OrderSummeryScreen> {
  ProgressDialog pr;
  TextEditingController _orderRemark = TextEditingController();
  TextEditingController _billAddress = TextEditingController();
  TextEditingController _gstNumber = TextEditingController();
  TextEditingController _emailId = TextEditingController();
  TextEditingController _pinCode = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _name = TextEditingController();
  String accountid, addfile = "";
  File _image;
  bool fileflag = false;
  bool flagparties = false;
  UserProfile profiles;
  UserAdmin adminprofile;
  String paymentCode;
  var orderNumber;
  Map profile, response;
  List<Map> _list;
  Widget _picture;
  String   linkuserid;
  List<Map> search = List<Map>();

  _bookOrderNow() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.RIGHSLIDE,
      headerAnimationLoop: false,
      title: 'Required',
      desc: 'Required',
      body: Text('Confirmation place order'),
      btnOkText: 'Place Order',
      btnOkOnPress: () {
        List<String> unit = List<String>();
        List<String> amount = List<String>();
        List<String> product = List<String>();
        List<String> quantity = List<String>();
        List<String> productId = List<String>();
        List<String> extraParams = List<String>();
        widget.summery.forEach((element) {
          productId.add(element.id.toString());
          quantity.add(element.controller.text);
          amount.add(element.amount);
          unit.add(element.unit);
          product.add(element.product);
          extraParams.add(element.extraParams);
        });

        Map<String, dynamic> params = Map<String, dynamic>();
         params['user_id'] =linkuserid??"";
        params['file']=addfile.toString();
        params['address1'] = '';
        params['address2'] = '';
        params['email'] = _emailId.text;
        params['firm_name'] = _name.text;
        params['pincode'] = _pinCode.text;
        params['remark'] = _orderRemark.text ;
        params['address'] = _billAddress.text;
        params['gstNumber'] = _gstNumber.text;
        params['contact_number'] = _mobile.text;
        params['unit'] = unit;
        params['amount'] = amount;
        params['product'] = product;
        params['quantity'] = quantity;
        params['product_id'] = productId;
        params['account_name_id'] = accountid??"";
        params['parms'] = extraParams;
        params['orderFormData'] = widget.orderFormData ?? List<String>();

        print(params.toString());
        ProgressDialog dialog = ProgressDialog(context, isDismissible: false);
        dialog.style(
            message: 'Please Wait...',
            progressWidget: CircularProgressIndicator());
        dialog.show();
        ApiClient().addBooking(params).then((value) => {
              orderNumber = value.data['result'],

              print(value),
              dialog.hide(),

              AwesomeDialog(
                  title: 'Success',
                  context: context,
                  animType: AnimType.SCALE,
                  dismissOnTouchOutside: false,
                  btnOkIcon: Icons.check_circle,
                  dialogType: DialogType.SUCCES,
                  desc:
                      'Thank you, your order #$orderNumber has been successfully completed!',
                  btnOkOnPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => SplashScreen(),
                      ),
                    );
                  }).show(),

              //{"status":"200","message":"success","result":3585}
              AppPreferences.setString(
                  AppConstants.USER_CART_DATA, jsonEncode(List<String>())),
            });
      },
    ).show();
  }

  @override
  void initState() {
    super.initState();
    String keya = AppConstants.USER_LOGIN_DATA;
    AppPreferences.getString(keya).then((value) => {
    setState(() {
    Map<String, dynamic> response = jsonDecode(value);
    adminprofile = UserAdmin.fromJson(response);
    linkuserid = adminprofile.id.toString();
    print('aaaaaaaaaa${linkuserid}');
    }),});
    ApiClient().getPaymentButton().then((value) => {
          setState(() {
            print(value.data);
            Map response = value.data;
            if (response['status'] == '200') {
              paymentCode = response['result']['payment_code'];
              print('Payment Code $paymentCode');
            }
          }),
        });

    String key = AppConstants.USER_LOGIN_CREDENTIAL;
    _list = List<Map>();
    AppPreferences.getString(key).then((credential) {
      UserLogin login = UserLogin.formJson(credential);
      String key = AppConstants.USER_LOGIN_DATA;
      AppPreferences.getString(key).then((value) {
        setState(()  {
          Map response = jsonDecode(value);
          profiles = UserProfile.fromJson(response);
         // linkuserid = profiles.id.toString();

          if (login.isMaster && login.isLogin) {
            flagparties=true;
            _billAddress.text = profiles.address.trim();
            _gstNumber.text = profiles.gstIn.trim();
            accountid = profiles.id.toString();
            _emailId.text = profiles.email.trim();
            _mobile.text = profiles.phone.trim();
            _name.text = profiles.name.trim();
          }
          else if (login.isLinked && login.isLinked) {
            flagparties=true;
            updatelink(response['id'].toString());
            print('result 1 2');



          } else {
            flagparties=true;
      update();


          }
        });
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
        _billAddress.text =
        "${result['address'].trim() + result['address2'].trim() + result['address3']}";
        _gstNumber.text = result['gstin'].trim();
        _emailId.text =
            result['party_master_email'].trim();
        _mobile.text =
            result['contact_number'].trim();
        accountid = result['id'].toString();
        _name.text =
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
    print(_billAddress.text);

    print(result);
    setState(() {
      _billAddress.text =
      "${result['address'].trim() + result['address2'].trim() + result['address3']}";
      _gstNumber.text =
          result['gstin'].trim();
      accountid =
          result['id'].toString();
      _emailId.text =
          result['party_master_email']
              .trim();
      _mobile.text =
          result['contact_number'].trim();
      _name.text =
          result['party_master_name']
              .trim();
    });

  }
}
  Widget getItemList() {
    var grandTotalAmount = 0.00;
    var grandDiscountAmount = 0.00;
    var variantWidgets = List<Widget>();
    variantWidgets.add(Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: Text(
          'Item',
          style: TextStyle(
            fontSize: 15,
            color: Colors.blue.shade300,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Expanded(
        flex: 2,
        child: Center(
          child: Text(
            'Rate',
            style: TextStyle(
              fontSize: 15,
              color: Colors.blue.shade300,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Center(
          child: Text(
            'Amt',
            style: TextStyle(
              fontSize: 15,
              color: Colors.blue.shade300,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ]));
    variantWidgets.add(Divider());
    variantWidgets.addAll(widget.summery.map((cart) {
      double counter = double.tryParse(cart.controller.text) ?? 1;
      double amount = double.tryParse(cart.amount) ?? 0.00;
      int discount = int.tryParse(cart.discount) ?? 0;
      int gst = int.tryParse(cart.gstRate) ?? 0;

      bool isDiscount = false;
      if (cart.discountOn == 'discount_on_selling_price') {
        // discount_on_selling_price
        isDiscount = discount != 0;
        amount = double.tryParse(cart.amount) ?? 0.00;
      }
      if (cart.discountOn == 'discount_on_mrp') {
        // discount_on_mrp
        isDiscount = discount != 0;
        amount = double.tryParse(cart.price) ?? 0.00;
      }

      double subAmount = counter * amount;
      double disAmount = (subAmount * discount) / 100;

      double finalAmount = subAmount - disAmount;
      double gstAmount = (finalAmount * gst) / 100;
      double totalAmount = finalAmount + gstAmount;

      grandTotalAmount = grandTotalAmount += totalAmount;
      grandDiscountAmount = grandDiscountAmount += finalAmount;

      return Column(
        children: <Widget>[
          Row(children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    cart.product + ' - ' + cart.extraParams,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Qty - ' + cart.controller.text,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '₹ $subAmount + ₹ $gstAmount',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '(GST $gst%)',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '₹ ${(totalAmount).toStringAsFixed(2)}',
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
          ]),
          Divider(),
          isDiscount
              ? Row(children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Discount $discount%',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '₹ ${disAmount.toStringAsFixed(2)}',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ])
              : SizedBox(height: 0),
          isDiscount ? Divider() : SizedBox(height: 0),
        ],
      );
    }).toList());

    variantWidgets.add(Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 1,
            ),
          ),
          Text(
            'Total Amt : ₹ ${(grandTotalAmount).toStringAsFixed(2)}',
            style: TextStyle(fontSize: 15, color: Colors.blue.shade300),
          )
        ],
      ),
    ));
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      width: MediaQuery.of(context).size.width,
      child: Column(children: variantWidgets),
    );
  }





  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }



  _uploadPicture(File image) async {
    setState(() {
      _picture = GFLoader();
    });
    ApiClient().uploadFile(image.path).then((value) => {
          setState(() {
            Map<String, dynamic> response = value.data;

            _list = List<Map>();
            if (response['status'] == '200') {
              addfile = response['result'];
              fileflag = true;
            }
            print(response);
          }),
        });

    print('UploadFileResult $response');

    // response = (await ApiClient().updatePartyMaster(profile)).data;
    // print('ProfileUpdateResult $response');
    // loadProfile();
  }

  attachedFileDialog(BuildContext context, id) {
    AlertDialog alert = new AlertDialog(
      content: SafeArea(
        child: Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Photo Library'),
                  onTap: () async {
                    File image = await UtilsImage.getFromGallery();
                    _uploadPicture(image);
                    Navigator.of(context).pop();
                  }),
              new ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text('Camera'),
                onTap: () async {
                  File image = await UtilsImage.getFromCamera();
                  _uploadPicture(image);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
      actions: [],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  Widget getShippingForm() {
    var variantWidgets = List<Widget>();

    variantWidgets.add(SizedBox(height: 10.0));
    variantWidgets.add(
      Center(
        child: Text(
          'BILLING SHIPPING INFO',
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    variantWidgets.add(SizedBox(height: 20.0));
    variantWidgets.add(TextFormField(
      autofocus: false,
      controller: _name,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        hintText: 'Firm Name',
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.business),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
      ),
    ));
    variantWidgets.add(SizedBox(height: 6.0));
    variantWidgets.add(TextFormField(
      autofocus: false,
      controller: _mobile,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        hintText: 'Phone Number',
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.phone),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
      ),
    ));
    variantWidgets.add(SizedBox(height: 6.0));
    variantWidgets.add(TextFormField(
      autofocus: false,
      controller: _emailId,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        filled: true,
        hintText: 'Email Id',
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.email),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
      ),
    ));
    variantWidgets.add(SizedBox(height: 6.0));
    variantWidgets.add(TextFormField(
      autofocus: false,
      controller: _gstNumber,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        hintText: 'GST-IN',
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.insert_comment),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
      ),
    ));
    variantWidgets.add(SizedBox(height: 6.0));
    variantWidgets.add(TextFormField(
      maxLines: null,
      autofocus: false,
      controller: _billAddress,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        filled: true,
        hintText: 'Address',
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.map),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
      ),
    ));
    variantWidgets.add(SizedBox(height: 6.0));
    variantWidgets.add(TextFormField(
      autofocus: false,
      controller: _pinCode,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        hintText: 'Pin Code',
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.fiber_pin),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
      ),
    ));
    variantWidgets.add(SizedBox(height: 6.0));
    variantWidgets.add(TextFormField(
      maxLines: null,
      autofocus: false,
      controller: _orderRemark,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        filled: true,
        hintText: 'Remark',
        fillColor: Colors.white,
        suffixIcon: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.grey.shade400,
                  width: 50,
                  height: 50,
                  child: IconButton(
                    icon: Icon(Icons.attach_file_sharp),
                    iconSize: 26,
                    color: Colors.white,
                    onPressed: () {
                      attachedFileDialog(context, "2");
                    },
                  ),
                ),
              ),
              Text(fileflag ? "File Uploaded" : "",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 9,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        prefixIcon: Icon(Icons.mode_comment),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
      ),
    ));
    variantWidgets.add(SizedBox(height: 30.0));

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.blue.shade300,
          border: Border.all(color: Colors.grey.shade50, width: 1),
          borderRadius: BorderRadius.circular(12.0)),
      width: MediaQuery.of(context).size.width,
      child: Column(children: variantWidgets),
    );
  }

  Widget getSubmitButton() {
    return Row(
      children: <Widget>[
        SizedBox(width: 16),
        getPaymentButton(),
        SizedBox(width: 6),
        Expanded(
          child: GFButton(
              size: 45,
              text: 'PAY LATER',
              color: Colors.blue.shade300,
              fullWidthButton: true,
              onPressed: () {
                if (_name.text.length > 4 &&
                    _mobile.text.length > 9 &&
                    _billAddress.text.length > 4) {
                  _bookOrderNow();
                }
                // Error
                else {
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          animType: AnimType.RIGHSLIDE,
                          headerAnimationLoop: false,
                          title: 'Required',
                          desc: 'Name, Phone or  Full Address is required',
                          btnOkOnPress: () {},
                          btnOkIcon: Icons.cancel,
                          btnOkColor: Colors.red)
                      .show();
                }
              }),
        ),
        SizedBox(width: 16),
      ],
    );
  }

  Widget getPaymentButton() {
    return paymentCode == null
        ? SizedBox(width: 0)
        : Expanded(
            child: GFButton(
                size: 45,
                text: 'PAY NOW',
                fullWidthButton: true,
                type: GFButtonType.outline,
                onPressed: () {
                  if (_name.text.length > 4 &&
                      _mobile.text.length > 9 &&
                      _billAddress.text.length > 4) {
                    String url = Uri.dataFromString(
                      paymentCode,
                      mimeType: 'text/html',
                      encoding: Encoding.getByName('utf-8'),
                    ).toString();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => InAppWebViewPage(
                          title: 'Payment',
                          url: url,
                        ),
                      ),
                    ).then(
                      (value) => _bookOrderNow(),
                    );
                  }
                  // Error
                  else {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            animType: AnimType.RIGHSLIDE,
                            headerAnimationLoop: false,
                            title: 'Required',
                            desc: 'Name, Phone and Address is required',
                            btnOkOnPress: () {},
                            btnOkIcon: Icons.cancel,
                            btnOkColor: Colors.red)
                        .show();
                  }
                }),
          );
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Loading Parties...');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
            pr.hide();
          },
        ),
        title: Text('Order summary'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(12),
            children: <Widget>[
              getItemList(),
              flagparties ? getShippingForm() : Container(),
            ],
          ),
        ),
        flagparties ? getSubmitButton() : Container(),
        SizedBox(height: 16),
      ]),
    );
  }

//prefixIcon: Image(image: AssetImage('assets/search_field.png')),
}

class PartyMasterScreenforin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PartyMasterStateforin();
}

class _PartyMasterStateforin extends State<PartyMasterScreenforin> {
  List<Map> _list;
  Map profile, response;
bool flagparties =false;
  ProgressDialog pr;
  UserProfile profiles;
  List<Map> search = List<Map>();
  // List<ProductDetails> mainDataList = List<ProductDetails>();
  // List<CartSummery> cart = List<CartSummery>();
  // List<ProductDetails> products;
  @override
  void initState() {
    super.initState();
update();


  }

update(){
 // pr.show();
  Future.delayed(
      Duration(seconds: 1))
      .then((value) {
    pr.hide().whenComplete(() {
      _list = List<Map>();
      ApiAdmin().getPartyMaster().then((value) => {
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

    });
  });
}
  Widget appBarTitle = new Text("Party Master");
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

          Expanded(
            child:
            _list == null
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
              child:Center(
                heightFactor:  MediaQuery.of(context).size.height-100,
                widthFactor:   MediaQuery.of(context).size.width-100,
                child:Image(image: AssetImage('images/nodatafound.png'),
                ),
              ),
            )
                :ListView(
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
                        //  print(response['result']);

                          Map result = response['result'];
                          Navigator.of(context).pop(result);



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


          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              child: Container(
                  height: 50,
                  color: Colors.lightBlue,
                  width: MediaQuery.of(context).size.width - 10,
                  child: RaisedButton(
                      color: Colors.lightBlue,
                      onPressed: () {
                        Navigator.of(context).pop();
                        //pr.hide();
                      },
                      child: Text("New  Business Party",
                          style: TextStyle(color: Colors.white)))),
            ),
          ),
        ]));
  }
}
class LinkUserPartyMasterScreenin extends StatefulWidget {
  final id;

  const LinkUserPartyMasterScreenin({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LinkUserPartyMasterStatein();
}

class _LinkUserPartyMasterStatein extends State<LinkUserPartyMasterScreenin> {
  List<Map> _list;
  List<Map> search = List<Map>();
  @override
  void initState() {
    super.initState();

    ApiAdmin().getLinkUserPartyMaster(widget.id).then((value) => {
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
  Widget appBarTitle = new Text("Party Master");
  Icon actionIcon = new Icon(Icons.search);
  onChanged(String value) {
    _list= List<Map>();
    search.forEach((item) {
      String q1= item['party_master_name'];

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())){

          print('search item name ${item['party_master_name']} == ${value} ');
          _list.add(item);
        }
      });

    });



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar:  AppBar(
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

          Expanded(
            child:
            _list == null
                ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: GFLoader(loaderColorOne: Colors.white),
              ),
            )
                : _list.isEmpty
                ?Center(
              child: Container(
                alignment: Alignment.center,
                width: 200,
                height: 200,
                child:Center(

                  child:Image(image: AssetImage('images/nodatafound.png'),
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
                              item['id']))
                              .data;

                       //   profile = Map();
                          print(response['result']);

                          Map result = response['result'];
                          Navigator.of(context).pop(result);
                        },
                        title: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            item['party_master_name'] ?? 'Name Error',style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }).toList()),),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              child: Container(
                  height: 50,
                  color: Colors.lightBlue,
                  width: MediaQuery.of(context).size.width - 10,
                  child: RaisedButton(
                      color: Colors.lightBlue,
                      onPressed: () {
                        Navigator.of(context).pop();
                        //pr.hide();
                      },
                      child: Text("New  Business Party",
                          style: TextStyle(color: Colors.white)))),
            ),
          ),])
    );
  }
}
