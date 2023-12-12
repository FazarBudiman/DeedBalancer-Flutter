// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:DeedBalancer/models/login/login_request_model.dart';
import 'package:DeedBalancer/models/register/register_request_model.dart';
import 'package:DeedBalancer/service/access_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIService {
  static var client = http.Client();

  static Future<bool> register(RegisterRequestModel model) async {
    try {
      final url = Uri.parse(
          'https://api-deed-balancer.netlify.app/.netlify/functions/api/user/register');

      var response = await client.post(
        url,
        body: jsonEncode(model.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during login request: $e');
      return false;
    }
  }

  static Future<bool> login(LoginRequestModel model) async {
    try {
      final url = Uri.parse(
          'https://api-deed-balancer.netlify.app/.netlify/functions/api/user/login');

      var response = await client.post(
        url,
        body: jsonEncode(model.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      // Menguraikan respons JSON
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Menyimpan token ke shared preferences
        await AccessToken.saveToken(responseBody['token']);

        // Menyimpan informasi bahwa user telah login
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during login request: $e');
      return false;
    }
  }

  static Future<bool> addNote(BuildContext context, String? accessToken,
      Map<String, String?> note) async {
    try {
      final url = Uri.parse(
          'https://api-deed-balancer.netlify.app/.netlify/functions/api/notes/detail/');

      final headers = {
        'access-token': '$accessToken',
        'Content-Type': 'application/json'
      };
      final body = jsonEncode(note);

      var response = await client.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error deleting note: $error');
      return false;
    }
  }

  static Future<bool> updateNote(BuildContext context, String? accessToken,
      String? time, String? description, int? idNotes) async {
    try {
      final url = Uri.parse(
          'https://api-deed-balancer.netlify.app/.netlify/functions/api/notes/detail/$idNotes');

      final headers = {
        'access-token': '$accessToken',
        'Content-Type': 'application/json'
      };
      final body = jsonEncode({"waktu": '$time', "deskripsi": '$description'});

      var response = await client.put(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error deleting note: $error');
      return false;
    }
  }

  static Future<bool> deleteNote(
      BuildContext context, int idDetailCatatan, String? accessToken) async {
    try {
      final url = Uri.parse(
          'https://api-deed-balancer.netlify.app/.netlify/functions/api/notes/detail/$idDetailCatatan');

      final headers = {'access-token': '$accessToken'};

      var response = await client.delete(url, headers: headers);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error deleting note: $error');
      return false;
    }
  }
}
