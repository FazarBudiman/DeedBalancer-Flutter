// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:DeedBalancer/service/config.dart';
import 'package:DeedBalancer/service/access_token.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? nama;
  String? username;

  @override
  void initState() {
    super.initState();
    loadAccessToken();
  }

  Future<void> loadAccessToken() async {
    String? token = await AccessToken.getToken();

    if (token != null) {
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        nama = decodedToken['nama_pengguna'];
        username = decodedToken['username'];

        setState(() {
          // No need to declare new local variables here
        });
      } catch (e) {
        print('Error decoding JWT: $e');
        // Handle decoding error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        height: 300.0,
        width: 300.0,
        child: (username == null || username!.isEmpty) &&
                (nama == null || nama!.isEmpty)
            ? const CircularProgressIndicator()
            : Card(
                elevation: 4.0,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 50.0,
                        // Replace with your avatar image or use NetworkImage for remote images
                        backgroundImage:
                            AssetImage('images/profile-ilustrasi.png'),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        nama ?? "",
                        style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        username ?? "",
                        style: const TextStyle(color: Colors.black45),
                      ),
                      const SizedBox(height: 16.0),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            elevation: 4,
                            backgroundColor: Colors.white,
                            foregroundColor:
                                const Color.fromARGB(255, 255, 166, 102),
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black26),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)))),
                        onPressed: () {
                          AccessToken.deleteToken().then((value) {
                            if (value) {
                              FormHelper.showSimpleAlertDialog(
                                context,
                                Config.appName,
                                'Logout Berhasil',
                                'OK',
                                () {
                                  Navigator.pop(context);
                                },
                              );
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (route) => false,
                              );
                            } else {
                              FormHelper.showSimpleAlertDialog(
                                context,
                                Config.appName,
                                'Logout Gagal',
                                'OK',
                                () {
                                  Navigator.pop(context);
                                },
                              );
                            }
                          });
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
              ),
      )),
    );
  }
}
