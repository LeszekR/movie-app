import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_event.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_state.dart';
import 'package:go_router/go_router.dart';
import 'package:bloc/bloc.dart';

import '../../../common/ui_localized_texts/txt.dart';
import '../../../components/search_box.dart';
import '../../../get_it_model.dart';
import '../../../navigation/go_router_const_strings.dart';
import '../../movie_details/model/movie.dart';
import '../bloc/movie_list_bloc.dart';
import 'components/movie_card.dart';

class MovieListView extends StatefulWidget {
  const MovieListView({super.key});

  @override
  State<StatefulWidget> createState() => MovieListViewState();
}

class MovieListViewState extends State<MovieListView> {
  // TODO refactor the use of the scrollController - build each time? set scroll offset
  final ScrollController _scrollController = ScrollController();
  // TODO refactor use of the editingController - build each time? set text
  final TextEditingController _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieListBloc, MovieListState>(
      listenWhen: (previous, current) => current.isLoading,
      listener: (context, state) {
        // TODO  show progress indicator
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.movie_creation_outlined),
                onPressed: () => _showMovieDetails(context, state),
              ),
            ],
            title: Text(Txt.get.movie_list_title),
          ),
          body: Column(
            children: <Widget>[
              SearchBox(onSubmitted: (_) => _fetchSearchedMovies(context, state),),
              Expanded(child: _buildMovieList(context, state)),
            ],
          ),
        );
      },
    );
  }

  void _showMovieDetails(BuildContext context, MovieListState state) =>
      context.read<MovieListBloc>().add(ShowMovieDetailsEvent(state.selectedMovieId));

  void _fetchSearchedMovies(BuildContext context, MovieListState state) =>
      context.read<MovieListBloc>().add(SearchMoviesEvent(state.searchQuery));

  Widget _buildMovieList(BuildContext context, MovieListState state) {
    List<Movie> movieList = state.movieList?.results ?? List.empty();
    return ListView.separated(
      controller: _scrollController,
      separatorBuilder: (context, index) => Container(
        height: 1.0,
        color: Colors.grey.shade300,
      ),
      itemBuilder: (context, index) => MovieCard(
        id: movieList[index].id,
        title: movieList[index].title,
        rating: '${(movieList[index].voteAverage * 10).toInt()}%',
        // TODO finidsh adding the event here
        onTap: context.read<MovieListBloc>.add(SelectMovieEvent(movieId, scrollOffset)),
        isSelected: movieList[index].id == state.selectedMovieId,
      ),
      itemCount: movieList.length,
    );
  }

// void _showMovieDetails(MovieListBloc controller) {
//   controller.saveViewState();
//
//   context.pushNamed(
//     routeMovieDetails,
//     pathParameters: {
//       paramMovieTitle: controller.movieToShow!.title.toString(),
//       paramMovieBudget: controller.movieToShow!.budget.toString(),
//       paramMovieRevenue: controller.movieToShow!.revenue.toString(),
//     },
//   );
//   controller.onMovieDetailsShown();
// }
}

class MovieListScrollController extends ScrollController {}
