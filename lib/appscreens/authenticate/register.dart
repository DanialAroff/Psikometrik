// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:fyp1/shared/appcolors.dart';
import 'package:fyp1/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Daftar Pengguna'),
          backgroundColor: AppColors.primary,
        ),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          left: false,
          right: false,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12),
                  child: const Text(
                    'Daftar Pengguna',
                    style: TextStyle(
                      color: AppColors.text1,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: 'Nunito Sans',
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: TextFormField(
                    validator: (val) {
                      // val.isEmpty ? 'Sila masukkan emel' : null,
                      if (val != null && val.isEmpty) {
                        'Sila masukkan emel';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                      fontFamily: 'Nunito Sans',
                    ),
                    cursorColor: AppColors.cursor,
                    cursorWidth: 1.6,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: AppColors.gray,
                      ),
                      isCollapsed: true,
                      labelText: 'Emel',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: AppColors.primary,
                      )),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: TextFormField(
                    obscureText: true,
                    validator: (val) {
                      if (val != null && val.length < 6) {
                        return 'Sila masukkan kata laluan dengan panjang 6 karakter atau lebih';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                      fontFamily: 'Nunito Sans',
                    ),
                    cursorColor: AppColors.cursor,
                    cursorWidth: 1.6,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.password,
                        size: 20,
                        color: AppColors.gray,
                      ),
                      isCollapsed: true,
                      labelText: 'Kata Laluan',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: AppColors.primary,
                      )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 80,
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        shadowColor: AppColors.primary.withOpacity(0.2),
                      ),
                      child: const Text(
                        'Daftar Pengguna',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(
                                () => error = 'Sila masukkan emel yang sah');
                          } else {
                            print(result.uid);
                          }
                        }
                      },
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      widget.toggleView();
                    },
                    child: const Text(
                      'Log Masuk',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontFamily: 'Nunito Sans',
                      ),
                    )),
                const SizedBox(height: 12),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Nunito Sans',
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
