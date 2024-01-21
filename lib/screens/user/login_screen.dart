import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sp_sale_ref_app/screens/admin_drawer/admin_drawer_screen.dart';
import 'package:sp_sale_ref_app/screens/sale_ref_drawer/ref_drawer_screen.dart';

import '../../data/login_session.dart';
import '../../models/user.dart';
import '../../widgets/flat_button_widget.dart';
import '../../widgets/form_password_field_widget.dart';
import '../../widgets/form_text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var vehicleNumber;
  var setDefaultMakeVehicle = true, setDefaultMakeModelVehicle = true;

  final userNameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  String userType = '';
  String userName = '';
  String refName = '';
  String refContact = '';

  void getSelectedCustomerType(String data) {
    setState(() {
      vehicleNumber = data;
    });
  }

  Stream<List<User>> getUserDetails() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('user_name', isEqualTo: userNameCtrl.text)
        .where('password', isEqualTo: passwordCtrl.text)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _genUserId() async {
    var variable;
    try {
      variable = await FirebaseFirestore.instance.collection('users').where('user_name', isEqualTo: userNameCtrl.text).where('password', isEqualTo: passwordCtrl.text).get();
      //User.fromJson(querySnapshot.docs.first.data());
    } catch (e) {}
    return variable;
  }

  void getLogging() {
    //var userDetails = getUserDetails();
    var userDetail = _genUserId();
    userDetail.then((value) => {
          value.docs.forEach((element) {
            // getUserType(element.data()., element, refContact, userType)
            var user = element.data();
            User.fromJson(user);
            Logger().i('Object ID : ' + User.fromJson(user).user_name);
            getUserType(
              User.fromJson(user).user_name,
              User.fromJson(user).user_name,
              User.fromJson(user).contact,
              User.fromJson(user).user_type_id,
            );
          })
        });
    /*userDetails.forEach((element) {
      //Logger().i(element.last.user_name);
      getUserType(
        element.last.user_name,
        element.last.user_name,
        element.last.contact,
        element.last.user_type_id,
      );
    });*/

    if (userType == '01') {
      LoginSession.userName = userName;
      LoginSession.refName = refName;
      LoginSession.refContact = refContact;
      LoginSession.userType = 'admin';
      LoginSession.vehicleNum = vehicleNumber;
      Logger().i(userType);
      Navigator.of(context).pushReplacementNamed(AdminDrawerScreen.routeName, arguments: {});
    } else if (userType == '02') {
      LoginSession.userName = userName;
      LoginSession.refName = refName;
      LoginSession.refContact = refContact;
      LoginSession.userType = 'ref';
      LoginSession.vehicleNum = vehicleNumber;
      Logger().i(userType);
      Navigator.of(context).pushReplacementNamed(RefDrawerScreen.routeName, arguments: {});
    }
  }

  void getUserType(String userName, String refName, String refContact, String userType) {
    this.userType = userType;
    this.userName = userName;
    this.refName = refName;
    this.refContact = refContact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/user_circle_x4.png'),
            const Text('Sign In', style: TextStyle(fontSize: 24)),
            FormTextFieldWidget(textController: userNameCtrl, hintText: 'User Name', isRequired: false, label: 'User Name', heightFactor: 0.055, widthFactor: 0.9),
            const SizedBox(height: 10),
            FormPasswordFieldWidget(textController: passwordCtrl, hintText: 'Password', isRequired: false, label: 'Password', heightFactor: 0.055, widthFactor: 0.9),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 30, bottom: 5, top: 10),
              child: Row(
                children: const [
                  Text(
                    'Vehicle Number',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(width: 2),
                  true
                      ? Text(
                          "*",
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        )
                      : Text(""),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.black54, width: 0.5),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('vehicles').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  // Safety check to ensure that snapshot contains data
                  // without this safety check, StreamBuilder dirty state warnings will be thrown
                  if (!snapshot.hasData) return Container();
                  // Set this value for default,
                  // setDefault will change if an item was selected
                  // First item from the List will be displayed
                  if (setDefaultMakeVehicle) {
                    vehicleNumber = snapshot.data?.docs[0].get('vehicleNumber');
                    //debugPrint('setDefault make: $customerName');
                  }
                  return DropdownButton(
                    autofocus: true,
                    enableFeedback: true,
                    isExpanded: true,
                    value: vehicleNumber,
                    items: snapshot.data?.docs.map((value) {
                      return DropdownMenuItem(
                        value: value.get('vehicleNumber'),
                        child: Text('${value.get('vehicleNumber')}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      //debugPrint('selected onchange: $value');
                      setState(
                        () {
                          //customerName = value.toString();
                          //debugPrint('make selected: $value');
                          // Selected value will be stored
                          vehicleNumber = value;
                          // Default dropdown value won't be displayed anymore
                          setDefaultMakeVehicle = false;
                          // Set makeModel to true to display first car from list
                          setDefaultMakeModelVehicle = true;
                          //searchProductByCusName(value.toString());
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            FlatButtonWidget(
                title: "Login Now",
                function: () {
                  getLogging();
                },
                heightFactor: 0.07,
                widthFactor: 0.7),
            const SizedBox(height: 20),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don t have an account? ', style: TextStyle(fontSize: 16, color: Colors.grey)),
                GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(SignupScreen.routeName, arguments: () {}),
                    child: const Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.blue))),
              ],
            )*/
          ],
        ),
      ),
    );
  }
}
