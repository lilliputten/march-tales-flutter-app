import 'package:march_tales_app/core/config/AppConfig.dart';

const String googleApiKey = AppConfig.GOOGLE_API_KEY;
const String googleCseId = AppConfig.GOOGLE_CSE_ID;

/// @see https://developers.google.com/custom-search/v1/reference/rest/v1/cse/list
const String googleImageUrlTemplate = 'https://www.googleapis.com/customsearch/v1'
    '?searchType=image'
    // '&googlehost=google.co.uk'
    '&safe=medium'
    '&imgSize=medium'
    '&imgType=face'
    '&fileType=jpeg'
    '&tbs=iar:s' // Square?
    '&num=10'
    '&key={apiKey}'
    '&cx={cseId}'
    '&q={search}';
