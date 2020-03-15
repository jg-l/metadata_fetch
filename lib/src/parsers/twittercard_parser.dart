import 'package:html/dom.dart';
import 'package:metadata_fetch/src/utils/util.dart';

import 'base_parser.dart';

/// Takes a [http.Document] and parses [Metadata] from [<meta property='twitter:*'>] tags
class TwitterCardParser with BaseMetadataParser {
  Document document;
  TwitterCardParser(this.document);

  /// Get [Metadata.title] from 'twitter:title'
  @override
  String get title => document?.head
      ?.querySelector("[property*='twitter:title']")
      ?.attributes
      ?.get('content');

  /// Get [Metadata.description] from 'twitter:description'
  @override
  String get description => document?.head
      ?.querySelector("[property*='twitter:description']")
      ?.attributes
      ?.get('content');

  /// Get [Metadata.image] from 'twitter:image'
  @override
  String get image => document?.head
      ?.querySelector("[property*='twitter:image']")
      ?.attributes
      ?.get('content');

  /// Get [Document.url]
  String get url => document?.requestUrl;
}
