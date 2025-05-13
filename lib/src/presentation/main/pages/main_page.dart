import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_trailers/app/theme.dart';
import 'package:movie_trailers/core/constants/constants.dart';
import 'package:movie_trailers/src/presentation/main/bloc/bottom_navigation_bloc.dart';
import 'package:movie_trailers/src/presentation/main_videos/bloc/videos_bloc.dart';
import 'package:movie_trailers/src/presentation/main_videos/page/main_videos_page.dart';
import 'package:movie_trailers/src/presentation/page2_videos/page/page2_videos.dart';
import 'package:movie_trailers/src/presentation/page3_videos/page/page3_videos.dart';
import 'package:movie_trailers/src/presentation/page4_videos/page/page4_videos.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = CupertinoTabController();

  @override
  void initState() {
    context.read<VideosBloc>().add(GetPage1Videos(link: Constants.firstVideosLink ));
    context.read<VideosBloc>().add(GetPage2Videos(link: Constants.secondVideosLink));
    context.read<VideosBloc>().add(GetPage3Videos(link: Constants.thirdVideosLink));
  //  context.read<VideosBloc>().add(GetPage4Videos(link: Constants.fourthVideosLink));
  //  context.read<VideosBloc>().add(GetPage5Videos(link: Constants.fifthVideosLink));
  //  context.read<VideosBloc>().add(GetPage6Videos(link: Constants.sixthVideosLink));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<BottomNavigationBloc, BottomNavigationState>(
        listener: (context, state) {},
        builder: (context, state) {
          controller.index = state.index;
          return CupertinoTabScaffold(
            controller: controller,
            tabBar: CupertinoTabBar(
              height: kBottomNavigationBarHeight,
              backgroundColor: MyColors.white,
              activeColor: MyColors.primary,
              inactiveColor: MyColors.inactive,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.movie),
                  label: 'Movies',

                ),
                BottomNavigationBarItem(
                 icon: Icon(Icons.games),
                  label: 'Games',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.theaters),
                  label: 'Popular trailers',
                ),
                //BottomNavigationBarItem(
                //  icon: Icon(Icons.theater_comedy),
                //  label: 'Popular2',
                //),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.theater_comedy_outlined),
                //   label: 'Daily Show',
                // ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.theater_comedy),
                //   label: 'Weekly',
                // ),
              ],

              onTap: (index) {
                context.read<BottomNavigationBloc>().add(SetBottomNavigationIndexEvent(index: index));
              },
            ),
            tabBuilder: (BuildContext context, int index) {
              return CupertinoTabView(
                builder: (BuildContext context) {
                  return _buildPage(index);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const MainPageVideos();
      case 1:
        return const Page2Videos();
      case 2:
        return const Page3Videos();
      //case 3:
      //  return const Page4Videos();
      // case 4:
      //   return const Page5Videos();
      // case 5:
      //   return const Page6Videos();
      default:
        return const MainPageVideos();
    }
  }
}
