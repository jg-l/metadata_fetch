import 'package:html/dom.dart';
import 'package:metadata_fetch/src/utils/util.dart';

import 'base_parser.dart';

/// Takes a httml [document] and parses [Metadata] from [<meta>, <title>, <img>] tags
class HTMLMetaParser extends BaseMetadataParser {
  /// The [document] to be parse
  Document document;

  HTMLMetaParser(this.document);

  /// Get the [Metadata.title] from the [<title>] tag
  @override
  String get title => document?.head?.querySelector('title')?.text;

  /// Get the [Metadata.description] from the <meta name="description" content=""> tag
  @override
  String get description => document?.head
      ?.querySelector("meta[name='description']")
      ?.attributes
      ?.get('content');

  /// Get the [Metadata.image] from the first <img> tag in the body;s
  @override
  String get image =>
      document?.body?.querySelector('img')?.attributes?.get('src');
}
