import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qurinom_learnings/Models/notes_model.dart';
import 'package:qurinom_learnings/Services/db_helper.dart';
import 'package:qurinom_learnings/Views/notes_view.dart';

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<NotesModel> transcations = [];

  @override
  void initState() {
    super.initState();
    getDataFromDB();
  }

  ///get all data from DB
  Future getDataFromDB() async {
    await dbHelper.queryAllRows().then((value) {
      print(value.toString());
      transcations = value
          .map((e) => NotesModel(
              id: e['id'],
              nDescription: e['description'],
              nDateTime: e['datetime'],
              nTitle: e['title']))
          .toList();
      setState(() {});
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: const Text("My Notes"),
        centerTitle: false,
        actions: const [],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 10.0,
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NotesView()))
              .then((value) {
            if (value != null && value) {
              getDataFromDB();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: transcations.isEmpty
            ? const Center(
                child: Text(
                "No Records Found",
                style: TextStyle(color: Colors.black45),
              ))
            : ListView.builder(
                itemBuilder: (context, i) {
                  return Card(
                      elevation: 5.0,
                      child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotesView(
                                          notes: transcations[i],
                                        ))).then((value) {
                              getDataFromDB();
                            });
                          },
                          tileColor: Colors.white,
                          leading:
                              const FaIcon(FontAwesomeIcons.clipboardCheck),
                          title: Text(
                            transcations[i].nTitle.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              print("Delete Clicked");
                              //Delete Notes--
                              await dbHelper
                                  .deleteRecord(notes: transcations[i])
                                  .then((value) {
                                print(value.toString());
                                getDataFromDB();
                              });
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.trash,
                              size: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                  child: Text(
                                    transcations[i].nDescription,
                                  ),
                                ),
                                Text(
                                  transcations[i].nDateTime,
                                  style: const TextStyle(color: Colors.black45),
                                ),
                              ],
                            ),
                          )));
                },
                itemCount: transcations.length,
              ),
      )),
    );
  }
}
