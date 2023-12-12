// ignore_for_file: avoid_print

import 'package:DeedBalancer/component/add_note.dart';
import 'package:DeedBalancer/component/delete_note.dart';
import 'package:DeedBalancer/component/edit_note.dart';
import 'package:DeedBalancer/service/access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotesScreen extends StatefulWidget {
  const NotesScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  DateTime? selectedDate = DateTime.now();
  List<dynamic> positiveActivities = [];
  List<dynamic> negativeActivities = [];
  String? accessToken;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadAccessToken();
  }

  Future<void> loadAccessToken() async {
    String? token = await AccessToken.getToken();
    setState(() {
      accessToken = token;
    });
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    String formattedDate =
        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

    final apiUrl =
        'https://api-deed-balancer.netlify.app/.netlify/functions/api/notes/$formattedDate';

    final headers = {'access-token': '$accessToken'};

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          positiveActivities = data['kegiatanBaik'];
          negativeActivities = data['kegiatanBuruk'];
          isLoading = false;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print('Exception while fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.h,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE6D4),
                foregroundColor: const Color.fromARGB(255, 255, 192, 147),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: const Size(90.0, 40.0),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/add-notes', (route) => false);
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => const AddNote()));
              },
              child: const Text(
                'Add Activities',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () async {
                DateTime? newSelectedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );

                if (newSelectedDate != null) {
                  setState(() {
                    selectedDate = newSelectedDate;
                  });
                  fetchData();
                }
              },
              child: Card(
                elevation: 4,
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black54,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: SizedBox(
                  width: 100,
                  height: 30,
                  child: Center(
                    child: Text(
                      selectedDate != null
                          ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
                          : "Select a date",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Positive Activities",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            width: 300.w,
                            height: 190.h,
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : positiveActivities.isNotEmpty
                                        ? ListView.builder(
                                            itemCount:
                                                positiveActivities.length,
                                            itemBuilder: (context, index) {
                                              var activity =
                                                  positiveActivities[index];
                                              return ListTile(
                                                  leading: Text(
                                                    activity['waktu']
                                                        .toString()
                                                        .substring(0, 5),
                                                    style: const TextStyle(
                                                        fontSize: 10.0),
                                                  ),
                                                  title: Text(
                                                    activity['deskripsi'],
                                                    style: const TextStyle(
                                                        fontSize: 13.0),
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      GestureDetector(
                                                        child: const Icon(
                                                          Icons.edit_note,
                                                          color: Colors.amber,
                                                        ),
                                                        onTap: () {
                                                          showModalEdit(
                                                            context,
                                                            accessToken,
                                                            activity,
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        width: 7.0,
                                                      ),
                                                      GestureDetector(
                                                        child: const Icon(
                                                            Icons.delete,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    220,
                                                                    33,
                                                                    20)),
                                                        onTap: () {
                                                          DeleteNote
                                                              .showDeleteConfirmationDialog(
                                                                  context,
                                                                  activity[
                                                                      'id_detail_catatan'],
                                                                  accessToken);
                                                        },
                                                      )
                                                    ],
                                                  ));
                                            },
                                          )
                                        : const Center(
                                            child:
                                                Text("No Positive Activities."),
                                          )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Text(
                        "Negative Activities",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            width: 300.w,
                            height: 190.h,
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : negativeActivities.isNotEmpty
                                        ? ListView.builder(
                                            itemCount:
                                                negativeActivities.length,
                                            itemBuilder: (context, index) {
                                              var activity =
                                                  negativeActivities[index];
                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            const AddNote(),
                                                      ),
                                                    );
                                                  },
                                                  child: ListTile(
                                                      leading: Text(
                                                        activity['waktu']
                                                            .toString()
                                                            .substring(0, 5),
                                                        style: const TextStyle(
                                                            fontSize: 10.0),
                                                      ),
                                                      title: Text(
                                                        activity['deskripsi'],
                                                        style: const TextStyle(
                                                            fontSize: 13.0),
                                                      ),
                                                      trailing: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          GestureDetector(
                                                            child: const Icon(
                                                              Icons.edit_note,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            onTap: () {
                                                              showModalEdit(
                                                                  context,
                                                                  accessToken,
                                                                  activity);
                                                            },
                                                          ),
                                                          const SizedBox(
                                                            width: 7.0,
                                                          ),
                                                          GestureDetector(
                                                            child: const Icon(
                                                                Icons.delete,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        220,
                                                                        33,
                                                                        20)),
                                                            onTap: () {
                                                              DeleteNote.showDeleteConfirmationDialog(
                                                                  context,
                                                                  activity[
                                                                      'id_detail_catatan'],
                                                                  accessToken);
                                                            },
                                                          )
                                                        ],
                                                      )));
                                            },
                                          )
                                        : const Center(
                                            child:
                                                Text('No Negative Activities.'),
                                          )),
                          ),
                        ),
                      )
                    ]))
          ],
        ),
      ),
    );
  }
}
