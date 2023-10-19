import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trytoshop/constants/colors.dart';
import 'package:trytoshop/models/note.dart';
import 'package:trytoshop/screens/edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> filteredNotoes = [];
  bool sorted = false;

  @override
  void initState() {
    super.initState();
    filteredNotoes = sampleNotes;
  }

  List<Note> sortNotesByModifiedTime(List<Note> notes) {
    if (sorted) {
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    } else {
      notes.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }
    sorted = !sorted;
    return notes;
  }

  // notice color el card
  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

// bar el foka 3and el search
  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredNotoes = sampleNotes
          .where((note) =>
              note.content.toLowerCase().contains(searchText.toLowerCase()) ||
              note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

// to delete boxes
  void deleteNote(int index) {
    setState(() {
      filteredNotoes.removeAt(index);
      Note note = filteredNotoes[index];
      sampleNotes.remove(note);
      filteredNotoes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tasks Notice',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        filteredNotoes =
                            sortNotesByModifiedTime(filteredNotoes);
                      });
                    },
                    padding: EdgeInsets.all(0),
                    icon: Container(
                      padding: EdgeInsets.all(10),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.lime[400],
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.sort,
                        color: Colors.white ,
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),

            // notice line  search and box of write down
            TextField(
              onChanged: (value) {
                onSearchTextChanged(value);
              },
              style: TextStyle(fontSize: 20, color: Colors.white),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                hintText: "SEARCH NOTES",
                hintStyle: TextStyle(color: Colors.cyanAccent),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.cyanAccent,
                ),
                fillColor: Colors.grey.shade800,
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.transparent)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.transparent)),
              ),
            ),

            Expanded(
                child: ListView.builder(
              padding: EdgeInsets.only(top: 30),
              itemCount: filteredNotoes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 20),
                  color: getRandomColor(),

                  // notice el masfaa between el card w search
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => EditScreen(
                                    note: filteredNotoes[index],
                                  )),
                        );

                        if (result != null) {
                          setState(() {
                            int originalIndex =
                                sampleNotes.indexOf(filteredNotoes[index]);
                            sampleNotes[originalIndex] = (Note(
                                id: sampleNotes[originalIndex].id,
                                title: result[0],
                                content: result[1],
                                modifiedTime: DateTime.now()));
                            filteredNotoes = sampleNotes;
                          });
                        }
                      },

                      title: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        text: TextSpan(
                            text: '${filteredNotoes[index].title} :\n',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                height: 1.5),

                            //notice second line write  in card
                            children: [
                              TextSpan(
                                text: '${filteredNotoes[index].content}',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    height: 1.4),
                              )
                            ]),
                      ),

                      //notice third line write  in card
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        // meaning of this line Fri, Sep 30, 2022 01:10 PM
                        child: Text(
                          'Edited: ${DateFormat('EEE MMM d, yyyy h:m a').format(filteredNotoes[index].modifiedTime)}',
                          style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.normal,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),

                      trailing: IconButton(
                        onPressed: () async {
                          final result = await confirmDialog(context);
                          // notice sa7 or 3alt
                          if (result != null && result) {
                            deleteNote(index);
                          }
                        },
                        icon: Icon(
                          Icons.delete,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),

      //notice of button icon down right
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const EditScreen()),
          );

          if (result != null) {
            setState(() {
              sampleNotes.add(Note(
                  id: sampleNotes.length,
                  title: result[0],
                  content: result[1],
                  modifiedTime: DateTime.now()));
              filteredNotoes = sampleNotes;
            });
          }
        },
        elevation: 10,
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.adb_sharp,
          size: 38,
        ),
      ),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade900,
            icon: Icon(
              Icons.info,
              color: Colors.blue,
            ),
            title: Text(
              'Are you want to delete?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent[100]),
                  child: SizedBox(
                    width: 60,
                    child: Text(
                      'YES',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: SizedBox(
                    width: 60,
                    child: Text(
                      'NO',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
