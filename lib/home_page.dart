import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:note_app_sqlite/db_helper.dart';

import 'notes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DBHelper dbHelper;
   late Future<List<NotesModel>> allNotes;
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    getNotesList();
  }

  Future<void> getNotesList()async{
     allNotes = dbHelper.getAllNotes();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteApp'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: allNotes,
        builder: (_,AsyncSnapshot<List<NotesModel>>snapshot)=>
        snapshot.hasData ?
            ListView.separated(
              reverse: true,
            shrinkWrap: true,
            itemBuilder: (_,index){
              var singleNote = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    dbHelper.editNote(
                        NotesModel(
                          id: singleNote.id,
                            title: '3rd note edited',
                            age: 45,
                            description: 'description',
                            email: 'email@email.com'
                        ),
                    );
                    setState(() {
                      allNotes = dbHelper.getAllNotes();

                    });
                  },
                  child: Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                    ),
                    key: ValueKey(singleNote.id),
                    onDismissed: (DismissDirection direction){
                      setState(() {
                        dbHelper.deleteNote(singleNote.id!);
                        allNotes = dbHelper.getAllNotes();
                        snapshot.data!.remove(singleNote);
                      });
                    },
                    child: Card(
                      child: ListTile(
                        contentPadding:
                        const EdgeInsets.symmetric(
                            vertical: 10,
                          horizontal: 20,
                        ),
                        title: Text(singleNote.title,
                        textAlign: TextAlign.center,
                        ),
                        subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(singleNote.email),
                            Text(singleNote.description),
                          ],
                        ),
                        trailing: Text(singleNote.age.toString()),
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (_,__)=>const SizedBox(height: 5),
            itemCount: snapshot.data!.length,
        )
        : const Center(child: CircularProgressIndicator())
        ,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          dbHelper.createNote(
              NotesModel(
                title: '4th note',
                age: 50,
                description: 'this is the 4th note',
                email: 'email@email.com'
              ),
          ).then((value) {
            log("Note is added");
              setState(() {
                allNotes = dbHelper.getAllNotes();
              });
          }).onError((error, st){
            log(st.toString());
          }
          );
        },
        child: const Icon(Icons.add),
      ),

    );
  }
}
