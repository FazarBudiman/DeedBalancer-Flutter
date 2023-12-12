// ignore_for_file: library_private_types_in_public_api, avoid_print, unnecessary_string_interpolations

import 'package:DeedBalancer/service/access_token.dart';
import 'package:DeedBalancer/service/api_service.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime = TimeOfDay.now();
  String _selectedOption = '2';
  String _textValue = '';
  String? accessToken;

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
  }

  Future<void> _loadAccessToken() async {
    accessToken = await AccessToken.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
            icon: const Icon(Icons.arrow_circle_left_outlined),
          ),
          title: const Text('Add Note'),
        ),
        body: Center(
          child: SizedBox(
              width: 300.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDatePicker(),
                      _buildTimePicker(),
                      _buildDropdown(),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        onSaved: (value) {
                          _textValue = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFE6D4),
                            foregroundColor:
                                const Color.fromARGB(255, 255, 192, 147),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            minimumSize: const Size(180.0, 40.0),
                          ),
                          onPressed: () {
                            _submitForm();
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ));
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date'),
        const SizedBox(height: 8),
        TextButton(
          style: TextButton.styleFrom(
              elevation: 4,
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFFFE6D4),
              shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black87),
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onPressed: () {
            _selectDate(context);
          },
          child: Text(
            _selectedDate != null
                ? "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}"
                : "Select Date",
            style: const TextStyle(color: Colors.black54),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Time'),
        const SizedBox(height: 8),
        TextButton(
          style: TextButton.styleFrom(
              elevation: 4,
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFFFE6D4),
              shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black87),
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onPressed: () {
            _selectTime(context);
          },
          child: Text(
            _selectedTime != null
                ? "${_selectedTime!.hour}:${_selectedTime!.minute}"
                : "Select Time",
            style: const TextStyle(color: Colors.black54),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category'),
        const SizedBox(height: 8),
        DropdownButtonFormField(
          value: _selectedOption,
          items: const [
            DropdownMenuItem(
              value: '2',
              child: Text('Select Category'),
            ),
            DropdownMenuItem(
              value: '1',
              child: Text('Positive'),
            ),
            DropdownMenuItem(
              value: '0',
              child: Text('Negative'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedOption = value.toString();
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select an option';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Process the data as needed

      String date = _selectedDate.toString().substring(0, 10);
      String waktu = _selectedTime.toString().substring(10, 15);
      Map<String, String?> data = {
        'tanggal': '$date',
        'waktu': '$waktu',
        'status': _selectedOption,
        'deskripsi': '$_textValue',
      };
      APIService.addNote(context, accessToken, data).then((response) => {
            print(response ? "Add Note Success" : "Add Note failed"),
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false)
          });
    }
  }
}
