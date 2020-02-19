enum MetadataProperty { title, description, image }

String enumToString(MetadataProperty m) {
  return m.toString().split('.')[1];
}

MetadataProperty stringToEnum(String s) {
  switch (s) {
    case 'title':
      {
        return MetadataProperty.title;
      }
      break;

    case 'description':
      {
        return MetadataProperty.description;
      }
      break;

    case 'image':
      {
        return MetadataProperty.image;
      }
      break;

    default:
      {
        return null;
      }
      break;
  }
}
