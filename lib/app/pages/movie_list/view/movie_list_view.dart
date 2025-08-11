import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_demo/domain/ui_localized_texts/txt.dart';

import '../../../../get_it_model.dart';
import '../../../components/search_box.dart';
import '../controller/movie_list_controller.dart';
import 'components/movie_card.dart';

class MovieListView extends CleanView {
  static var movieDetailsButtonKey = Key('movieDetailsButtonKey');
  static var twoButButtonKey = Key("twoButtonsButtonKey");
  static var listViewKey = ValueKey('movieListKey');

  const MovieListView({super.key});

  @override
  MovieListViewState createState() => MovieListViewState();
}

class MovieListViewState extends CleanViewState<MovieListView, MovieListController> {
  MovieListViewState() : super(getIt<MovieListController>());

  final Txt _txt = getIt<Txt>();
  final MovieListController _controllerRef = getIt<MovieListController>();  // name must vary from _controller - CleanViewState field
  final MovieListNavigator _moviesNavigator = getIt<MovieListNavigator>();

  @override
  Widget get view {
    return ControlledWidgetBuilder<MovieListController>(builder: (context, controller) {
      if (_controllerRef.state.navCommand != _controllerRef.state.prevNavCommand) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _moviesNavigator.go(context, _controllerRef.state.navCommand);
          _controllerRef.restoreView = true;
        });
      }
      // else if (_controllerRef.restoreView) {
      //   _controllerRef.restoreView = false;
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     // _controllerRef.restoreViewState();
      //   });
      // }
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.movie_creation_outlined),
              onPressed: controller.fetchMovie,
            ),
          ],
          title: Text(_txt.get.movie_list_title),
        ),
        body: Column(
          children: <Widget>[
            SearchBox(
              textEditingController: controller.searchTextController,
              onSubmitted: controller.fetchSearchedMovies,
            ),
            Expanded(child: _buildMovieList(controller)),
          ],
        ),
      );
    });
  }

  Widget _buildMovieList(MovieListController controller) {
    List<Movie> movieList = controller.state.movieList?.results ?? List.empty();
    return ListView.separated(
      controller: controller.scrollController,
      separatorBuilder: (context, index) => Container(
        height: 1.0,
        color: Colors.grey.shade300,
      ),
      itemBuilder: (context, index) => MovieCard(
        id: movieList[index].id,
        title: movieList[index].title,
        voteAverage: movieList[index].voteAverage,
        onTap: controller.setSelectedMovieId,
        isSelected: movieList[index].id == controller.getSelectedMovieId(),
      ),
      itemCount: movieList.length,
    );
  }
}
