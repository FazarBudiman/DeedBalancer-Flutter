// ignore_for_file: avoid_print

import 'package:DeedBalancer/service/api_service.dart';
import 'package:flutter/material.dart';

void showModalEdit(
  BuildContext context,
  String? accessToken,
  dynamic detailNote,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: EditModalForm(
            accessToken: accessToken,
            detailNote: detailNote,
          ),
        ),
      );
    },
  );
}

class EditModalForm extends StatefulWidget {
  final String? accessToken;
  final dynamic detailNote;

  const EditModalForm({super.key, this.accessToken, required this.detailNote});

  @override
  // ignore: library_private_types_in_public_api
  _EditModalFormState createState() => _EditModalFormState();
}

class _EditModalFormState extends State<EditModalForm> {
  String? accessToken;
  int? id;
  TimeOfDay? time;
  String? description;

  late TextEditingController timeController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    accessToken = widget.accessToken;
    id = widget.detailNote['id_detail_catatan'];
    time = TimeOfDay(
      hour: int.parse(widget.detailNote['waktu'].toString().split(':')[0]),
      minute: int.parse(widget.detailNote['waktu'].toString().split(':')[1]),
    );
    description = widget.detailNote['deskripsi'];
    timeController = TextEditingController(text: time?.format(context) ?? '');
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: time ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        time = pickedTime;
        timeController.text = time?.format(context) ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Time'),
                      controller: timeController,
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              initialValue: description,
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE6D4),
                  foregroundColor: const Color.fromARGB(255, 255, 192, 147)),
              onPressed: () {
                String updateTime = time.toString().substring(10, 15);

                APIService.updateNote(
                        context, accessToken, updateTime, description, id)
                    .then((response) {
                  print(
                      response ? 'Update Note Success' : 'Update Note failed');
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false);
                });
              },
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
