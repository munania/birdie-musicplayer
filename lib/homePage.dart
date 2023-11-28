// import 'package:flutter/material.dart';
//
// import 'common_widgets/title_section.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: Row(
//           children: [
//             Text("Birdie", style: Theme.of(context).textTheme.displayLarge),
//             const SizedBox(
//               width: 15,
//             ),
//             Expanded(
//               child: Container(
//                 height: 38,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(19),
//                 ),
//                 child: TextField(
//                   // controller: controller,
//                   decoration: InputDecoration(
//                     contentPadding:
//                     const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
//                     prefixIcon: Container(
//                       margin: const EdgeInsets.only(left: 20),
//                       alignment: Alignment.centerLeft,
//                       width: 30,
//                       child: Image.asset(
//                         "assets/images/search.png",
//                         width: 20,
//                         height: 20,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                     hintText: "Search album song",
//                     hintStyle:
//                     Theme.of(context).textTheme.displaySmall?.copyWith(
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//           child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const TitleSection(
//             title: 'Favourites',
//           ),
//           const SizedBox(
//             height: 190,
//             // child: ListView.builder(
//             //     padding:
//             //     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             //     scrollDirection: Axis.horizontal,
//             //     itemCount: homeVM.hostRecommendedArr.length,
//             //     itemBuilder: (context, index) {
//             //       var mObj = homeVM.hostRecommendedArr[index];
//             //       return RecommendedCell(mObj: mObj);
//             //     }),
//           ),
//           Divider(
//             color: Colors.white.withOpacity(0.10),
//             indent: 20,
//             endIndent: 20,
//           ),
//           const TitleSection(
//             title: 'Playlists',
//           ),
//           const TitleSection(
//             title: 'Most Listened',
//           ),
//         ],
//       )),
//     );
//   }
// }
