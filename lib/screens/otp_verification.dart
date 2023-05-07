// ignore_for_file: unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:userapp/screens/user_info_screen.dart';
import 'dart:async';

import '../provider/auth_provider.dart';
import '../utils/utils.dart';
import '../widget/custom_button.dart';
import 'home_screen.dart';


class Verificatoin extends StatefulWidget {
  final String verificationId;
  const Verificatoin({Key? key, required this.verificationId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VerificatoinState createState() => _VerificatoinState();
}

class _VerificatoinState extends State<Verificatoin> {
  String? otpCode;
  TextEditingController countryController = TextEditingController();
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;

  String _code = '';

  late Timer _timer;
  int _start = 60;
  int _currentIndex = 0;

  void resend() {
    setState(() {
      _isResendAgain = true;
    });

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  verify() {
    setState(() {
      _isLoading = true;
    });

    const oneSec = Duration(milliseconds: 2000);
    _timer = Timer.periodic(oneSec, (timer) {
      try {
        setState(() {
          _isLoading = false;
          _isVerified = true;
        });
        timer.cancel(); // stop the timer when verification is complete
      } catch (e) {
        print('Error during verification: $e');
        setState(() {
          _isLoading = false;
          _isVerified = false;
        });
        timer.cancel(); // stop the timer in case of errors
      }
    });
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        _currentIndex++;

        if (_currentIndex == 3) _currentIndex = 0;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 300,
                child: Stack(children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Lottie.asset('assets/otp verification.json')),
                ]),
              ),
              // const SizedBox(
              //   height: 30,
              // ),
              const SizedBox(
                  child: Text(
                    "Verification",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                child: Text(
                  "Please enter the 6 digit code sent to your phone number",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, color: Colors.grey.shade500, height: 1.5),
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              // Verification Code Input
              Pinput(
                length: 6,
                showCursor: true,
                defaultPinTheme: PinTheme(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onCompleted: (value) {
                  setState(() {
                    otpCode = value;
                  });
                },
              ),

              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't receive the OTP?",
                      style:
                      TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    ),
                    TextButton(
                        onPressed: () {
                          if (_isResendAgain) return;
                          resend();
                          print(otpCode);
                          if (otpCode != null) {
                            verifyOtp(context, otpCode!);
                          } else {
                            showSnackBar(context, "Enter 6-Digit code");
                          }
                        },
                        child: Text(
                          _isResendAgain ? "Try again in $_start" : "Resend",
                          style: const TextStyle(color: Colors.blueAccent),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(

                height: 50,
                width: double.infinity,
                child: CustomButton(
                  text: "Verify code",
                  onPressed: () {
                    // ignore: avoid_print
                    print(otpCode);
                    if (otpCode != null) {
                      verifyOtp(context, otpCode!);
                    } else {
                      showSnackBar(context, "Enter 6-Digit code");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: () {
        // checking whether user exists in the db
        ap.checkExistingUser().then(
              (value) async {
            if (value == true) {
              // user exists in our app
              ap.getDataFromFirestore().then(
                    (value) => ap.saveUserDataToSP().then(
                      (value) => ap.setSignIn().then(
                        (value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                            (route) => false),
                  ),
                ),
              );
            } else {
              // new user
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserInfromationScreen()),
                      (route) => true);
            }
          },
        );
      },
    );
  }
}
