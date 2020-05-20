import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/http_service.dart';
import 'package:jobfinder/jobs/JobListRequest.dart';
import 'package:jobfinder/jobs/job_detail.dart';
import 'package:jobfinder/jobs/jobs.dart';
import 'package:jobfinder/jobs/model/job_list_item_model.dart';
import 'package:jobfinder/provider/model/provider_model.dart';
import 'package:jobfinder/search_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Job Finder'),
    );
  }
}

class HomePage extends StatefulWidget {

  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<JobListItem>> jobListItemList;
  HttpService httpService = HttpService();
  HttpClient httpClient = new HttpClient();
  JobListRequest jobListRequest = JobListRequest("", null, ProviderType.ALL);
  Jobs jobs;

  @override
  void initState() {
    super.initState();
    jobs = Jobs();
    jobListItemList = jobs.getJobList(jobListRequest, 0, 10);
  }

  void _fetchJobList(){
    setState(() {
      jobs = Jobs();
      jobListItemList = jobs.getJobList(jobListRequest, 0, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/app_logo.png'),
          backgroundColor: Colors.transparent,
        ),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child:SearchWidget(
                      initJobDescription: "",
                      initProviderType: ProviderType.ALL,
                      onSubmit: (jobDescription, place, providerType){
                        jobListRequest = JobListRequest(jobDescription, place, providerType);
                        _fetchJobList();
                      },
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: jobListItemList,
              builder: (context, AsyncSnapshot<List<JobListItem>> snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  if (snapshot.hasData) {
                    List<JobListItem> jobList = snapshot.data;
                    return Expanded(child:
                      ListView(
                        children: jobList.map(
                            (JobListItem jobItem) {
                              return Card(
                                  child: ListTile(
                                    title: Text(jobItem.title),
                                    subtitle: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(jobItem.company.length > 20 ?
                                            '${jobItem.company.substring(0,20)}...' : jobItem.company),
                                            Text(jobItem.location.length > 15 ?
                                            '${jobItem.location.substring(0,15)}...' : jobItem.location)
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(jobItem.createdAtTimeAgo),
                                            Text(jobItem.providerType.name),
                                          ],
                                        )
                                      ],
                                    ),
                                    leading: CircleAvatar(
                                      backgroundImage: getCompanyLogo(jobItem.companyLogo),
                                      backgroundColor: Colors.white,
                                    ),
                                    onTap:() => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => JobDetail(
                                          jobItem: jobItem,
                                        ),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(15.0,10.0,15.0,10.0),
                                  )
                              );
                            },
                        ).toList(),
                      )
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                }
                return CircularProgressIndicator();
              }
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider getCompanyLogo(String companyLogo){
    ImageProvider imageProvider;
    if(companyLogo == null || companyLogo == ""){
      imageProvider = AssetImage('assets/company_logo_default.png');
    }else{
      try {
        imageProvider = Image
            .network(companyLogo)
            .image;
      }catch(err){
        imageProvider = AssetImage('assets/company_logo_default.png');
      }
    }
    return imageProvider;
  }

}
