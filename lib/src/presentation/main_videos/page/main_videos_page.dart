import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:movie_trailers/app/router.dart';
import 'package:movie_trailers/app/theme.dart';
import 'package:movie_trailers/core/constants/app_color.dart';
import 'package:movie_trailers/core/constants/constants.dart';
import 'package:movie_trailers/core/utils/status.dart';
import 'package:movie_trailers/core/widgets/error_widget.dart';
import 'package:movie_trailers/core/widgets/loading_widget.dart';
import 'package:movie_trailers/core/widgets/my_custom_text.dart';
import 'package:movie_trailers/core/widgets/video_widget.dart';
import 'package:movie_trailers/src/presentation/main_videos/bloc/videos_bloc.dart';
import 'package:movie_trailers/src/presentation/main_videos/data/model/video_model.dart';

class MainPageVideos extends StatefulWidget {
  const MainPageVideos({super.key});

  @override
  State<MainPageVideos> createState() => _MainPageVideosState();
}

class _MainPageVideosState extends State<MainPageVideos> {

  final TextEditingController _searchController = TextEditingController();
  List<VideosModel>? filteredVideos;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterVideos);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterVideos);
    _searchController.dispose();
    super.dispose();
  }

  void _filterVideos() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredVideos = null; // If the search is empty, show all videos
      });
      return;
    }

    setState(() {
      filteredVideos = (BlocProvider.of<VideosBloc>(context)
          .state
          .page1Videos
          ?.where((video) => (video.Title ?? "").toLowerCase().contains(query))
          .toList() ??
          [])
          .toSet()  // Convert list to Set to remove duplicates
          .toList(); // Convert Set back to List
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       backgroundColor: Colors.grey.shade200,
  //       appBar: AppBar(
  //         backgroundColor: Colors.red,
  //         title: const MyCustomText(
  //           'The Tonight Show starring Jimmy Fallon',
  //           fontSize: 20,
  //           color: AppColor.white,
  //         ),
  //       ),
  //       body: BlocBuilder<VideosBloc, VideosState>(
  //         builder: (context, state) {
  //           if (state.status == Status.success) {
  //             var videos = state.page1Videos;
  //             return LiquidPullToRefresh(
  //               color: MyColors.background,
  //               backgroundColor: MyColors.primary,
  //               animSpeedFactor: 2,
  //               springAnimationDurationInMilliseconds: 600,
  //               showChildOpacityTransition: false,
  //               height: 100,
  //               onRefresh: _refreshNews,
  //               child: ListView.builder(
  //                 itemCount: videos?.length ?? 0,
  //                 itemBuilder: (context, index) {
  //                   return Column(
  //                     children: [
  //                       VideoItem(
  //                         videoId: videos?[index].Video_id ?? '',
  //                         currentIndex: index,
  //                         videos: videos,
  //                         onTap: () {
  //                           GoRouter.of(context).push(
  //                             Routes.videoPage,
  //                             extra: {'videos': videos, 'videoId': videos?[index].Video_id ?? '', 'currentIndex': index},
  //                           );
  //                         },
  //                       ),
  //                       const Divider()
  //                     ],
  //                   );
  //                 },
  //               ),
  //             );
  //           } else if (state.status == Status.error) {
  //             return Center(
  //               child: MyErrorWidget(
  //                 onRetry: () {
  //                   context.read<VideosBloc>().add(
  //                     GetPage1Videos(link: Constants.firstVideosLink),
  //                   );
  //                 },
  //                 errorMsg: state.failure?.errorMsg ?? "",
  //               ),
  //             );
  //           }
  //           return const Center(
  //             child: LoadingWidget(),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const MyCustomText(
            'Movies',
            fontSize: 20,
            color: AppColor.white,
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
              ),
              child: TextField(
                onTapOutside: (tab) => FocusScope.of(context).unfocus(),
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search',
                  border: InputBorder.none,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<VideosBloc, VideosState>(
                builder: (context, state) {
                  if (state.status == Status.success) {
                    // Filtering is done here
                    final videos = filteredVideos ?? state.page1Videos;

                    if (videos == null || videos.isEmpty) {
                      return const Center(
                        child: Text('No videos found'),
                      );
                    }

                    return LiquidPullToRefresh(
                      color: MyColors.background,
                      backgroundColor: MyColors.primary,
                      animSpeedFactor: 2,
                      springAnimationDurationInMilliseconds: 600,
                      showChildOpacityTransition: false,
                      height: 100,
                      onRefresh: _refreshNews,
                      child: ListView.builder(
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              VideoItem(
                                videoId: videos[index].Video_id ?? "",
                                currentIndex: index,
                                videos: videos,
                                onTap: () {
                                  GoRouter.of(context).push(
                                    Routes.videoPage,
                                    extra: {
                                      'videos': videos,
                                      'videoId': videos[index].Video_id,
                                      'currentIndex': index,
                                    },
                                  );
                                },
                              ),
                              Divider()
                            ],
                          );
                        },
                      ),
                    );
                  } else if (state.status == Status.error) {
                    return Center(
                      child: MyErrorWidget(
                        onRetry: () {
                          context.read<VideosBloc>().add(
                            GetPage1Videos(link: Constants.firstVideosLink),
                          );
                        },
                        errorMsg: state.failure?.errorMsg ?? "",
                      ),
                    );
                  }
                  return const Center(
                    child: LoadingWidget(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshNews() async {
    BlocProvider.of<VideosBloc>(context).add(
      GetPage1Videos(link: Constants.firstVideosLink),
    );
  }
}