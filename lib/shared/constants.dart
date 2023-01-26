import 'package:flutter/material.dart';
import 'package:fyp1/models/item_options.dart';
import 'package:fyp1/models/user.dart';
import 'package:fyp1/services/database.dart';
import 'appcolors.dart';

const String primaryFont = 'Nunito Sans';

final MyUser defaultUser = MyUser(
    uid: '000000',
    email: 'user@mail.com',
    fullName: 'default',
    userRole: 'student');

const Map<String, String> testCodeNames = {
  'IKK': 'inventori_kematangan_kerjaya',
  'ITP': 'inventori_trait_personaliti',
  'IMK': 'inventori_minat_kerjaya'
};

const List<String> personalityTraits = [
  'autonomi',
  'kreatif',
  'agresif',
  'ekstrovert',
  'pencapaian',
  'kepelbagaian',
  'intelektual',
  'kepimpinan',
  'struktur',
  'resilien',
  'menolong',
  'analitikal',
  'kritik diri',
  'wawasan',
  'ketelusan'
];

const List<String> personalityTypes = [
  'realistik',
  'investigatif',
  'artistik',
  'sosial',
  'enterprising',
  'konvensional'
];

OptionTheme yesTheme =
    OptionTheme(backgroundColor: AppColors.option, icon: Icons.check);
OptionTheme noTheme =
    OptionTheme(backgroundColor: AppColors.option, icon: Icons.close);

const emailInputDecoration = InputDecoration(
  prefixIcon: Icon(
    Icons.email_outlined,
    color: AppColors.gray,
  ),
  isCollapsed: true,
  labelText: 'Kata Laluan',
  floatingLabelBehavior: FloatingLabelBehavior.never,
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.primary,
    ),
  ),
);
const passwordInputDecoration = InputDecoration(
  prefixIcon: Icon(
    Icons.password_outlined,
    color: AppColors.gray,
  ),
  isCollapsed: true,
  labelText: 'Kata Laluan',
  floatingLabelBehavior: FloatingLabelBehavior.never,
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.primary,
    ),
  ),
);
final searchInputDecoration = InputDecoration(
  isDense: true,
  contentPadding: const EdgeInsets.all(1.0),
  prefixIcon: const Icon(Icons.search, color: Colors.grey),
  prefixIconColor: AppColors.secondary,
  focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(width: 1.0, color: AppColors.secondary.withOpacity(0.75)),
      borderRadius: const BorderRadius.all(Radius.circular(8.0))),
  border: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(8.0))),
  filled: true, // to enable custom fill color
  fillColor: Colors.white,
  hoverColor: Colors.white,
  hintText: 'Carian',
);

Widget searchAutoComplete(
    List<MyUser> userList, Function fieldOnTap, Function fieldOnChange) {
  return Autocomplete<MyUser>(
    fieldViewBuilder:
        (BuildContext context, searchController, focusNode, onFieldSubmitted) {
      return TextFormField(
        controller: searchController,
        focusNode: focusNode,
        decoration: searchInputDecoration,
        cursorColor: AppColors.text2,
        maxLines: 1,
        onTap: () => {fieldOnTap},
        onChanged: (value) => {fieldOnChange},
      );
    },
    optionsBuilder: (TextEditingValue textEditingValue) async {
      if (textEditingValue.text == '') {
        return const Iterable<MyUser>.empty();
      } else {
        userList = await DatabaseService().getUserList();
        // List<String> matches = List.generate(userList.length,
        //     (index) => userList.elementAt(index)['name']);
        List<MyUser> matches = [];
        matches.addAll(userList);
        matches.retainWhere((s) {
          return s.fullName!
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });

        return matches;
      }
    },
    optionsViewBuilder: (BuildContext context,
        AutocompleteOnSelected<MyUser> onSelected,
        Iterable<MyUser> suggestions) {
      return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemBuilder: (context, index) {
          final MyUser user = suggestions.elementAt(index);
          return Material(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    user.fullName!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text('${user.userRole}'),
                  onTap: () {
                    onSelected(user);
                  },
                ),
                if (index != suggestions.length - 1)
                  Divider(
                    thickness: 1.0,
                    color: Colors.grey.withOpacity(0.3),
                    height: 1.0,
                  ),
              ],
            ),
          );
        },
        itemCount: suggestions.length,
      );
    },
    // displayStringForOption: (MyUser suggestion) =>
    //     suggestion.fullName!,
  );
}
