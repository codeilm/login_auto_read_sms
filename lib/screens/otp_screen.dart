import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/network_helper.dart';
import 'package:login/screens/verification_screen.dart';
import 'package:login/widgets/no_internet.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController mobileController = TextEditingController();
  bool showSpinner = false;

  requestOTP() async {
    if (await isConnected()) {
      setState(() {
        showSpinner = true;
      });
      String mobile = mobileController.text.startsWith('+91')
          ? mobileController.text.substring(3)
          : mobileController.text;
      Map<String, dynamic> body = {
        "identity": "mobile",
        "mobile": mobile,
        "mobile_code": "+91",
        "activity": "login"
      };
      http.Response res = await post("/acccount/requestotp", body);
      setState(() {
        showSpinner = false;
      });
      if (res.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VerificationScreen(mobile: mobile);
        }));
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
    final SmsAutoFill _autoFill = SmsAutoFill();
    // This lines display the available mobile numbers
    _autoFill.hint.then((value) {
      mobileController.text = value;
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
                  TextField(
                    textAlign: TextAlign.center,
                    controller: mobileController,
                    decoration:
                        InputDecoration(hintText: 'Enter Mobile Number'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: requestOTP,
                    child: Text('Get OTP'),
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
