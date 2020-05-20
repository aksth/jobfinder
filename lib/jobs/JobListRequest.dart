import 'package:jobfinder/placesapi/place_model/place_model.dart';
import 'package:jobfinder/provider/model/provider_model.dart';

class JobListRequest{

  String description;
  Place place;
  ProviderType providerType;

  JobListRequest(this.description, this.place, this.providerType);

}