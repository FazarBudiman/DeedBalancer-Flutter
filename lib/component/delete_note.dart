// ignore_for_file: avoid_print

import 'package:DeedBalancer/service/api_service.dart';
import 'package:flutter/material.dart';

class DeleteNote {
  static void showDeleteConfirmationDialog(
      BuildContext context, int idDetailCatatan, String? accessToken) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 255, 177, 122),
                backgroundColor: Colors.white70,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No',
                  style: TextStyle(color: Color.fromARGB(255, 255, 192, 147))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE6D4),
                  foregroundColor: const Color.fromARGB(255, 255, 192, 147)),
              onPressed: () {
                APIService.deleteNote(context, idDetailCatatan, accessToken)
                    .then((response) => {
                          print(response
                              ? "Delete Note Success"
                              : "Delete Note failed"),
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (route) => false)
                        });
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
