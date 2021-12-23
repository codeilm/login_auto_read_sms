import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login/network_helper.dart';
import 'package:login/widgets/no_internet.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:sms/sms.dart';
import 'package:http/http.dart' as http;

class VerificationScreen extends StatefulWidget {
  final String mobile;
  VerificationScreen({@required this.mobile});
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  SmsQuery query = SmsQuery();
  String otp = '';
  bool showSpinner = false;

  fetchSMS() async {
    List messages = await query.querySms(start: 0, count: 1);
    String body = messages[0].body;
    if (body.contains('Team Armsprime Media Pvt Ltd') && body.length == 48) {
      setState(() {
        otp = body.substring(0, 6);
      });
    }
  }

  verifyOTP() async {
    if (await isConnected()) {
      setState(() {
        showSpinner = true;
      });
      Map<String, dynamic> body = {
        "identity": "mobile",
        "mobile": widget.mobile,
        "mobile_code": "+91",
        "activity": "login",
        "otp": otp
      };
      http.Response res = await post("/account/login/verifyotp", body);
      setState(() {
        showSpinner = false;
      });
      if (res.statusCode == 200) {
        if (jsonDecode(res.body)["error"]) {
          myAlertDialog(context, 'Incorrect OTP');
        } else {
          Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
        }
      } else {
        myAlertDialog(context, 'Some error occurred');
      }
    } else {
      myAlertDialog(context, 'Please connect to Internet');
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (otp.isEmpty) {
        fetchSMS();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  PinFieldAutoFill(
                    currentCode: otp,
                    onCodeChanged: (code) {
                      if (code.length == 6) {
                        verifyOTP();
                      }
                    },
                    onCodeSubmitted: (code) {
                      if (code.length == 6) {
                        verifyOTP();
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {},
                    child: Text('Verify OTP'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
