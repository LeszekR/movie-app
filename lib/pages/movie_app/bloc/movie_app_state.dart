import 'package:equatable/equatable.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';

enum ELanguage { pl, en }

class MovieAppState extends Equatable {
  final String languageId;

  MovieAppState() : languageId = getIt<AppParams>().param(AppParams.languageOnStart);

  const MovieAppState.withLanguage({required this.languageId});

  MovieAppState copyWith({ELanguage? eLanguage}) {
    return MovieAppState.withLanguage(
      languageId: eLanguage != null ? eLanguage.name : languageId,
    );
  }

  @override
  List<Object?> get props => [languageId];
}
