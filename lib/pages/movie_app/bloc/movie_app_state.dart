import 'package:equatable/equatable.dart';

import '../../../../bootstrap/get_it_model.dart';
import '../../../common/config/app_config.dart';

enum ELanguage { pl, en }

class MovieAppState extends Equatable {
  final String languageId;

  MovieAppState() : languageId = getIt<AppConfig>().param(AppConfig.languageOnStart);

  const MovieAppState.withLanguage({required this.languageId});

  MovieAppState copyWith({ELanguage? eLanguage}) {
    return MovieAppState.withLanguage(
      languageId: eLanguage != null ? eLanguage.name : languageId,
    );
  }

  @override
  List<Object?> get props => [languageId];
}
