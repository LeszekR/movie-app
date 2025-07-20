import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:go_router/go_router.dart';

import '../../../common/ui_localized_texts/txt.dart';
import '../../../components/search_box.dart';
import '../../../get_it_model.dart';
import '../../../navigation/go_router_const_strings.dart';
import '../../movie_details/model/movie.dart';
import '../bloc/movie_list_bloc.dart';
import 'components/movie_card.dart';

class MovieListView extends CleanView {
  const MovieListView({super.key});

  @override
  MovieListViewState createState() => MovieListViewState();
}

// class MovieListViewState extends CleanViewState<MovieListView, MovieListBloc> {
//   MovieListViewState() : super(getit<MovieListBloc>());


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Txt.setLanguage(context);
  }

  @override
  Widget get view {
    return ControlledWidgetBuilder<MovieListBloc>(builder: (context, controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.movieToShow != null) {
          _showMovieDetails(controller);
        } else {
          controller.restoreViewState();
        }
      });
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.movie_creation_outlined),
              onPressed: controller.fetchMovie,
            ),
          ],
          title: Text(Txt.get.movie_list_title),
        ),
        body: Column(
          children: <Widget>[
            SearchBox(onSubmitted: controller.fetchSearchedMovies),
            Expanded(child: _buildMovieList(controller)),
          ],
        ),
      );
    });
  }

  Widget _buildMovieList(MovieListBloc controller) {
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
        rating: '${(movieList[index].voteAverage * 10).toInt()}%',
        onTap: controller.setSelectedMovieId,
        isSelected: movieList[index].id == controller.getSelectedMovieId(),
      ),
      itemCount: movieList.length,
    );
  }

  void _showMovieDetails(MovieListBloc controller) {
    controller.saveViewState();

    context.pushNamed(
      routeMovieDetails,
      pathParameters: {
        paramMovieTitle: controller.movieToShow!.title.toString(),
        paramMovieBudget: controller.movieToShow!.budget.toString(),
        paramMovieRevenue: controller.movieToShow!.revenue.toString(),
      },
    );
    controller.onMovieDetailsShown();
  }
}

class MovieListScrollController extends ScrollController{}
