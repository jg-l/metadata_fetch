import 'package:html/dom.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

/// Does Works with `BaseMetadataParser`
class MetadataParser {
  /// This is the default strategy for building our [Metadata]
  ///
  /// It tries [OpenGraphParser], then [JsonLdParser], and falls back to [HTMLMetaParser] tags for missing data.
  static Metadata parse(Document document) {
    var output = Metadata();

    var parsers = [
      OpenGraph(document),
      HtmlMeta(document),
      JsonLdSchema(document),
    ];

    for (final p in parsers) {
      output.title ??= p.title;
      output.description ??= p.description;
      output.image ??= p.image;

      // is there a cleaner way?
      final hasEmpty = ((output.title == null ||
              output.description == null ||
              output.image == null) ==
          true);

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
}
