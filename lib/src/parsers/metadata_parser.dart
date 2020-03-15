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

      if (output.hasAllMetadata) {
        break;
      }
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
