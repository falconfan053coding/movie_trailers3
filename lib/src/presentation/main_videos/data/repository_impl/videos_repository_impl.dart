import 'package:either_dart/either.dart';
import 'package:movie_trailers/core/api/error/failure.dart';
import 'package:movie_trailers/core/api/interceptor/interceptor.dart';
import 'package:movie_trailers/src/presentation/main_videos/data/model/video_model.dart';
import 'package:movie_trailers/src/presentation/main_videos/domain/repository/videos_repository.dart';

class VideosRepositoryImpl extends VideoRepository {
  @override
  Future<Either<Failure, List<VideosModel>>> getVideo({required String link}) async {
    final res = await ApiClient().getMethod(
      pathUrl: "/$link",
      isHeader: false,
    );
    if (res.isSuccess) {
      List<VideosModel> newsList = (res.response as List)
          .map((newsItem) => VideosModel.fromJson(newsItem))
          .toList();
      return Right(newsList);
    }
    return Left(Failure(errorMsg: res.response));
  }
}