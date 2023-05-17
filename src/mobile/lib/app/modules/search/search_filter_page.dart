import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchFilterPage extends StatefulWidget {
  final String title;
  const SearchFilterPage({Key? key, this.title = 'CartFilterPage'}) : super(key: key);
  @override
  SearchFilterPageState createState() => SearchFilterPageState();
}

class SearchFilterPageState extends State<SearchFilterPage> {
  SearchFilterPageState() : super();
  int? _selectedName = 0;
  int? _selectedRating = 5;
  int? _selectedPrice = 7;
  int? _selectedDiscount = 10;
  bool? _inStock = true;
  bool? _inOutOfStock = false;
  bool? _isGassured = true;
  bool? _includeAll = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Options"),
          leading: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Align(
              alignment: Alignment.center,
              child: Icon(FontAwesomeIcons.windowClose),
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(MdiIcons.syncIcon)),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.0, top: 10),
                    child: Text(
                      'Sort by name',
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      value: 1,
                      groupValue: _selectedName,
                      onChanged: (dynamic val) {
                        _selectedName = val;
                        setState(() {});
                      },
                    ),
                    Text(
                      "A a Z",
                      style: _selectedName == 1
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Radio(
                          value: 2,
                          groupValue: _selectedName,
                          onChanged: (dynamic val) {
                            _selectedName = val;
                            setState(() {});
                          }),
                    ),
                    Text(
                      "Z a A",
                      style: _selectedName == 2
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                  ],
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 10),
                    child: Text(
                      'Sort by rating',
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      value: 3,
                      groupValue: _selectedRating,
                      onChanged: (dynamic val) {
                        _selectedRating = val;
                        setState(() {});
                      },
                    ),
                    Text(
                      "1 - 2 Stars",
                      style: _selectedRating == 3
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Radio(
                          value: 4,
                          groupValue: _selectedRating,
                          onChanged: (dynamic val) {
                            _selectedRating = val;
                            setState(() {});
                          }),
                    ),
                    Text(
                      "2 - 3 Stars",
                      style: _selectedRating == 4
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                        value: 5,
                        groupValue: _selectedRating,
                        onChanged: (dynamic val) {
                          _selectedRating = val;
                          setState(() {});
                        }),
                    Text(
                      "3 - 4 Stars",
                      style: _selectedRating == 5
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Radio(
                          value: 6,
                          groupValue: _selectedRating,
                          onChanged: (dynamic val) {
                            _selectedRating = val;
                            setState(() {});
                          }),
                    ),
                    Text(
                      "2 - 3 Stars",
                      style: _selectedRating == 6
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                  ],
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      'Sort By Price',
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      value: 7,
                      groupValue: _selectedPrice,
                      onChanged: (dynamic val) {
                        _selectedPrice = val;
                        setState(() {});
                      },
                    ),
                    Text(
                      "Low to high",
                      style: _selectedPrice == 7
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Radio(
                          value: 8,
                          groupValue: _selectedPrice,
                          onChanged: (dynamic val) {
                            _selectedPrice = val;
                            setState(() {});
                          }),
                    ),
                    Text(
                      "High to low",
                      style: _selectedPrice == 8
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                  ],
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      'Sort By Discounts}',
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      value: 9,
                      groupValue: _selectedDiscount,
                      onChanged: (dynamic val) {
                        _selectedDiscount = val;
                        setState(() {});
                      },
                    ),
                    Text(
                      "10 - 25%",
                      style: _selectedDiscount == 9
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Radio(
                          value: 10,
                          groupValue: _selectedDiscount,
                          onChanged: (dynamic val) {
                            _selectedDiscount = val;
                            setState(() {});
                          }),
                    ),
                    Text(
                      "25 - 50%",
                      style: _selectedDiscount == 10
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      value: 11,
                      groupValue: _selectedDiscount,
                      onChanged: (dynamic val) {
                        _selectedDiscount = val;
                        setState(() {});
                      },
                    ),
                    Text(
                      "50 - 70%",
                      style: _selectedDiscount == 11
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Radio(
                          value: 12,
                          groupValue: _selectedDiscount,
                          onChanged: (dynamic val) {
                            _selectedDiscount = val;
                            setState(() {});
                          }),
                    ),
                    Text(
                      "70% above",
                      style: _selectedDiscount == 12
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                  ],
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      'Sort By Availability',
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: _inStock,
                        onChanged: (val) {
                          _inStock = val;
                          setState(() {});
                        }),
                    Text(
                      "In Stock",
                      style: _inStock!
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                    Checkbox(
                        value: _inOutOfStock,
                        onChanged: (val) {
                          _inOutOfStock = val;
                          setState(() {});
                        }),
                    Text(
                      "Out of Stock",
                      style: _inOutOfStock!
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                  ],
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      'Sort By Gmart Assurance',
                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: _isGassured,
                        onChanged: (val) {
                          _isGassured = val;
                          setState(() {});
                        }),
                    Text(
                      "G - Assured",
                      style: _isGassured!
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                    Checkbox(
                        value: _includeAll,
                        onChanged: (val) {
                          _includeAll = val;
                          setState(() {});
                        }),
                    Text(
                      "Include all",
                      style: _includeAll!
                          ? Theme.of(context).primaryTextTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PoppinsMedium',
                                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                              )
                          : Theme.of(context).primaryTextTheme.displayMedium,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                        stops: const [0, .90],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColor])),
                margin: const EdgeInsets.all(15.0),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Apply Filter (2015 Products Found)')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
