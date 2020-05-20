enum ProviderType{
  GITHUB,
  STATIC,
  ALL
}

extension ProvderExtension on ProviderType{
  String get name{
    switch(this){
      case ProviderType.GITHUB:
        return 'GitHub';
      case ProviderType.STATIC:
        return 'Static Data';
      case ProviderType.ALL:
        return 'All Providers';
      default:
        return null;
    }
  }
}