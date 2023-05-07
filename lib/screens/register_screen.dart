import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../widget/custom_button.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController phoneController = TextEditingController();
  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  // ignore: prefer_typing_uninitialized_variables
  var verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 25),
                child: Column(
                  children: [
                    Image.network(
                      'https://ouch-cdn2.icons8.com/n9XQxiCMz0_zpnfg9oldMbtSsG7X6NwZi_kLccbLOKw/rs:fit:392:392/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNDMv/MGE2N2YwYzMtMjQw/NC00MTFjLWE2MTct/ZDk5MTNiY2IzNGY0/LnN2Zw.png',
                      // fit: BoxFit.cover,
                      height: 250,
                      width: 250,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Register",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.grey.shade900),
                    ),
                    const Text(
                      "Enter your phone number to continue, we will send you OTP to verifiy.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      cursorColor: Colors.black38,
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(12),
                          child: InkWell(
                            onTap: () {
                              showCountryPicker(
                                countryListTheme: const CountryListThemeData(
                                  bottomSheetHeight: 550,
                                ),
                                context: context,
                                onSelect: (value) => {
                                  setState(() {
                                    selectedCountry = value;
                                  })
                                },
                              );
                            },
                            child: Text(
                              "+ ${selectedCountry.phoneCode}",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomButton(
                          text: "Send OTP", onPressed: () => sendPhoneNumber()),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
  }
// Future<void> sendOTP(String phoneNumber) async {
//   await FirebaseAuth.instance.verifyPhoneNumber(
//     phoneNumber: phoneNumber,
//     verificationCompleted: (PhoneAuthCredential credential) {},
//     verificationFailed: (FirebaseAuthException e) {
//       // handle verification failed
//     },
//     codeSent: (String verificationId, int? resendToken) {
//       // handle code sent
//     },
//     codeAutoRetrievalTimeout: (String verificationId) {},
//     timeout: Duration(seconds: 60),
//   );
// }
}
