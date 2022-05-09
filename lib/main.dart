

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form',
      debugShowCheckedModeBanner: false,
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameTEC = TextEditingController();
  final TextEditingController _messageTEC = TextEditingController();
  final TextEditingController _emailTEC = TextEditingController();
  final TextEditingController _phoneNoTEC = TextEditingController();
  bool resp = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.blue,
        centerTitle: false,
       // leadingWidth: 25,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(100), bottomLeft: Radius.circular(10)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
               padding: const EdgeInsets.only(right: 250),
                child: Text("Send Email" , style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),)

                ),
              SizedBox(height:20,)
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height:20),
                    _buildName(),
                    SizedBox(height: 10),
                    _buildPhoneNumber(),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      SizedBox(height: 10),
                      _buildEmail(),
                      SizedBox(height: 10),
                      _buildMessage(),
                      SizedBox(height: 40,),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          onSurface: Colors.grey.shade700,
                          //primary: Colors.grey,
                         padding: EdgeInsets.symmetric(horizontal: 50 , vertical: 16),
                          minimumSize: Size(100 , 40),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold , color: Colors.white),              ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                                sendEmail() ;
                                SnackBar snackbar = SnackBar(
                                content: Text('Submitting the form'),
                                backgroundColor: Colors.green,);
                                ScaffoldMessenger.of(context).showSnackBar(
                                snackbar);
                                }
                            else{
                              SnackBar errorsnackbar = SnackBar(content: Text('Error in submitting the form'), backgroundColor: Colors.red,);
                              ScaffoldMessenger.of(context).showSnackBar(errorsnackbar);
                            }
                          },
                      ),

                    ],
              ),
            ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildName() {
    return Container(
      child: TextFormField(
        controller: _nameTEC,
        decoration: InputDecoration(

            prefixIcon: Icon(Icons.person),
            labelText: "Enter your name",
            hintText: 'First Name *', hintStyle: TextStyle(fontSize: 15)),
        style: TextStyle(fontSize: 14),
        validator: ( value) {
          if (value!.isEmpty) {
            return 'Name is Required';
          }
          if (!RegExp( r'^[a-z A-Z]').hasMatch(value)) {
            return 'Please enter a valid Name';
          }
          return null;
        },
      ),
    );
  }
  Widget _buildPhoneNumber() {
    return IntlPhoneField(
      initialCountryCode: 'IN',
      onChanged: (phone) {
        print(phone.completeNumber);
      },
      controller: _phoneNoTEC,
      decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Enter your number',
          hintText: 'Phone number *' ,  hintStyle: TextStyle(fontSize: 15)),
      keyboardType: TextInputType.phone,
      style: TextStyle(fontSize: 14),
      validator: (value) {
          if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        return null;
      },

      );
  }

  Widget _buildEmail() {
    return TextFormField(
      controller: _emailTEC,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          labelText: "Enter your Email Id",
          hintText: 'Email Id *',  hintStyle: TextStyle(fontSize: 15)),
      style: TextStyle(fontSize: 14),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
    );
  }
  Widget _buildMessage() {
    return TextFormField(
      controller: _messageTEC,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.message),
          labelText: "Enter a message",
          hintText: 'Message ',  hintStyle: TextStyle(fontSize: 15)),
      style: TextStyle(fontSize: 14),
      validator: ( value) {
        if (value!.isEmpty) {
          return 'Message field is empty';
        }
        return null;
      },
      maxLines: 10,
      minLines: 1,
    );
  }

  Future sendEmail() async {
    final serviceId = 'service_69k2ohi';
    final templateId = 'template_us2i60o';
    final userId = 'pfgtXJeYSKh6LKdq3';

 final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
 final response = await http.post(
     url,
     headers: {
       'origin' : 'http://localhost',
       'Content-Type' : 'application/json'},
     body: json.encode({
       'service_id' : serviceId,
       'template_id' : templateId,
       'user_id' : userId,
       'template_params' : {
         'user_name' : _nameTEC.text,
         'user_email' : _emailTEC.text,
         'phoneNo' : _phoneNoTEC.text,
         'message' : _messageTEC.text,
       }
     }),
 );
 print(response.statusCode);
}

}