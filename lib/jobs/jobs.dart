import 'dart:io';

import 'package:http/io_client.dart';
import 'package:jobfinder/http_service.dart';
import 'package:jobfinder/jobs/model/job_detail_model.dart';
import 'package:jobfinder/placesapi/geometry_model/geometry_model.dart';
import 'package:jobfinder/provider/model/provider_model.dart';
import 'package:jobfinder/provider/provider.dart';
import 'package:jobfinder/provider/source/github_provider.dart';
import 'package:jobfinder/provider/source/static_provider.dart';
import 'package:jobfinder/utils/utils.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'JobListRequest.dart';
import 'model/job_list_item_model.dart';

class Jobs{

  HttpService httpService = HttpService();
  HttpClient httpClient = HttpClient();
  IOClient ioClient;
  Utils utils = Utils();
  Provider _provider;
  List<JobListItem> _jobList = [];

  Jobs(){
    ioClient = IOClient(httpClient);
  }

  Future<List<JobListItem>> getJobList(JobListRequest jobListRequest, int page, int size) async{

    _jobList = [];

    if(jobListRequest.place != null){
      Geometry geometry = await httpService.getPlaceGeometry(ioClient, jobListRequest.place.placeId);
      jobListRequest.place.location = geometry.location;
    }

    if(jobListRequest.providerType == ProviderType.ALL){
      await getJobListByProvider(ProviderType.GITHUB, jobListRequest, page, size);
      await getJobListByProvider(ProviderType.STATIC, jobListRequest, page, size);
    }else{
      await getJobListByProvider(jobListRequest.providerType, jobListRequest, page, size);
    }

    populateDateTime();
    sortByDate();
    populateCreatedAtTimeAgo();
    return _jobList;

  }

  Future<List<JobListItem>> getJobListByProvider (ProviderType providerType,
      JobListRequest jobListRequest, int page, int size)async{

    switch(providerType){
      case ProviderType.GITHUB:
        try {
          _provider = GithubProvider();
          List<JobListItem> githubList = await _provider.getJobList(jobListRequest, page, size);
          _jobList = _jobList + githubList;
        }catch(err){
          return [];
        }
        break;
      case ProviderType.STATIC:
        try {
          _provider = StaticProvider();
          List<JobListItem> staticList = await _provider.getJobList(jobListRequest, page, size);
          _jobList = _jobList + staticList;
        }catch(err){
          return [];
        }
        break;
      default:
        return [];
    }

  }

  void populateDateTime(){
    _jobList.forEach((element) {
      element.createdAtDateTime = utils.getDateTimeFromString(element.createdAt);
    });
  }

  void populateCreatedAtTimeAgo(){
    _jobList.forEach((element) {
      element.createdAtTimeAgo = timeago.format(element.createdAtDateTime);
    });
  }

  void sortByDate(){
    _jobList.sort((a, b) => b.createdAtDateTime.compareTo(a.createdAtDateTime));
  }

  Future<JobDetailModel> getJobDetail(ProviderType providerType, String id) async{
    Provider provider;
    if(providerType == ProviderType.GITHUB){
      provider = GithubProvider();
    }else if(providerType == ProviderType.STATIC){
      provider = StaticProvider();
    }
    JobDetailModel jobDetailModel = await provider.getJobDetail(id);
    return jobDetailModel;
  }
}