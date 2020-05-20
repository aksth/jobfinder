import 'package:jobfinder/jobs/JobListRequest.dart';
import 'package:jobfinder/jobs/model/job_detail_model.dart';
import 'package:jobfinder/jobs/model/job_list_item_model.dart';
import 'package:jobfinder/placesapi/place_model/place_model.dart';
import 'package:jobfinder/provider/model/provider_model.dart';

abstract class Provider{

  Future<List<JobListItem>> getJobList(JobListRequest jobListRequest, int page, int size);

  Future<JobDetailModel> getJobDetail(String id);

}