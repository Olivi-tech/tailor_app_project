import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_app/provider/search_provider.dart';

class SearchBar extends StatelessWidget {
  SearchBar({super.key});

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print('///////////build is called////////////');
    // var searchProvider = Provider.of<SearchProvider>(context, listen: false);
    return Container(
      height: 35,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(32)),
      child: Consumer<SearchProvider>(
        builder: (BuildContext context, value, Widget? child) {
          print('/////////////rebuilding widget/////////////');
          return TextFormField(
            onChanged: (val) {
              value.searchedText = val;
            },
            controller: searchController,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            decoration: InputDecoration(
              hintStyle: const TextStyle(fontSize: 16, color: Colors.black),
              hintText: 'name or phone',
              suffixIcon: value.searchedText.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        value.clearText();
                        searchController.clear();

                        //   value.clearText(value.searchedText);
                        print(
                            '////btn pressed//value -=/${value.searchedText}////////');
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black,
                        size: 20,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                  top: 3, left: 15, right: 0.0, bottom: 15),
            ),
          );
        },
      ),
    );
  }
}
