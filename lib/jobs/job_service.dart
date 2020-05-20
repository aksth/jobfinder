import 'dart:async';

import 'package:jobfinder/jobs/JobListRequest.dart';
import 'package:jobfinder/jobs/model/load_next_status_model.dart';
import 'package:jobfinder/jobs/model/loading_status.dart';
import 'package:jobfinder/provider/model/provider_model.dart';

import 'jobs.dart';
import 'model/job_list_item_model.dart';

class JobService{

  final _itemsController = StreamController<List<JobListItem>>();
  final _loadNextController = StreamController<LoadingStatus>();
  final _jobs = Jobs();

  get items => _itemsController.stream;
  get isLoadingNext => _loadNextController.stream;

  List<JobListItem> _current = [];
  int page = 0;

  Future<LoadNextStatus> loadNext(JobListRequest jobListRequest, int currentPage, int pageSize) async {
    //The scroll event may fire multiple times for the same case,
    //So we prevent fetching same data multiple times for a case
    if((currentPage != 0) && ((page+1) != currentPage)){
      return LoadNextStatus(false, true);
    }
    if(_current.length > (currentPage * pageSize * (ProviderType.values.length - 1))){
      return LoadNextStatus(false, true);
    }
    _loadNextController.add(LoadingStatus(true, false));
    List<JobListItem> jobListItemList = await _jobs.getJobList(jobListRequest, currentPage, pageSize);
    if(jobListItemList.length == 0){
      _loadNextController.add(LoadingStatus(false, true));
      return LoadNextStatus(true, true);
    }
    page = currentPage;
    _current.addAll(jobListItemList);
    _itemsController.add(_current);
    _loadNextController.add(LoadingStatus(false, false));
    return LoadNextStatus(true, false);
  }

  Future<bool> loadFromSearch(JobListRequest jobListRequest, int currentPage, int pageSize) async {
    _current = [];

    //below line need to show that there is no data just after tapping search button.
    //this will allow us to show loading icon
    _itemsController.add(_current);

    page = 0;
    _loadNextController.add(LoadingStatus(true, false));
    List<JobListItem> jobListItemList = await _jobs.getJobList(jobListRequest, currentPage, pageSize);
    page = currentPage;
    _current.addAll(jobListItemList);
    _itemsController.add(_current);
    _loadNextController.add(LoadingStatus(false, false));
    return true;
  }

  void dispose() {
    _itemsController.close();
    _loadNextController.close();
  }

}