import 'package:firebase_remote_config/firebase_remote_config.dart';

class GlobalConfig{

  static final GlobalConfig _globalConfig = GlobalConfig._internal();
  String _googleApiKey = "";

  factory GlobalConfig(){
    return _globalConfig;
  }

  GlobalConfig._internal();

  Future initializeGlobalConfig() async{

    //Set Google Places API config
    RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: Duration(hours: 1));
    await remoteConfig.activateFetched();
    String key = remoteConfig.getValue('google_places_api_key').asString();
    if(key == null || key == ""){
      print ("??? Google Places API key NOT found!");
      _googleApiKey = "";
    }else{
      print("Google Places API key fetched!");
      _googleApiKey = key;
    }

  }

  String get googlePlacesAPIKey{
    return _googleApiKey;
  }

}