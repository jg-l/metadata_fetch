import 'package:html/dom.dart';

import 'base_parser.dart';
import 'parsers.dart';

typedef ParseFunction<T extends BaseMetadataParser> = T Function(Document? doc);

/// Does Works with `BaseMetadataParser`
class MetadataParser {
  /// This is the default strategy for building our [Metadata]
  ///
  /// It tries [OpenGraphParser], then [TwitterCardParser], then [JsonLdParser], and falls back to [HTMLMetaParser] tags for missing data.
  static Metadata parse(
    Document? document, {
    List<Type> order = const <Type>[
      OpenGraphParser,
      TwitterCardParser,
      JsonLdParser,
      HtmlMetaParser,
    ],
  }) {
    var output = Metadata();

    final parsers = <Type, ParseFunction>{
      OpenGraphParser: (doc) => OpenGraphParser(doc),
      TwitterCardParser: (doc) => TwitterCardParser(doc),
      JsonLdParser: (doc) => JsonLdParser(doc),
      HtmlMetaParser: (doc) => HtmlMetaParser(doc),
    };

    for (final key in order) {
      final metadata = parsers[key]?.call(document).parse();
      if (metadata == null) {
        continue;
      }

      output.merge(metadata);

      // Make sure we use the most specific URL for the resource. OpenGraph is not necessarilly
      // going to return the full URL.
      final url = output.url;
      if (url != null && metadata.url!.length > url.length) {
        output.url = metadata.url;
      }
    }

    if (output.url != null && output.image != null) {
      output.image = Uri.parse(output.url!).resolve(output.image!).toString();
    }

    return output;
  }

  static Metadata openGraph(Document? document) {
    return OpenGraphParser(document).parse();
  }

  static Metadata htmlMeta(Document? document) {
    return HtmlMetaParser(document).parse();
  }

  static Metadata jsonLdSchema(Document? document) {
    return JsonLdParser(document).parse();
  }

  static Metadata twitterCard(Document? document) {
    return TwitterCardParser(document).parse();
  }
}
