import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tailor_app/screens/model_classes/model_add_customer.dart';
import 'package:tailor_app/utils/widgets.dart';

import 'customer_detail_page.dart';

class CompletedOrders extends StatefulWidget {
  const CompletedOrders({super.key, required this.title});
  final String title;

  @override
  State<CompletedOrders> createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
  late TextEditingController _searchController;
  bool isSearching = false;
  User? user;
  late CollectionReference _userStream;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    _userStream = FirebaseFirestore.instance.collection(user!.uid);
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red.shade100,
        appBar: AppBar(
          title: isSearching
              ? CommonWidgets.searchBox(searchController: _searchController)
              : Text(widget.title),
          actions: [
            IconButton(
                icon: Icon(
                    isSearching ? Icons.clear_sharp : Icons.search_outlined),
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                    _searchController.clear();
                  });
                })
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _userStream
              .where(ModelAddCustomer.keyOrderStatus, isEqualTo: 'Completed')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('SomeThing went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.size == 0) {
              return Center(
                  child: Text(
                'No Order Completed Yet',
                style: TextStyle(color: Colors.black),
              ));
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  if (_searchController.text.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: ListTile(
                        title: Text(
                            '${data[ModelAddCustomer.keyFirstName]}${data[ModelAddCustomer.keyLastName]}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          '${data[ModelAddCustomer.keyPhoneNumber]}',
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Text(
                          'Order Status: ${data[ModelAddCustomer.keyOrderStatus]}',
                          style: TextStyle(color: Colors.black),
                        ),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: CustomerDetailPage(map: data)));
                        },
                      ),
                    );
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: ListTile(
                        title: Text(
                            '${data[ModelAddCustomer.keyFirstName]}${data[ModelAddCustomer.keyLastName]}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          '${data[ModelAddCustomer.keyPhoneNumber]}',
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Text(
                          'Order Status: ${data[ModelAddCustomer.keyOrderStatus]}',
                          style: TextStyle(color: Colors.black),
                        ),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: CustomerDetailPage(map: data)));
                        },
                      ),
                    );
                  }
                  return SizedBox();
                },
              );
            }
            return SizedBox();
          },
        ));
  }
}
