import 'package:either_dart/either.dart';
import 'package:movie_trailers/core/api/error/failure.dart';
import 'package:movie_trailers/src/presentation/main_videos/data/model/video_model.dart';

abstract class VideoRepository{
  Future<Either<Failure, List<VideosModel>>> getVideo({required String link});
}