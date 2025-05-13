import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:movie_trailers/src/presentation/main_videos/data/model/video_model.dart';
//import 'package:movie_trailers/core/widgets/app_constants.dart';

class VideoItem extends StatefulWidget {
  final int currentIndex;
  final void Function() onTap;
  final List<VideosModel>? videos;
  final String videoId;

  const VideoItem({
    super.key,
    required this.currentIndex,
    required this.videos,
    required this.videoId,
    required this.onTap,
  });

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        if (difference.inMinutes < 1) {
          return 'Uploaded just now';
        } else {
          final minutes = difference.inMinutes;
          return 'Uploaded $minutes minute${minutes > 1 ? 's' : ''} ago';
        }
      } else {
        final hours = difference.inHours;
        return 'Uploaded $hours hour${hours > 1 ? 's' : ''} ago';
      }
    } else if (difference.inDays == 1) {
      return 'Uploaded yesterday';
    } else if (difference.inDays < 7) {
      return 'Uploaded ${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Uploaded $weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Uploaded $months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Uploaded $years year${years > 1 ? 's' : ''} ago';
    }
  }

/*  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    final years = (difference.inDays / 365).floor();
    final months = ((difference.inDays % 365) / 30).floor();
    final days = (difference.inDays % 365) % 30;

    final yearString = years > 0 ? '$years year${years > 1 ? 's' : ''} ' : '';
    final monthString = months > 0 ? '$months month${months > 1 ? 's' : ''} ' : '';
    final dayString = days > 0 ? '$days day${days > 1 ? 's' : ''} ' : '';
    //final todayString = days == 0 ? 'Hours' : '';

    if (days == 0) {
      return "Uploaded today";
    } else if (days == 1) {
      return "Uploaded yesterday";
    } else
      return '${(yearString + monthString + dayString).trim()} ago';
  } */

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double setWidth = size.width;
    //double set_height = size.height;
    double setHeight;

    if (setWidth < 600) {
      setHeight = size.height * .28;
    } else {
      setHeight = size.height * .37;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric( vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: widget.videos?[widget.currentIndex].Thumbnail ?? "",
                height: setHeight,
                width:  setWidth,

                // height: 350,
                // width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 200,
                    width: 180,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  widget.videos?[widget.currentIndex].Title ?? "No Title",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // const SizedBox(height: 4),
              // Text(
              //   "Channel name : ${widget.videos?[widget.currentIndex].Channelname ?? "No Channel"}",
              //   style: const TextStyle(
              //     fontSize: 14,
              //   ),
              // ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.videos?[widget.currentIndex].Channelname?.toString() ?? "No channel",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      widget.videos?[widget.currentIndex].Upload_date != null
                          ? formatDate(
                        widget.videos?[widget.currentIndex].Upload_date ?? DateTime.now(),
                      )
                          : "No date",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  final years = (difference.inDays / 365).floor();
  final months = ((difference.inDays % 365) / 30).floor();
  final days = (difference.inDays % 365) % 30;
  final hours = difference.inHours;

  final yearString = years > 0 ? '$years year${years > 1 ? 's' : ''} ' : '';
  final monthString = months > 0 ? '$months month${months > 1 ? 's' : ''} ' : '';
  final dayString = days > 0 ? '$days day${days > 1 ? 's' : ''} ' : '';

  if (days == 0) {
    return "Uploaded today";
  } else if (days == 1) {
    return "Uploaded yesterday";
  } else
    return '${(yearString + monthString + dayString).trim()} ago';
}
