import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:jobfinder/jobs/model/job_detail_model.dart';

import 'provider/model/job_list_item_static_model.dart';

class FileService{

  final String _assetsPath = "assets/static_jobs.json";

  Future<String> getStringJsonFromAssets(String assetsPath) async {
    Future<String> data = rootBundle.loadString(assetsPath);
    return data;
  }

  Future<List<JobListItemStatic>> getStaticJobItemList(String description,
      String location, int page, int size) async{

    List<JobListItemStatic> jobListItemList = await getAllJobListItem();
    print("####### static data called !!! ########");
    print("@@@ STATIC called: page: $page");

    if(description != null && description != ""){
      jobListItemList = jobListItemList.where(
        (element) {
          return element.title.toLowerCase().contains(description.toLowerCase());
        }
      ).toList();
    }

    if(location != null && location != ""){
      jobListItemList = jobListItemList.where(
        (element) {
          return element.location.toLowerCase().contains(location.toLowerCase());
        }
      ).toList();
    }

    int start = page * size;
    int end = start + size;

    //check if list size fits in the above range
    if(end <= jobListItemList.length) {
      return jobListItemList.sublist(start, end);
    }else{
      return jobListItemList.sublist(start);
    }

    //return jobListItemList;

  }

  Future<JobDetailModel> getStaticJobDetail(String id) async{
    List<JobDetailModel> jobDetailModelList = await getAllJobListDetail();
    JobDetailModel jobItem = jobDetailModelList.where((item) => item.id == id).toList().first;
    return jobItem;
  }

  Future<List<JobDetailModel>> getAllJobListDetail() async{
    String stringJson = await getStringJsonFromAssets(_assetsPath);
    List<dynamic> body = jsonDecode(stringJson);
    List<JobDetailModel> jobListItemList = body.map(
          (dynamic item) => JobDetailModel.fromJson(item),
    ).toList();
    return jobListItemList;
  }

  Future<List<JobListItemStatic>> getAllJobListItem() async{
    String stringJson = await getStringJsonFromAssets(_assetsPath);
    List<dynamic> body = jsonDecode(stringJson);
    List<JobListItemStatic> jobListItemList = body.map(
          (dynamic item) => JobListItemStatic.fromJson(item),
    ).toList();
    return jobListItemList;
  }


}