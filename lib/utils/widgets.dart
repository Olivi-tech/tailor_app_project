import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonWidgets {
  static Widget customBtn({
    bool? isLoading = false,
    required String name,
    double? fontSize = 18.0,
    double? width = 40,
    FontWeight fontWeight = FontWeight.bold,
    Gradient? btnBackGroundGradientColor = const LinearGradient(colors: [
      Colors.deepOrangeAccent,
      Colors.yellow,
    ]),
    Color? btnBackGroundColor = const Color(0xD2EA4A26),
    Color? btnTextColor = Colors.white,
    double? height = 40.0,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(5.0),
            backgroundColor: MaterialStateProperty.all(btnBackGroundColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0))),
            foregroundColor: MaterialStateProperty.all(btnTextColor)),
        child: FittedBox(
          child: Text(name,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
              )),
        ),
      ),
    );
  }

  static Widget customTextFormField({
    required String? hintText,
    String? Function(String?)? validator,
    Icon? prefixIcon,
    TextAlign textAlign = TextAlign.start,
    List<TextInputFormatter>? inputFormatters,
    String? initialValue,
    Widget? suffixWidget,
    TextEditingController? controller,
    IconButton? suffixIcon,
    BoxConstraints? boxConstraints =
        const BoxConstraints(maxHeight: 50, minHeight: 50),
    int? maxLength,
    TextInputType? textInputType,
    TextStyle? hintStyle = const TextStyle(color: Colors.black),
    bool obscureText = false,
    void Function()? onTap,
  }) {
    return Card(
      elevation: 1,
      color: Colors.white,
      // borderOnForeground: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: TextFormField(
        keyboardType: textInputType,
        initialValue: initialValue,
        textAlign: textAlign,
        onTap: onTap,
        inputFormatters: inputFormatters,
        validator: validator,
        controller: controller,
        maxLength: maxLength,
        obscureText: obscureText,
        decoration: InputDecoration(
          constraints: boxConstraints,
          suffix: suffixWidget,
          hintText: hintText,
          contentPadding: const EdgeInsets.only(left: 20, top: 15),
          prefixIcon: prefixIcon,
          hintStyle: hintStyle,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  static Widget customMeasurementTile(
      {required String stringAssetImage,
      required String title,
      required String initialValue,
      required List list,
      required void Function(String?)? onChanged,
      String? Function(String?)? validator,
      required TextEditingController controller}) {
    return ListTile(
      tileColor: Colors.black26,
      contentPadding: const EdgeInsets.only(left: 0.0, right: 3),
      leading: CircleAvatar(
        backgroundColor: const Color(0xD2EA4A26),
        backgroundImage: AssetImage(stringAssetImage),
        radius: 27.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.black45),
      ),
      title: Text(
        title,
        // style: TextStyle(color: Colors.redAccent),
      ),
      trailing: SizedBox(
        width: 90,
        height: 50,
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              hint: Text(
                initialValue,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black),
              ),
              iconSize: 30,
              items: list.map<DropdownMenuItem<String>>((dynamic value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: initialValue,
              isExpanded: true,
              onChanged: onChanged),
        ),
      ),
    );
  }

  static Widget addCustomerDetails(
      {required BuildContext context,
      required List<String> list,
      required String stringAssetImg,
      required String name,
      String btnName = 'Next',
      required void Function(String?)? onPressed,
      required void Function()? nextOnPressed,
      required String? value,
      BoxFit? boxFit = BoxFit.cover}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        color: Colors.teal.withOpacity(0.5),
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Image(image: AssetImage(stringAssetImg), fit: boxFit),
            Padding(
                padding: EdgeInsets.only(top: height * 0.85),
                child: Column(
                  //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: width * 0.5,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      height: height <= 700 ? height * 0.063 : height * 0.05,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text(
                            name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          iconSize: 30,
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: value,
                          isExpanded: true,
                          onChanged: onPressed,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    CommonWidgets.customBtn(
                      width: width * 0.5,
                      height: height <= 700 ? height * 0.063 : height * 0.05,
                      btnTextColor: Colors.black,
                      btnBackGroundColor: Colors.white,
                      name: btnName,
                      fontSize: 15,
                      onPressed: nextOnPressed,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  static List<String> generateList(int length, int intStartFrom) {
    List<String> finalList = [];
    for (int index = 0; index < length; index++) {
      for (int loopIndex = 0; loopIndex < 4; loopIndex++) {
        switch (loopIndex) {
          case 0:
            finalList.add('${index + intStartFrom}"');
            break;
          case 1:
            finalList.add('${index + intStartFrom} 1/4"');
            break;
          case 2:
            finalList.add('${index + intStartFrom} 1/2"');
            break;
          case 3:
            finalList.add('${index + intStartFrom} 3/4"');
        }
      }
    }
    return finalList;
  }

  static Widget searchBox({required TextEditingController searchController}) {
    return Container(
        height: 35,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          controller: searchController,
          cursorColor: Colors.black,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: 16, color: Colors.black),
            hintText: 'name or phone',
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      searchController.clear();
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
  }
}
