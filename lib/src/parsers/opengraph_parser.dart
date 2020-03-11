import 'package:html/dom.dart';
import 'package:metadata_fetch/src/utils/util.dart';

import 'base_parser.dart';

/// Takes a [http.Document] and parses [Metadata] from [<meta property='og:*'>] tags
class OpenGraphParser extends BaseMetadataParser {
  final Document _document;
  OpenGraphParser(this._document);

  /// Get [Metadata.title] from 'og:title'
  @override
  String get title => _document?.head
      ?.querySelector("[property*='og:title']")
      ?.attributes
      ?.get('content');

  /// Get [Metadata.description] from 'og:description'
  @override
  String get description => _document?.head
      ?.querySelector("[property*='og:description']")
      ?.attributes
      ?.get('content');

  /// Get [Metadata.image] from 'og:image'
  @override
  String get image => _document?.head
      ?.querySelector("[property*='og:image']")
      ?.attributes
      ?.get('content');

  /// Get [Metadata.url] from 'og:url'
  @override
  String get url => _document?.head
      ?.querySelector("[property*='og:url']")
      ?.attributes
      ?.get('content');
}
