import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qurinom_learnings/Models/notes_model.dart';
import 'package:qurinom_learnings/Services/db_helper.dart';

class NotesView extends StatefulWidget {
  final NotesModel? notes;
  const NotesView({super.key, this.notes});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  DatabaseHelper dbHelper = DatabaseHelper();
  String dateTime = DateFormat('MMM dd yyyy, KK:mm a').format(DateTime.now());
  final TextEditingController _tlteTFC = TextEditingController();
  final TextEditingController _descTFC = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    updateVaues();
    super.initState();
  }

  updateVaues() {
    if (widget.notes != null) {
      _tlteTFC.text = widget.notes!.nTitle;
      _descTFC.text = widget.notes!.nDescription;
    }
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer t) => setState(() {
        DateTime now = DateTime.now();
        dateTime = DateFormat('MMM dd yyyy, KK:mm a').format(now);
      }),
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _tlteTFC,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Colors.black38),
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Title',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                color: Colors.black38)),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      dateTime,
                      style: const TextStyle(color: Colors.black38),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _descTFC,
                        autofocus: true,
                        maxLines: 10,
                        onChanged: (value) {
                          setState(() {});
                        },
                        style: const TextStyle(),
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Description'),
                      ),
                    ),
                  ],
                )),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _descTFC.text.isEmpty
                          ? Colors.deepPurple.shade200
                          : Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: const Text("Save"),
                    onPressed: () async {
                      if (_descTFC.text.isNotEmpty) {
                        NotesModel transcaion = NotesModel(
                          nDescription: _descTFC.text,
                          nDateTime: dateTime,
                          nTitle: _tlteTFC.text,
                        );
                        if (widget.notes != null) {
                          transcaion = NotesModel(
                            id: widget.notes!.id,
                            nDescription: _descTFC.text,
                            nDateTime: dateTime,
                            nTitle: _tlteTFC.text,
                          );
                          //update record
                          await dbHelper
                              .update(
                            id: widget.notes!.id,
                            notes: transcaion,
                          )
                              .then((value) {
                            Navigator.pop(context, true);
                          }).catchError((e) {
                            print(e.toString());
                          });
                        } else {
                          //insert record
                          await dbHelper
                              .insert(transcaion.mapTransaction())
                              .then((value) {
                            Navigator.pop(context, true);
                          }).catchError((e) {
                            print(e.toString());
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
