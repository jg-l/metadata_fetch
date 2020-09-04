/// The base class for implementing a parser

mixin MetadataKeys {
  static const keyTitle = 'title';
  static const keyDescription = 'description';
  static const keyImage = 'image';
  static const keyUrl = 'url';
  static const keySiteName = 'site_name';
  static const keyType = 'type';
}

mixin BaseMetadataParser {
  String title;
  String description;
  String image;
  String url;
  String siteName;
  String type;

  Metadata parse() => Metadata()
    ..title = title
    ..description = description
    ..image = image
    ..url = url
    ..siteName = siteName
    ..type = type;
}

/// Container class for Metadata
class Metadata with BaseMetadataParser, MetadataKeys {
  bool get hasAllMetadata =>
      this.title != null &&
      this.description != null &&
      this.image != null &&
      this.url != null;

  String toString() => toMap().toString();

  Map<String, String> toMap() => {
        MetadataKeys.keyTitle: title,
        MetadataKeys.keyDescription: description,
        MetadataKeys.keyImage: image,
        MetadataKeys.keyUrl: url,
        MetadataKeys.keySiteName: siteName,
        MetadataKeys.keyType: type,
      };

  Map<String, dynamic> toJson() => toMap();

  static fromJson(Map<String, dynamic> json) => Metadata()
    ..title = json[MetadataKeys.keyTitle]
    ..description = json[MetadataKeys.keyDescription]
    ..image = json[MetadataKeys.keyImage]
    ..url = json[MetadataKeys.keyUrl]
    ..siteName = json[MetadataKeys.keySiteName]
    ..type = json[MetadataKeys.keyType];
}
