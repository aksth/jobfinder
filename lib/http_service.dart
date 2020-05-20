
import 'package:jobfinder/global_config.dart';
import 'package:jobfinder/jobs/model/job_detail_model.dart';
import 'package:jobfinder/placesapi/geometry_model/geometry_model.dart';
import 'package:jobfinder/placesapi/geometry_model/location_model.dart';
import 'package:jobfinder/placesapi/geometry_model/place_geometry_response_model.dart';
import 'package:jobfinder/placesapi/place_model/place_model.dart';
import 'package:http/http.dart' as http;
import 'package:jobfinder/placesapi/place_model/placesapi_response_model.dart';
import 'dart:convert';
import 'provider/model/job_list_item_github_model.dart';

class HttpService{

  GlobalConfig globalConfig = GlobalConfig();

  final String _placesBase = "https://maps.googleapis.com/maps/api/place";
  String _apiKey = "";

  HttpService(){
    _apiKey = globalConfig.googlePlacesAPIKey;
  }

  Future<List<Place>> getPlacesAutoComplete(http.Client client, String input) async{
    http.Response res = await client.get(_placesBase+"/autocomplete/json?"
        "key="+_apiKey+"&input="+input);
    print("####### http called !!! ########");
    if (res.statusCode == 200) {
      PlacesApiResponse placesApiRespoonse =
      PlacesApiResponse.fromJson(json.decode(res.body));
      print(placesApiRespoonse.status);
      print(placesApiRespoonse.error_message);
      return placesApiRespoonse.predictions;
    }else{
      throw "Can't get posts.";
    }
  }

  Future<Geometry> getPlaceGeometry(http.Client client, String placeId) async{
    http.Response res = await client.get(_placesBase+"/details/json?"
        "key="+_apiKey+"&place_id="+placeId);
    print("####### http called !!! ########");
    if (res.statusCode == 200) {
      PlaceGeometryResponse placeGeometryResponse =
      PlaceGeometryResponse.fromJson(json.decode(res.body));
      return placeGeometryResponse.result.geometry;
    }else{
      throw "Can't get the geometry.";
    }
  }

  Future<List<JobListItemGithub>> getGithubJobs(http.Client client, description,
      Location location,
      int page, int size) async{

    if(50 % size != 0){
      throw "Invalid size for github's api.";
    }

    //TODO: when the actual size of api (i.e. 50) is divided by size, the modulo should be zero
    //This should be handled accordingly, eg - validations, etc.
    //But it is ignored for now.

    //First see into how many parts the actual size of github (i.e 50) can
    // be divided if we take the application's internal size
    int noOfParts = 50 ~/ size;

    //Use this page to fetch the github api
    int actualPageToFetch = page ~/ noOfParts;

    String url = "https://jobs.github.com/positions.json?page=$actualPageToFetch";
    if(description != ""){
      url = "$url&description=$description";
    }
    if(location != null){
      url = "$url&lat=${location.lat}&long=${location.lng}";
    }

    http.Response res = await client.get(url);
    print("####### http called !!! ########");
    print("@@@ GITHUB called: page: $page");
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      if(body.length == 0){
        throw "No jobs found for the given params.";
      }
      List<JobListItemGithub> jobListItemList = body.map(
            (dynamic item) => JobListItemGithub.fromJson(item),
      ).toList();

      //Use this page to filter the list after fetching
      int actualPageAfterFetching = page % noOfParts;

      int start = actualPageAfterFetching * size;
      int end = start + size;

      //check if list size fits in the above range
      if(end <= jobListItemList.length){
        return jobListItemList.sublist(start, end);
      }else{
        return jobListItemList.sublist(start);
      }
      //return jobListItemList;
    }else{
      throw "Can't get the jobs from Github.";
    }

  }

  Future<JobDetailModel> getJobDetailGithub(http.Client client, String id) async{

    String url = "https://jobs.github.com/positions/$id.json?markdown=false";

    http.Response res = await client.get(url);
    print("####### http called !!! ########");

    if (res.statusCode == 200) {
      JobDetailModel jobDetail =
      JobDetailModel.fromJson(json.decode(res.body));
      jobDetail.companyUrl == null ? jobDetail.companyUrl = "" : jobDetail.companyUrl;
      return jobDetail;
    }else{
      throw "Can't get the job detail.";
    }

  }

}