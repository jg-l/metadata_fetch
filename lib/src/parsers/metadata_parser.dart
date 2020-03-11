import 'package:html/dom.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

/// Does Works with `BaseMetadataParser`
class MetadataParser {
  /// This is the default strategy for building our [Metadata]
  ///
  /// It tries [OpenGraphParser], then [TwitterCardParser], then [JsonLdParser], and falls back to [HTMLMetaParser] tags for missing data.
  static Metadata parse(Document document) {
    final output = Metadata();

    final parsers = [
      OpenGraph(document),
      TwitterCard(document),
      JsonLdSchema(document),
      HtmlMeta(document),
    ];

    for (final p in parsers) {
      output.title ??= p.title;
      output.description ??= p.description;
      output.image ??= p.image;
      output.url ??= p.url;

      // is there a cleaner way?
      final hasEmpty = ((
          output.title == null ||
          output.description == null ||
          output.image == null ||
          output.url == null) == true);

      if (!hasEmpty) {
        break;
      }
      return output;
    }

    return output;
  }

  static Metadata OpenGraph(Document document) {
    return OpenGraphParser(document).parse();
  }

  static Metadata HtmlMeta(Document document) {
    return HtmlMetaParser(document).parse();
  }

  static Metadata JsonLdSchema(Document document) {
    return JsonLdParser(document).parse();
  }

  static Metadata TwitterCard(Document document) {
    return TwitterCardParser(document).parse();
  }
}
