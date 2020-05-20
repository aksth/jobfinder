import 'package:jobfinder/file_service.dart';
import 'package:jobfinder/jobs/JobListRequest.dart';
import 'package:jobfinder/jobs/model/job_detail_model.dart';
import 'package:jobfinder/jobs/model/job_list_item_model.dart';

import '../provider.dart';
import '../model/job_list_item_static_model.dart';
import '../model/provider_model.dart';

class StaticProvider implements Provider{

  FileService fileService = FileService();

  Future<List<JobListItem>> getJobList(JobListRequest jobListRequest, int page, int size) async{

    List<JobListItem> jobList = [];

    String location;
    if(jobListRequest.place == null){
      location = "";
    }else{
      location = jobListRequest.place.structuredFormatting.mainText;
    }
    List<JobListItemStatic> staticJobList = await fileService.getStaticJobItemList
      (jobListRequest.description, location, page, size);

    staticJobList.forEach((element) {
      jobList.add(
          JobListItem(
              id: element.id,
              createdAt: element.createdAt,
              company: element.company,
              location: element.location,
              title: element.title,
              companyLogo: element.companyLogo,
              providerType: ProviderType.STATIC
          )
      );
    });

    return jobList;

  }

  Future<JobDetailModel> getJobDetail(String id) async{
    JobDetailModel jobDetailModel = await fileService.getStaticJobDetail(id);
    return jobDetailModel;
  }

}