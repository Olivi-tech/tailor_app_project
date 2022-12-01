import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tailor_app/screens/customer_detail_page.dart';
import 'package:tailor_app/screens/customer_details/customer_personal_details.dart';
import 'package:tailor_app/screens/model_classes/model_add_customer.dart';
import 'package:tailor_app/screens/tailor_drawer.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);
  static bool? selected;
  static Map<int, bool> selectedFlags = {};
  static bool selectedMode = false;
  static bool check = true;
  static bool isSearching = false;
  static List dataList = [];
  static List customerList = [];
  static bool? editing = false;
  static Map<String, dynamic>? map = {};
  static Function? delCustomer;
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final String imgUrl = 'assets/images/avatar_image.jpg';
  bool check = true;
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
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DashBoard.selectedMode = DashBoard.selectedFlags.containsValue(true);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      drawer: TailorDrawer.myCustomDrawer(context: context, user: user),
      appBar: PreferredSize(preferredSize: Size(width, 56), child: myAppBar()),
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
                child: CircularProgressIndicator(color: Color(0xD2EA4A26)));
          } else if (snapshot.data!.size == 0) {
            return const Center(
              child: Text(
                'No Customer Added Yet',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xD2EA4A26)),
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
              if (_searchController.text.isEmpty) {
                return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(
                        '${data[ModelAddCustomer.keyFirstName]} '
                        '${data[ModelAddCustomer.keyLastName]}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'RobotoMono'),
                      ),
                      subtitle: Text(
                        data[ModelAddCustomer.keyPhoneNumber],
                        style: const TextStyle(color: Colors.black),
                      ),
                      leading: DashBoard.selectedMode
                          ? DashBoard.selectedFlags[index]!
                              ? const Icon(
                                  Icons.check_box,
                                  color: Colors.green,
                                )
                              : const Icon(Icons.check_box_outline_blank)
                          : null,
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
                            DashBoard.customerList.add(data);
                          });
                        }
                      },
                      onTap: () {
                        if (DashBoard.selectedMode) {
                          setState(() {
                            DashBoard.selectedFlags[index] =
                                !DashBoard.selectedFlags[index]!;
                            if (DashBoard.selectedFlags[index]!) {
                              DashBoard.customerList.add(data);
                            } else {
                              DashBoard.customerList.removeWhere((element) =>
                                  element['phoneNumber']
                                      .toString()
                                      .contains(data['phoneNumber']));
                            }
                          });
                        } else {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: CustomerDetailPage(map: data)));
                        }
                      },
                    ));
              } else if (data['firstName']
                      .toString()
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()) ||
                  data['lastName']
                      .toString()
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()) ||
                  data['phoneNumber']
                      .toString()
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase())) {
                return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(
                        '${data[ModelAddCustomer.keyFirstName]} '
                        '${data[ModelAddCustomer.keyLastName]}',
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
                            DashBoard.customerList.add(data);
                          });
                        }
                      },
                      onTap: () {
                        if (DashBoard.selectedMode) {
                          setState(() {
                            DashBoard.selectedFlags[index] =
                                !DashBoard.selectedFlags[index]!;
                            if (DashBoard.selectedFlags[index]!) {
                              DashBoard.customerList.add(data);
                            } else {
                              DashBoard.customerList.removeWhere((element) =>
                                  element['phoneNumber']
                                      .toString()
                                      .contains(data['phoneNumber']));
                            }
                          });
                        } else {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: CustomerDetailPage(map: data)));
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
          _searchController.clear();
          DashBoard.isSearching = false;
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isDismissible: false,
              enableDrag: false,
              isScrollControlled: true,
              builder: (context) => const CustomerPersonalDetails());
        },
        backgroundColor: const Color(0xD2EA4A26),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget myAppBar() {
    return AppBar(
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
                            DashBoard.customerList = [];
                            DashBoard.customerList = DashBoard.dataList;
                            DashBoard.selectedFlags
                                .updateAll((key, value) => true);
                          } else {
                            DashBoard.customerList = [];
                            DashBoard.selectedFlags
                                .updateAll((key, value) => false);
                          }
                        });
                      },
                      icon: DashBoard.selectedFlags.containsValue(false)
                          ? const Icon(Icons.check_box_outline_blank_rounded)
                          : const Icon(Icons.check_box_rounded)),
                ),
                Text('${DashBoard.customerList.length}',
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
      title: DashBoard.isSearching ? searchBox() : appBarTitle('Tailor Book'),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: DashBoard.selectedMode ? 5.0 : 18.0),
          child: IconButton(
            onPressed: () {
              setState(() {
                DashBoard.isSearching = !DashBoard.isSearching;
                _searchController.clear();
                log('///////////issearching ${DashBoard.isSearching}/////');
              });
            },
            icon: DashBoard.isSearching
                ? const Icon(Icons.cancel_rounded, size: 25)
                : const Icon(Icons.search),
          ),
        ),
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
    );
  }

  Widget appBarTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget searchBox() {
    return Container(
        height: 35,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          // onChanged: (val) {
          //   //print('////val = $val///////');
          // },
          controller: _searchController,
          cursorColor: Colors.black,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: 16, color: Colors.black),
            hintText: 'name or phone',
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      //    searchProvider.searchedText = '';
                      _searchController.clear();
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
        ));
    // }));
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
    for (var data in DashBoard.customerList) {
      FirebaseFirestore.instance
          .collection(user!.uid)
          .doc('${data['phoneNumber']}')
          .delete();
      DashBoard.selectedFlags.removeWhere((key, value) => value == true);
    }
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
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
    DashBoard.customerList = [];
    check = true;
  }
}
