import 'package:html/dom.dart';
import 'package:metadata_fetch/src/utils/util.dart';

import 'base_parser.dart';

/// Takes a [http.document] and parses [Metadata] from [<meta>, <title>, <img>] tags
class HtmlMetaParser with BaseMetadataParser {
  /// The [document] to be parse
  final Document _document;

  HtmlMetaParser(this._document);

  /// Get the [Metadata.title] from the [<title>] tag
  @override
  String get title => _document?.head?.querySelector('title')?.text;

  /// Get the [Metadata.description] from the <meta name="description" content=""> tag
  @override
  String get description => _document?.head
      ?.querySelector("meta[name='description']")
      ?.attributes
      ?.get('content');

  /// Get the [Metadata.image] from the first <img> tag in the body;s
  @override
  String get image =>
      _document?.body?.querySelector('img')?.attributes?.get('src');

  /// Get the [Document.url] from the Document extension.
  @override
  String get url => _document?.requestUrl;

  @override
  String toString() => parse().toString();
}
