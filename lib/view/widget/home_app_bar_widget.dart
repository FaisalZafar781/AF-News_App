import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/utils/enums/enums.dart';
import 'package:news_app/view/category_screen.dart';

import '../../../bloc/news_bloc.dart';
import '../../../bloc/news_event.dart';

FilterList? selectedMenu;

class HomeAppBarWidget extends StatelessWidget {
  HomeAppBarWidget({super.key});

  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CategoriesScreen()));
        },
        icon: Image.asset(
          'assets/images/category_icon.png',
          height: 30,
          width: 30,
        ),
      ),
      title: Center(
        child: Text(
          'AF News',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      actions: [
        PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (FilterList item) {
              if (FilterList.bbcNews.name == item.name) {
                name = 'bbc-news';
              }
              if (FilterList.ignNews.name == item.name) {
                name = 'ign';
              }

              if (FilterList.cbcNews.name == item.name) {
                name = 'cbc-news';
              }

              if (FilterList.aljazeeraNews.name == item.name) {
                name = 'al-jazeera-english';
              }

              if (FilterList.cryptoCoinsNews.name == item.name) {
                name = 'crypto-coins-news';
              }

              context.read<NewsBloc>().add(FetchNewsChannelHeadlines(name));
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
                  const PopupMenuItem<FilterList>(
                    value: FilterList.bbcNews,
                    child: Text('BBC News'),
                  ),
                  const PopupMenuItem<FilterList>(
                    value: FilterList.ignNews,
                    child: Text('IGN'),
                  ),
                  const PopupMenuItem<FilterList>(
                    value: FilterList.cbcNews,
                    child: Text('CBC News'),
                  ),
                  const PopupMenuItem<FilterList>(
                    value: FilterList.aljazeeraNews,
                    child: Text('Al-Jazeera News'),
                  ),
                  const PopupMenuItem<FilterList>(
                    value: FilterList.cryptoCoinsNews,
                    child: Text('Crypto Coins News'),
                  ),
                ])
      ],
    );
  }
}

# touched on 2025-05-28T20:51:07.825077Z
# touched on 2025-05-28T20:51:17.006964Z
# touched on 2025-05-28T20:51:26.420017Z