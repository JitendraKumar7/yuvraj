import 'package:yuvrajpipes/ui/link/LinkUserSalesQuatation.dart';

import '../base/libraryExport.dart';
import 'LinkUserActivityList.dart';
import 'LinkUserExpanseReport.dart';

class LinkUserDashboardScreen extends StatefulWidget {
  final KonnectDetails konnectDetails;

  LinkUserDashboardScreen(this.konnectDetails);

  @override
  State<StatefulWidget> createState() => _LinkUserDashboardState();
}

class _LinkUserDashboardState extends State<LinkUserDashboardScreen> {
  List<CartSummery> cart = List<CartSummery>();
  UserAdmin profile;

  @override
  void initState() {
    super.initState();

    String key = AppConstants.USER_LOGIN_DATA;
    AppPreferences.getString(key).then((value) => {
          setState(() {
            Map<String, dynamic> response = jsonDecode(value);
            profile = UserAdmin.fromJson(response);
            print("vikas");
            print(profile.toJson());
            print("vikas");
          })
        });
    onBackPressed();
  }

  onBackPressed() {
    print('Back Pressed');
    String key = AppConstants.USER_CART_DATA;
    AppPreferences.getString(key).then((value) => {
          setState(() {
            if (value != null) {
              cart = List<CartSummery>();
              for (Map json in jsonDecode(value)) {
                cart.add(CartSummery.fromJson(json));
              }
            }
          })
        });
  }

  Widget getCart() {
    return cart.isEmpty
        ? IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => OrderCartScreen(),
                ),
              ).then(
                (value) => onBackPressed(),
              );
            })
        : GFIconBadge(
            child: GFIconButton(
              size: GFSize.LARGE,
              color: Colors.transparent,
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => OrderCartScreen(),
                  ),
                ).then(
                  (value) => onBackPressed(),
                );
              },
            ),
            counterChild: GFBadge(
              shape: GFBadgeShape.circle,
              color: Colors.orangeAccent,
              child: Text(cart.length.toString()),
            ),
          );
  }

  Widget getProfile() {
    bool isEmpty = profile == null
        ? true
        : profile.image == null ? true : profile.image.isEmpty;

    return isEmpty
        ? Icon(
            Icons.perm_identity,
            size: 48,
          )
        : FadeInImage.assetNetwork(
            width: 80,
            height: 80,
            image: profile.image,
            placeholder: 'images/iv_empty.png',
          );
  }

  String getProfileName() {
    bool isEmpty = profile == null
        ? true
        : profile.name == null ? true : profile.name.isEmpty;

    return isEmpty
        ? widget.konnectDetails.basicInfo.organisation
        : profile.name;
  }

  String getProfileContact() {
    bool isEmpty = profile == null
        ? true
        : profile.contact == null ? true : profile.contact.isEmpty;

    return isEmpty
        ? widget.konnectDetails.basicInfo.categoryOfBusiness
        : profile.contact;
  }

  @override
  Widget build(BuildContext context) {
    BasicInfo basicInfo = widget.konnectDetails.basicInfo;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        title: Text('????????????????????? / welcome'),
        actions: <Widget>[
          getCart(),
          IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () {
                Share.share(AppConstants.SHARE_APP);
              }),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              height: 180,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: getProfile(),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 5),
                      child: Text(getProfileName())),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 30),
                      child: Text(getProfileContact())),
                ],
              ),
            ),
            Divider(),

            ListTile(
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),

              ),
              leading: Icon(Icons.local_activity),
              title: Text('Activity List'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        LinkUserActivityListScreen(id: profile.id),
                  ),
                );
              },
            ),
            Divider(),

            ListTile(
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),

              ),
              leading: Icon(Icons.file_copy),
              title: Text('Expanse Report'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        LinkUserExpanseReportScreen(id: profile.id),
                  ),
                );
              },
            ),
            Divider(),

            ListTile(
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),

              ),
              leading: Icon(Icons.group),
              title: Text('Party Master'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        LinkUserPartyMasterScreen(id: profile.id),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),

              ),
              leading: Icon(Icons.shopping_cart),
              title: Text('Item Master'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProductSearchScreen(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),

              ),
              leading: Icon(Icons.library_books),
              title: Text('Sales Quatation/Purchase Order'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        LinkUserSalesQuatationScreen(id: profile.id),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),

              ),
              leading: Icon(Icons.library_books),
              title: Text('Sales Orders'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        LinkUserSalesOrderScreen(id: profile.id),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),

              ),
              leading: Icon(Icons.account_balance),
              title: Text('Ledger'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        LinkUserLedgerScreen(id: profile.id),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),

              ),
              leading: Icon(Icons.payment),
              title: Text('Payment/Receipt'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        LinkUserPayReceiptScreen(id: profile.id),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),

              ),
              leading: Icon(Icons.monetization_on),
              title: Text('Sales Invoice'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        LinkUserSalesInvoiceScreen(id: profile.id),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),

              ),
              leading: Icon(Icons.description),
              title: Text('Proforma Invoice'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        LinkUserProformaInvoiceScreen(id: profile.id),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),

              ),
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout (Link User)'),
              onTap: () async {
                Navigator.pop(context);
                Logout(context).awesomeDialog(widget.konnectDetails);
              },
            ),
            Divider(),
            SizedBox(height: 50)
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              color: Color.fromARGB(255, 255, 255, 255),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: GFCarousel(
                              height: MediaQuery.of(context).size.height,
                              items: widget.konnectDetails.coverImage
                                  .map((coverImage) {
                                return Image.network(coverImage.image,
                                    fit: BoxFit.cover, width: 1000.0);
                              }).toList(),
                              autoPlay: true,
                              pagination: true,
                              viewportFraction: 1.0,
                              onPageChanged: (index) {
                                setState(() {
                                  index;
                                });
                              }),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 5),
                          child: Text(
                            basicInfo.organisation,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 12),
                          child: Text(basicInfo.categoryOfBusiness),
                        ),
                      ]),
                  Positioned.fill(
                    left: 0.0,
                    bottom: 30.0,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: FadeInImage.assetNetwork(
                          image: basicInfo.konnectLogo,
                          placeholder: 'images/ic_konnect.png',
                          height: 80,
                          width: 60,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 3, color: Colors.white),
          Expanded(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AboutScreen(widget.konnectDetails),
                          ),
                        );
                      },
                      asset: 'images/home/ic_about.png',
                      label: 'About'),
                  VerticalDivider(color: Colors.black87),
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LocationScreen(widget.konnectDetails)),
                        );
                      },
                      asset: 'images/home/ic_address.png',
                      label: 'Address'),
                  VerticalDivider(color: Colors.black87),
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ContactScreen(widget.konnectDetails)),
                        );
                      },
                      asset: 'images/home/ic_contact.png',
                      label: 'Contact'),
                ],
              ),
            ),
          ),
          Divider(height: 3, color: Colors.black87),
          Expanded(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => CategoryScreen(),
                          ),
                        ).then(
                          (value) => onBackPressed(),
                        );
                      },
                      asset: 'images/home/ic_store.png',
                      label: 'Store'),
                  VerticalDivider(color: Colors.black87),
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  OffersScreen(widget.konnectDetails)),
                        );
                      },
                      asset: 'images/home/ic_offers.png',
                      label: 'Offers'),
                  VerticalDivider(color: Colors.black87),
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  GalleryScreen(widget.konnectDetails)),
                        );
                      },
                      asset: 'images/home/ic_gallery.png',
                      label: 'Gallery'),
                ],
              ),
            ),
          ),
          Divider(height: 3, color: Colors.black87),
          Expanded(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BankingScreen(widget.konnectDetails)),
                        );
                      },
                      asset: 'images/home/ic_banking.png',
                      label: 'Banking'),
                  VerticalDivider(color: Colors.black87),
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RegisterScreen(widget.konnectDetails)),
                        );
                      },
                      asset: 'images/home/ic_registration.png',
                      label: 'Registration'),
                  VerticalDivider(color: Colors.black87),
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SupportScreen(widget.konnectDetails)),
                        );
                      },
                      asset: 'images/home/ic_support.png',
                      label: 'Support'),
                ],
              ),
            ),
          ),
          GFButton(
            size: 50,
            fullWidthButton: true,
            type: GFButtonType.solid,
            color: Colors.blue.shade300,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => InAppWebViewPage(),
                ),
              );
            },
            icon: Icon(
              Icons.video_call,
              color: Colors.white,
            ),
            text: '',
          ),
        ],
      ),
    );
  }
}
