/// The base class for implementing a parser

mixin MetadataKeys {
  static const keyTitle = 'title';
  static const keyDescription = 'description';
  static const keyImage = 'image';
  static const keyUrl = 'url';
}

mixin BaseMetadataParser {
  String? title;
  String? description;
  String? image;
  String? url;

  Metadata parse() {
    final m = Metadata();
    m.title = title;
    m.description = description;
    m.image = image;
    m.url = url;
    return m;
  }
}

/// Container class for Metadata
class Metadata with BaseMetadataParser, MetadataKeys {
  bool get hasAllMetadata {
    return (
        title != null &&
        description != null &&
        image != null &&
        url != null
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }

  Map<String, String?> toMap() {
    return {
      MetadataKeys.keyTitle: title,
      MetadataKeys.keyDescription: description,
      MetadataKeys.keyImage: image,
      MetadataKeys.keyUrl: url,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  static Metadata fromJson(Map<String, dynamic> json) {
    final m = Metadata();
    m.title = json[MetadataKeys.keyTitle];
    m.description = json[MetadataKeys.keyDescription];
    m.image = json[MetadataKeys.keyImage];
    m.url = json[MetadataKeys.keyUrl];
    return m;
  }
}
