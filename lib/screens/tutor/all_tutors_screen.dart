// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class AllTutorsScreen extends StatefulWidget {

//   final String token;

//   const AllTutorsScreen({
//     super.key,
//     required this.token,
//   });

//   @override
//   State<AllTutorsScreen> createState() => _AllTutorsScreenState();
// }

// class _AllTutorsScreenState extends State<AllTutorsScreen> {

//   List tutors = [];

//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchTutors();
//   }

//   Future<void> fetchTutors() async {

//     try {

//       final response = await http.get(

//         Uri.parse(
//           "https://zindalearnbackend.onrender.com/api/tuter/all",
//         ),

//         headers: {
//           "Authorization": "Bearer ${widget.token}",
//         },

//       );

//       print("STATUS: ${response.statusCode}");
//       print("BODY: ${response.body}");

//       if (response.statusCode == 200) {

//         final data = jsonDecode(response.body);

//         setState(() {
//           tutors = data["tuters"];
//           isLoading = false;
//         });

//       } else {

//         setState(() {
//           isLoading = false;
//         });

//       }

//     } catch (e) {

//       print(e);

//       setState(() {
//         isLoading = false;
//       });

//     }
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       appBar: AppBar(
//         title: const Text("All Tutors"),
//       ),

//       body: isLoading

//           ? const Center(
//               child: CircularProgressIndicator(),
//             )

//           : ListView.builder(

//               itemCount: tutors.length,

//               itemBuilder: (context, index) {

//                 final tutor = tutors[index];

//                 return Card(

//                   margin: const EdgeInsets.all(10),

//                   child: ListTile(

//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(
//                         tutor["photo"] ?? "",
//                       ),
//                     ),

//                     title: Text(
//                       tutor["name"] ?? "",
//                     ),

//                     subtitle: Text(
//                       tutor["qualification"] ?? "",
//                     ),

//                   ),

//                 );
//               },
//             ),
//     );
//   }
// }