import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountSettingsScreen extends StatefulWidget {
  final String userId;

  const AccountSettingsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  String? _firstNameError;
  String? _lastNameError;
  String? _phoneNumberError;
  String? _passwordError;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordController2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      _firstNameController.text = userData['firstName'] ?? '';
      _lastNameController.text = userData['lastName'] ?? '';
      _phoneNumberController.text = userData['phoneNumber'] ?? '';

      setState(() => _isLoading = false);
    } catch (e) {
      print('Błąd przy ładowaniu danych użytkownika: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // Pamiętaj o zwolnieniu kontrolerów, aby uniknąć wycieków pamięci
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _newPasswordController.dispose();
    _newPasswordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia Konta'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.fitWidth,
            repeat: ImageRepeat.repeatY,
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator()):
        SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Imię',
                    labelStyle: TextStyle(color: Colors.red[400]),
                    errorText: _firstNameError,
                    errorStyle: TextStyle(color: Colors.red[400]),
                    focusColor: Colors.white,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Proszę wpisać imię';
                    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return 'Imię może zawierać tylko litery';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Nazwisko',
                    labelStyle: TextStyle(color: Colors.red[400]),
                    errorText: _lastNameError,
                    errorStyle: TextStyle(color: Colors.red[400]),
                    focusColor: Colors.white,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Proszę wpisać nazwisko';
                    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return 'Nazwisko może zawierać tylko litery';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Numer telefonu',
                    labelStyle: TextStyle(color: Colors.red[400]),
                    errorText: _phoneNumberError,
                    errorStyle: TextStyle(color: Colors.red[400]),
                    focusColor: Colors.white,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: _newPasswordController,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Nowe Hasło',
                    labelStyle: TextStyle(color: Colors.red[400]),
                    errorText: _passwordError,
                    errorStyle: TextStyle(color: Colors.red[400]),
                    focusColor: Colors.white,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isNotEmpty && value.length < 6) {
                      return 'Hasło musi mieć co najmniej 6 znaków';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _newPasswordController2,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Powtórz Hasło',
                    labelStyle: TextStyle(color: Colors.red[400]),
                    errorText: _passwordError,
                    errorStyle: TextStyle(color: Colors.red[400]),
                    focusColor: Colors.white,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _updateUserSettings,
                  child: const Text(
                    'Zaktualizuj dane',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateUserSettings() async {
    bool dataUpdated = false;
    bool passwordUpdated = false;

    setState(() {
      _firstNameError = null;
      _lastNameError = null;
      _phoneNumberError = null;
      _passwordError = null;
    });

    Map<String, dynamic> updates = {};

    if (_firstNameController.text.isNotEmpty) {
      updates['firstName'] = _firstNameController.text;
    }

    if (_lastNameController.text.isNotEmpty) {
      updates['lastName'] = _lastNameController.text;
    }

    if (_phoneNumberController.text.isNotEmpty) {
      if (_phoneNumberController.text.length == 9 && RegExp(r'^[0-9]+$').hasMatch(_phoneNumberController.text)) {
        updates['phoneNumber'] = _phoneNumberController.text;
      } else {
        setState(() {
          _phoneNumberError = 'Numer telefonu musi składać się z 9 cyfr';
        });
        return;
      }
    }

    if (updates.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update(updates).then((_) {
        dataUpdated = true;
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wystąpił błąd przy aktualizacji danych')));
      });
    }

    if (_newPasswordController.text.isNotEmpty && _newPasswordController2.text.isNotEmpty) {
      if (_newPasswordController.text == _newPasswordController2.text && _newPasswordController.text.length >= 6) {
        User? user = FirebaseAuth.instance.currentUser;
        await user?.updatePassword(_newPasswordController.text).then((_) {
          passwordUpdated = true;
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wystąpił błąd przy aktualizacji hasła')));
        });
      } else {
        setState(() {
          _passwordError = 'Hasła nie pasują do siebie lub są za krótkie';
        });
        return;
      }
    }

    if (dataUpdated && passwordUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dane i hasło zostały zaktualizowane')));
    } else if (dataUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dane zostały zaktualizowane')));
    } else if (passwordUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hasło zostało zaktualizowane')));
    }
  }
}
