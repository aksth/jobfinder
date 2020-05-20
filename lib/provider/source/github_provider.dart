import 'dart:io';

import 'package:http/io_client.dart';
import 'package:jobfinder/jobs/JobListRequest.dart';
import 'package:jobfinder/jobs/model/job_detail_model.dart';
import 'package:jobfinder/jobs/model/job_list_item_model.dart';
import 'package:jobfinder/placesapi/geometry_model/location_model.dart';
import 'package:jobfinder/provider/provider.dart';

import '../../http_service.dart';
import '../model/job_list_item_github_model.dart';
import '../model/provider_model.dart';

class GithubProvider implements Provider{

  HttpService httpService = HttpService();
  HttpClient httpClient = HttpClient();
  IOClient ioClient;

  GithubProvider(){
    ioClient = IOClient(httpClient);
  }

  Future<List<JobListItem>> getJobList(JobListRequest jobListRequest, int page, int size) async{

    List<JobListItem> jobList = [];

    Location location;
    if(jobListRequest.place != null){
      location = jobListRequest.place.location;
    }

    List<JobListItemGithub> githubJobList = await httpService.getGithubJobs(
        ioClient, jobListRequest.description, location, page, size);

    githubJobList.forEach((element) {
      jobList.add(
        JobListItem(
          id: element.id,
          createdAt: element.createdAt,
          company: element.company,
            location: element.location,
            title: element.title,
            companyLogo: element.companyLogo,
            url: element.url,
            providerType: ProviderType.GITHUB
        )
      );
    });

    return jobList;
  }

  Future<JobDetailModel> getJobDetail(String id) async{
    JobDetailModel jobDetailModel = await httpService.getJobDetailGithub(ioClient, id);
    return jobDetailModel;
  }

}