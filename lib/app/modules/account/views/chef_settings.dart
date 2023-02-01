import 'package:bukateria/app/modules/dashboard/views/vendor_dashboard.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/custom_button.dart';
import 'package:bukateria/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';

class ChefSettings extends StatefulWidget {
  ChefSettings({Key? key, this.selectedCountry, this.selectedCurrency})
      : super(key: key);
  String? selectedCountry;
  String? selectedCurrency;

  @override
  State<ChefSettings> createState() => _ChefSettingsState();
}

class _ChefSettingsState extends State<ChefSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chef Settings"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Setup Your Chef Account",
                style: title3,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                child: Container(
                  height: 50,
                  child: TextFormField(
                    onChanged: (val) {},
                    autofocus: true,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Business Name',
                      hintText: 'Business Name',
                      hintStyle: body3.copyWith(color: grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFE5E5E5),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFE5E5E5),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: greyLight.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                child: Container(
                  height: 50,
                  child: TextFormField(
                    onChanged: (val) {},
                    autofocus: true,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Telephone',
                      hintText: 'Telephone',
                      hintStyle: body3.copyWith(color: grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFE5E5E5),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFE5E5E5),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: greyLight.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 20),
                child: TextFormField(
                  onChanged: (val) {},
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    // labelText: 'Description',
                    hintText: 'Enter your pick address',
                    hintStyle: body3.copyWith(color: grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: greyLight.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: greyLight.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: greyLight.withOpacity(0.2),
                  ),
                  maxLines: 3,
                ),
              ),
              GestureDetector(
                onTap: () => {
                  showCurrencyPicker(
                    context: context,
                    showFlag: true,
                    showSearchField: true,
                    showCurrencyName: true,
                    showCurrencyCode: true,
                    onSelect: (Currency currency) {
                      print('Select currency: ${currency.symbol}');
                      setState(() => widget.selectedCurrency = currency.code);
                    },
                    favorite: ['NGN'],
                  )
                },
                child: Container(
                    height: 55,
                    color: greyLight.withOpacity(0.3),
                    child: ListTile(
                      title: Text(
                        "Set currency",
                        style: body3,
                      ),
                      trailing: widget.selectedCurrency == null
                          ? Text("")
                          : Container(
                              child: Text(widget.selectedCurrency.toString())),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => {
                  showCountryPicker(
                    context: context,
                    showPhoneCode:
                        true, // optional. Shows phone code before the country name.
                    onSelect: (Country country) {
                      setState(
                          () => widget.selectedCountry = country.displayName);
                    },
                  )
                },
                child: Container(
                    color: greyLight.withOpacity(0.3),
                    child: ListTile(
                      title: Text(
                        "Select Country",
                        style: body3,
                      ),
                      trailing: widget.selectedCountry == null
                          ? Text("")
                          : Container(
                              child: Text(widget.selectedCountry.toString())),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                  radius: 10,
                  height: 50,
                  onPressed: () => Get.offAll(() => VendorDashboard()),
                  width: Get.width,
                  color: dark,
                  text: "Save Settings")
            ],
          ),
        ),
      ),
    );
  }
}
