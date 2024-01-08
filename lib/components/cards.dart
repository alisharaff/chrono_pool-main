// import 'package:flutter/material.dart';
// import 'package:project_test/Model/note.dart';

// import '../constants/linksApi.dart';

// class Cards extends StatelessWidget {
//   final void Function()? ontap ;
//   final NoteModel noteModel ;
//   final String title ;
//   final String content ;
//   final void Function()?onDelete;

//   const Cards({super.key, this.ontap,
//     required this.title,
//     required this.content,
//     this.onDelete,
//     required this.noteModel});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: ontap,
//       child: Card(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 1,
//               child: Image.network(
//                 "$linkImageRoot/${noteModel.noteImage}",
//                 width: 100,
//                 height: 100,
//                 fit: BoxFit.fill,
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: ListTile(
//                 title: Text("${noteModel.noteTitle}"),
//                 subtitle: Text("${noteModel.noteContent}"),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete_forever,),
//                 onPressed: onDelete  ,
//                 ) ,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
