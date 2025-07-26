import 'package:flutter_demo/common/config/app_config.dart';

import '../../get_it_model.dart';

String makeRating(double voteAverage) =>
    '${(voteAverage * 10).toInt()}%  '
        '${(voteAverage * 10).toInt() >= int.parse(getit<AppConfig>().param(AppConfig.starRatingThreshold)) ? "🌟" : "    "}';
