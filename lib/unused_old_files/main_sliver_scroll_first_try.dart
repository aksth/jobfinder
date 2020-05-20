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
import 'dart:math' as math;

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
  int currentPage = 0;
  int sizeOfList = 0;
  bool fetchMoreListLoading = false;
  List<Widget> jobListWidget;

  //Since github returns page with size 50, we use this number to again re-size the page
  //returned by the github according to our needs.
  //So, this number must be such that github's size (50) is divisible by this pageSize below,
  //This rule should be followed because github's api doesn't provide us with our custom size.
  //e.g, 1, 2, 5, 10, 25, 50 is allowed, but 20, 30 is not allowed. If unallowed value entered,
  //then github api will be ignored (N.B - This could be prevented if we use multiple calls to the
  //github api to get a single instance of a list. This is not implemented as of now.)
  final pageSize = 25;

  @override
  void initState() {
    super.initState();
    jobs = Jobs();
    jobListItemList = jobs.getJobList(jobListRequest, currentPage, pageSize);
  }

  void _fetchJobList(){
    setState(() {
      currentPage = 0;
      fetchMoreListLoading = false;
      jobs = Jobs();
      jobListItemList = jobs.getJobList(jobListRequest, currentPage, pageSize);
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
      body: FutureBuilder(
          future: jobListItemList,
          builder: (context, AsyncSnapshot<List<JobListItem>> snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if (snapshot.hasData) {
                CustomScrollView customScrollView = getCustomScrollViewForJobList(context, snapshot);
                return customScrollView;
              } else if (snapshot.hasError) {
                CustomScrollView customScrollView = getErrorCustomScrollViewForJobList(context, snapshot);
                return customScrollView;
              }
            }
            CustomScrollView customScrollView = getLoadingCustomScrollViewForJobList(context, snapshot);
            return customScrollView;
          }
      ),
    );
  }

  SliverPersistentHeader makeHeader() {
    return SliverPersistentHeader(
      floating: true,
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 0.0,
        maxHeight: 275.0,
        child: Container(
            color: Colors.white,
            child: Center(
                child:
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SearchWidget(
                    initJobDescription: "",
                    initProviderType: ProviderType.ALL,
                    onSubmit: (jobDescription, place, providerType){
                      jobListRequest = JobListRequest(jobDescription, place, providerType);
                      _fetchJobList();
                    },
                  ),
                )
            )
        ),
      ),
    );
  }

  CustomScrollView getCustomScrollViewForJobList(BuildContext context, AsyncSnapshot snapshot) {

    List<JobListItem> jobList = snapshot.data;
    jobListWidget = generateListFromSnapshot(jobList);
    sizeOfList = jobListWidget.length;

    return CustomScrollView(
      slivers: <Widget>[
        makeHeader(),
        // Yes, this could also be a SliverFixedExtentList. Writing
        // this way just for an example of SliverList construction.
        SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            // To convert this infinite list to a list with three items,
            // uncomment the following line:
            // if (index > 3) return null;
            /*if(fetchMoreListLoading){
              return null;
            }*/
            print("###list.length $sizeOfList");
            print("###index $index");
            if(index <= (sizeOfList-1)) {
              return jobListWidget[index];
            } else if(!fetchMoreListLoading){
              fetchMoreListLoading = true;
              addNextListToExistingList()
                  .then((success) => print(success ? '###new list added!' : 'failed to add list!'))
                  .catchError((error) => print(error))
                  .whenComplete(() => fetchMoreListLoading = false);
              return Text("New List Added");
            }else{
              return SizedBox.shrink();
            }
            //return Container(color: getRandomColor(), height: 150.0);
          },
          //childCount: sizeOfList,
          ),
        ),
      ],
    );

  }

  Future<bool> addNextListToExistingList() async{
    List<JobListItem> nextJobList = await jobs.getJobList(jobListRequest, currentPage, pageSize);
    List<Widget> moreJobListWidget = generateListFromSnapshot(nextJobList);
    jobListWidget = jobListWidget + moreJobListWidget;
    sizeOfList = jobListWidget.length;
    return true;
  }

  List<Widget> generateListFromSnapshot(List<JobListItem> list){

    List<JobListItem> jobList = list;
    List<Widget> jobListWidget = jobList.map(
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
    ).toList();

    return jobListWidget;

  }

  getRandomColor(){
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  CustomScrollView getErrorCustomScrollViewForJobList(BuildContext context, AsyncSnapshot snapshot) {

    return CustomScrollView(
      slivers: <Widget>[
        makeHeader(),
        // Yes, this could also be a SliverFixedExtentList. Writing
        // this way just for an example of SliverList construction.
        SliverList(
          delegate: SliverChildListDelegate([
            Container(child: Text("${snapshot.error}")),
          ]),
        ),
      ],
    );

  }

  CustomScrollView getLoadingCustomScrollViewForJobList(BuildContext context, AsyncSnapshot snapshot) {

    return CustomScrollView(
      slivers: <Widget>[
        makeHeader(),
        // Yes, this could also be a SliverFixedExtentList. Writing
        // this way just for an example of SliverList construction.
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              child:Card(child:
                ListTile(
                    leading: CircularProgressIndicator(),
                    title: Text("Loading..."),
                ),
              ),
            ),
          ]),
        ),
      ],
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


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {

  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent){
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }

}