import 'package:flutter/material.dart';

import 'common_widgets/title_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleSection(
            title: 'Favourites',
          ),
          const SizedBox(
            height: 190,
            // child: ListView.builder(
            //     padding:
            //     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            //     scrollDirection: Axis.horizontal,
            //     itemCount: homeVM.hostRecommendedArr.length,
            //     itemBuilder: (context, index) {
            //       var mObj = homeVM.hostRecommendedArr[index];
            //       return RecommendedCell(mObj: mObj);
            //     }),
          ),
          Divider(
            color: Colors.white.withOpacity(0.10),
            indent: 20,
            endIndent: 20,
          ),
          const TitleSection(
            title: 'Playlists',
          ),
          const TitleSection(
            title: 'Most Listened',
          ),
        ],
      )),
    );
  }
}
