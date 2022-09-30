import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tailor_app/account_creations/login_provider.dart';
import 'package:tailor_app/screens/customer_detail_page.dart';
import 'package:tailor_app/screens/customer_details/customer_personal_details.dart';
import 'package:tailor_app/screens/model_add_customer.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);
  static bool? selected;
  static Map<int, bool> selectedFlags = {};
  static bool selectedMode = false;
  static bool check = true;
  static bool isSearching = false;
  static List dataList = [];
  static bool? editing = false;
  static Map<String, dynamic>? map = {};
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final String imgUrl = 'assets/images/avatar_image.jpg';
  var customerList = [];
  bool check = true;
  static String searchedText = '';
  late User? user;
  late Stream<QuerySnapshot> userStream;
  late TextEditingController _searchController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;
    userStream = FirebaseFirestore.instance.collection(user!.uid).snapshots();
    getData();
    _searchController = TextEditingController();
    _searchController.addListener(() => setState(() {}));
    _firstNameController = TextEditingController(
        text: DashBoard.editing!
            ? DashBoard.map![ModelAddCustomer.keyFirstName]
            : '');
    _lastNameController = TextEditingController(
        text: DashBoard.editing!
            ? DashBoard.map![ModelAddCustomer.keyLastName]
            : '');

    _phoneController = TextEditingController(
        text: DashBoard.editing!
            ? DashBoard.map![ModelAddCustomer.keyPhoneNumber]
            : '');
    _addressController = TextEditingController(
        text: DashBoard.editing!
            ? DashBoard.map![ModelAddCustomer.keyAddress]
            : '');
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build is called');
    // print(
    //     '//////////////${DashBoard.dataList.length}/////////////////data List = ////${DashBoard.dataList}//////////////////');
    // print(
    //     '////////////${customerList.length}///////////////////Customer List = ////$customerList//////////////////');
    //
    DashBoard.selectedMode = DashBoard.selectedFlags.containsValue(true);
    // print(
    //   '/////////////// DashBoard.selectedMode = ${DashBoard.selectedMode}/////////');
    // print('${user?.email}//////////////////////////////email//////');
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      drawer: Drawer(
          semanticLabel: 'Details',
          backgroundColor: Colors.deepPurpleAccent,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                  currentAccountPictureSize: const Size(90, 90),
                  accountName: Text('${user!.displayName}'),
                  accountEmail: Text('${user!.email}'),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.deepOrangeAccent,
                      Colors.yellow,
                      //Colors.indigo
                    ]),
                    color: Colors.deepPurple,
                  ),
                  arrowColor: Colors.pink,
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.amber,
                    backgroundImage: NetworkImage('${user!.photoURL}'),
                  )),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(imgUrl),
                ),
                title: const Text('Title'),
                textColor: Colors.white,
                trailing: const Text('Trailing'),
                tileColor: Colors.lightGreen.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ListTile(
                  textColor: Colors.white,
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                  title: const Text('Title'),
                  trailing: const Text('Trailing'),
                  tileColor: Colors.lightGreen.shade300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                  title: const Text('Title'),
                  textColor: Colors.white,
                  trailing: const Text('Trailing'),
                  tileColor: Colors.lightGreen.shade300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ListTile(
                  textColor: Colors.white,
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                  title: const Text('Logout'),
                  trailing: const Text('Logout'),
                  tileColor: Colors.lightGreen.shade300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onTap: () async {
                    final status = await LoginProvider.logout(context: context);
                    await LoginProvider.customSnackBar(
                        status: status, context: context);
                  },
                ),
              ),
            ],
          )),
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: DashBoard.selectedMode ? 100 : 56,
        leading: DashBoard.selectedMode
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 25,
                    child: IconButton(
                        iconSize: 25,
                        onPressed: () {
                          setState(() {
                            if (DashBoard.selectedFlags.containsValue(false)) {
                              customerList = [];
                              customerList = DashBoard.dataList;
                              print(
                                  '/////////////${customerList.length}///////customerList = ${customerList}/////////////////');
                              DashBoard.selectedFlags
                                  .updateAll((key, value) => true);
                            } else {
                              print(
                                  '///////${customerList.length}////customer list before making empty///////// = ${customerList}/////////////////');
                              customerList = [];
                              print(
                                  '/////${customerList.length}//////customer list after making empty/////////dataList = ${customerList}/////${customerList.length}////////////');

                              DashBoard.selectedFlags
                                  .updateAll((key, value) => false);
                            }
                          });
                        },
                        icon: DashBoard.selectedFlags.containsValue(false)
                            ? const Icon(Icons.check_box_outline_blank_rounded)
                            : const Icon(Icons.check_box_rounded)),
                  ),
                  Text('${customerList.length}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              )
            : Builder(
                builder: (context) => SizedBox(
                  width: 50,
                  child: IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(Icons.menu)),
                ),
              ),
        actions: <Widget>[
          Padding(
              padding:
                  EdgeInsets.only(right: DashBoard.selectedMode ? 5.0 : 18.0),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    DashBoard.isSearching = !DashBoard.isSearching;
                    searchedText = '';
                  });
                },
                icon: DashBoard.isSearching
                    ? const Icon(Icons.cancel_rounded, size: 25)
                    : const Icon(Icons.search),
              )),
          DashBoard.selectedMode
              ? Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: IconButton(
                      iconSize: 25,
                      onPressed: () {
                        setState(() {
                          deleteCustomers();
                        });
                      },
                      icon: const Icon(Icons.delete)),
                )
              : const Text(''),
        ],
        title: DashBoard.isSearching
            ? searchTextField()
            : appBarTitle('Tailor Book'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.green,
            ));
          } else if (snapshot.data!.size == 0) {
            return const Center(
              child: Text(
                'No Customer Added Yet',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              DashBoard.selectedFlags[index] =
                  DashBoard.selectedFlags[index] ?? false;
              DashBoard.selected = DashBoard.selectedFlags[index];
              if (searchedText.isEmpty) {
                return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(
                        data[ModelAddCustomer.keyFirstName] +
                            ' ' +
                            data[ModelAddCustomer.keyLastName],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'RobotoMono'),
                      ),
                      subtitle: Text(
                        data[ModelAddCustomer.keyPhoneNumber] ?? '',
                        style: const TextStyle(color: Colors.black),
                      ),
                      leading: DashBoard.selectedMode
                          ? InkWell(
                              child: DashBoard.selectedFlags[index]!
                                  ? const Icon(
                                      Icons.check_box,
                                      color: Colors.green,
                                    )
                                  : const Icon(Icons.check_box_outline_blank))
                          : null,
                      trailing: CircleAvatar(
                        child: Text('${DashBoard.selectedFlags[index]}'),
                      ),
                      selected: DashBoard.selectedFlags[index]!,
                      selectedTileColor: Colors.grey.shade300,
                      selectedColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: DashBoard.selectedMode
                                ? Colors.red
                                : Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tileColor: Colors.white,
                      onLongPress: () {
                        DashBoard.selectedMode = true;
                        if (DashBoard.selectedMode) {
                          setState(() {
                            DashBoard.selectedFlags[index] =
                                !DashBoard.selectedFlags[index]!;
                            customerList.add(data);
                          });
                        }
                      },
                      onTap: () {
                        if (DashBoard.selectedMode) {
                          setState(() {
                            DashBoard.selectedFlags[index] =
                                !DashBoard.selectedFlags[index]!;
                            if (DashBoard.selectedFlags[index]!) {
                              customerList.add(data);
                            } else {
                              customerList.removeWhere((element) =>
                                  element['phoneNumber']
                                      .toString()
                                      .contains(data['phoneNumber']));
                            }
                          });
                        } else {
                          print(
                              '//////////////////////////////// CustomerDetailPage////////////////////////');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerDetailPage(map: data)));
                          print(
                              '////////////////fullName////////// ${data['fullName']}/////////////////////////');
                          print(
                              '/////////////////phoneNumber///////// ${data['phoneNumber']}/////////////////////////');
                          print(
                              '/////////////////address///////// ${data['address']}/////////////////////////');
                          print(
                              '////////////////wrist////////// ${data['wrist']}/////////////////////////');
                          print(
                              '/////////////armLength///////////// ${data['armLength']}/////////////////////////');
                          print(
                              '////////////////biceps////////// ${data['biceps']}/////////////////////////');
                          print(
                              '/////////////calf///////////// ${data['calf']}/////////////////////////');
                          print(
                              '////////////collar////////////// ${data['collar']}/////////////////////////');
                          print(
                              '/////////////chest///////////// ${data['chest']}/////////////////////////');
                          print(
                              '///////////////inseam/////////// ${data['inseam']}/////////////////////////');
                          print(
                              '/////////////length///////////// ${data['length']}/////////////////////////');
                          print(
                              '/////////////thigh///////////// ${data['thigh']}/////////////////////////');
                          print(
                              '//////////////waist//////////// ${data['waist']}/////////////////////////');
                          print(
                              '/////////////shoulder///////////// ${data['shoulder']}/////////////////////////');
                        }
                      },
                    ));
              } else if (data['firstName']
                      .toString()
                      .toLowerCase()
                      .contains(searchedText.toLowerCase()) ||
                  data['lastName']
                      .toString()
                      .toLowerCase()
                      .contains(searchedText.toLowerCase()) ||
                  data['phoneNumber']
                      .toString()
                      .toLowerCase()
                      .contains(searchedText.toLowerCase())) {
                return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(
                        '${data[ModelAddCustomer.keyFirstName]} '
                        ' ${data[ModelAddCustomer.keyLastName]}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'RobotoMono'),
                      ),
                      subtitle: Text(
                        data[ModelAddCustomer.keyPhoneNumber] ?? '',
                        style: const TextStyle(color: Colors.black),
                      ),
                      leading: DashBoard.selectedMode
                          ? InkWell(
                              child: DashBoard.selectedFlags[index]!
                                  ? const Icon(
                                      Icons.check_box,
                                      color: Colors.green,
                                    )
                                  : const Icon(Icons.check_box_outline_blank))
                          : null,
                      trailing: CircleAvatar(
                        child: Text('${DashBoard.selectedFlags[index]}'),
                      ),
                      selected: DashBoard.selectedFlags[index]!,
                      selectedTileColor: Colors.grey.shade300,
                      selectedColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: DashBoard.selectedMode
                                ? Colors.red
                                : Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tileColor: Colors.white,
                      onLongPress: () {
                        DashBoard.selectedMode = true;
                        if (DashBoard.selectedMode) {
                          setState(() {
                            DashBoard.selectedFlags[index] =
                                !DashBoard.selectedFlags[index]!;
                            customerList.add(data);
                          });
                        }
                      },
                      onTap: () {
                        if (DashBoard.selectedMode) {
                          setState(() {
                            DashBoard.selectedFlags[index] =
                                !DashBoard.selectedFlags[index]!;
                            if (DashBoard.selectedFlags[index]!) {
                              customerList.add(data);
                            } else {
                              customerList.removeWhere((element) =>
                                  element['phoneNumber']
                                      .toString()
                                      .contains(data['phoneNumber']));
                            }
                          });
                        } else {
                          print(
                              '//////////////////////////////// CustomerDetailPage////////////////////////');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerDetailPage(map: data)
                                  //     CustomerDetailPage(
                                  //   fullName: data['fullName'],
                                  //   phoneNumber: data['phoneNumber'],
                                  //   address: data['address'],
                                  //   wrist: data['wrist'],
                                  //   armLength: data['armLength'],
                                  //   biceps: data['biceps'],
                                  //   calf: data['calf'],
                                  //   collar: data['collar'],
                                  //   chest: data['chest'],
                                  //   inseam: data['inseam'],
                                  //   length: data['length'],
                                  //   thigh: data['thigh'],
                                  //   waist: data['waist'],
                                  //   shoulder: data['shoulder'],
                                  //   title: 'Customer Info',
                                  // ),
                                  ));
                          print(
                              '////////////////fullName////////// ${data['fullName']}/////////////////////////');
                          print(
                              '/////////////////phoneNumber///////// ${data['phoneNumber']}/////////////////////////');
                          print(
                              '/////////////////address///////// ${data['address']}/////////////////////////');
                          print(
                              '////////////////wrist////////// ${data['wrist']}/////////////////////////');
                          print(
                              '/////////////armLength///////////// ${data['armLength']}/////////////////////////');
                          print(
                              '////////////////biceps////////// ${data['biceps']}/////////////////////////');
                          print(
                              '/////////////calf///////////// ${data['calf']}/////////////////////////');
                          print(
                              '////////////collar////////////// ${data['collar']}/////////////////////////');
                          print(
                              '/////////////chest///////////// ${data['chest']}/////////////////////////');
                          print(
                              '///////////////inseam/////////// ${data['inseam']}/////////////////////////');
                          print(
                              '/////////////length///////////// ${data['length']}/////////////////////////');
                          print(
                              '/////////////thigh///////////// ${data['thigh']}/////////////////////////');
                          print(
                              '//////////////waist//////////// ${data['waist']}/////////////////////////');
                          print(
                              '/////////////shoulder///////////// ${data['shoulder']}/////////////////////////');
                        }
                      },
                    ));
              }
              return Container();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('btn called');
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isDismissible: false,
              enableDrag: false,
              isScrollControlled: true,
              builder: (context) => const CustomerPersonalDetails());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> getData() async {
    QuerySnapshot customer =
        await FirebaseFirestore.instance.collection(user!.uid).get();
    DashBoard.dataList = [];
    for (int i = 0; i < customer.docs.length; i++) {
      DashBoard.dataList.add(customer.docs[i].data());
    }
    check = false;
  }

  deleteCustomers() {
    for (var data in customerList) {
      FirebaseFirestore.instance
          .collection(user!.uid)
          .doc('${data['phoneNumber']}')
          .delete();
      DashBoard.selectedFlags.removeWhere((key, value) => value == true);
    }
    AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      headerAnimationLoop: false,
      dialogType: DialogType.SUCCES,
      showCloseIcon: true,
      autoHide: const Duration(seconds: 2),
      title: 'Deleted',
      // desc: 'Added ${_nameController.text}',
      btnOkOnPress: () {
        debugPrint('OnClick');
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dismiss from callback $type');
      },
    ).show();
    customerList = [];
    check = true;
  }

  Widget appBarTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget searchTextField() {
    return Container(
      height: 35,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(32)),
      child: TextFormField(
        onChanged: (value) => setState(() {
          searchedText = value;
        }),
        cursorColor: Colors.black,
        controller: _searchController,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.emailAddress,
        autofocus: true,
        decoration: InputDecoration(
          hintStyle: const TextStyle(fontSize: 16),
          hintText: 'name or phone',
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    searchedText = '';
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.black,
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.only(top: 3, left: 15, right: 0.0, bottom: 15),
        ),
      ),
    );
  }
}
