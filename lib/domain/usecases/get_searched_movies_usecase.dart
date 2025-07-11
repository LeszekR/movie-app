import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_recruitment_task/data/repositories/data_movies_repository.dart';
import 'package:flutter_recruitment_task/domain/entities/movie.dart';

class GetSearchedMoviesUseCase
    extends BackgroundUseCase<GetSearchedMoviesUseCaseResponse?, GetSearchedMoviesUseCaseParams> {
  final DataMoviesRepository moviesRepository;

//  TODO use get_it to di this
  GetSearchedMoviesUseCase(this.moviesRepository);

  @override
  UseCaseTask buildUseCaseTask() {
    return _getSearchedMovies;
  }

  static void _getSearchedMovies(BackgroundUseCaseParams<dynamic> params) async {
    List<Movie> movieList = List.empty();
    try {
      var searchText = params.params;
      movieList = await DataMoviesRepository().getSearchedMovies(searchText!);
    } catch (e) {
      // TODO create and throw exception on the other side
      params.port.send(e);
    }
    params.port.send(BackgroundUseCaseMessage(data: GetSearchedMoviesUseCaseResponse(movieList)));
    // params.port.send(GetSearchedMoviesUseCaseResponse(movieList));
  }
}

class GetSearchedMoviesUseCaseParams extends BackgroundUseCaseParams<String> {
  String searchText;

  GetSearchedMoviesUseCaseParams(super.port, this.searchText);
}

class GetSearchedMoviesUseCaseResponse {
  final List<Movie> movieList;

  const GetSearchedMoviesUseCaseResponse(this.movieList);
}
