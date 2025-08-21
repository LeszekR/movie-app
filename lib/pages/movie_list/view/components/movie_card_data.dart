import 'package:equatable/equatable.dart';

class MovieCardData extends Equatable {
  final int id;
  final String title;
  final String rating;

  const MovieCardData(this.id, this.title, this.rating);

  @override
  List<Object?> get props => [id, title, rating];

  @override
  bool get stringify => true;
}
