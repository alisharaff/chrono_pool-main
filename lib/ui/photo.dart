import 'package:flutter/material.dart';
import 'package:chrono_pool/main.dart';

import '../components/cards.dart';
import '../components/crud.dart';
import '../constants/linksApi.dart';
import '../model/note.dart';
import '../notes/edit.dart';


class Photo extends StatefulWidget {
  const Photo({super.key});

  @override
  State<Photo> createState() => _HomeState();
}

class _HomeState extends State<Photo> {
  final Crud _crud = Crud();

  getNote() async {
    var response = await _crud.postRequest(linkViewNote, {
      "id": sharedPref.getString("id") ,
    });


    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text("photos"),
        actions: [
          IconButton(onPressed: () {
            sharedPref.clear();
            Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
          }, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addnote");
        },
        child:  Icon(Icons.add) ,
      ),
      body: Container(
        padding:  EdgeInsets.all(10),
        child: ListView(
          children: [
            FutureBuilder(
              future: getNote(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['status'] == 'success') {
                    return ListView.builder(
                      itemCount: snapshot.data['data'].length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return Cards(
                          onDelete: () async {
                            var response = await _crud.postRequest (linkDeleteNote , {
                              "id" : snapshot.data['data'][i]['note_id'].toString(),
                              "imagename" : snapshot.data['data'][i]['note_image'].toString()
                            }) ;
                            setState(() {

                            });

                            if (response['status']== ['success'] ) {
                              Navigator.of(context).pushReplacementNamed("home");
                            }


                          } ,
                          ontap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder:
                                (context) => EditNote(notes:snapshot.data['data'][i] ,) ));
                          },
                          noteModel : NoteModel.fromJson(snapshot.data['data'][i]), title: '', content: '',

                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        "There are no photos",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("Loading..."));
                }

                return Center(child: Text("Loading..."));
              },
            ),
          ],
        ),
      ),
    );
  }
}

