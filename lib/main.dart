import 'package:flutter/material.dart';
import 'package:jobfinder/global_config.dart';
import 'package:jobfinder/jobs/JobListRequest.dart';
import 'package:jobfinder/jobs/job_detail.dart';
import 'package:jobfinder/jobs/model/load_next_status_model.dart';
import 'package:jobfinder/provider/model/provider_model.dart';
import 'package:jobfinder/search_widget.dart';
import 'package:jobfinder/utils/utils.dart';
import 'jobs/job_service.dart';
import 'jobs/model/job_list_item_model.dart';
import 'jobs/jobs.dart';
import 'dart:math' as math;

import 'jobs/model/loading_status.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future _initGlobalConfig = GlobalConfig().initializeGlobalConfig();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/app_logo.png'),
            backgroundColor: Colors.transparent,
          ),
          title: Text('Job Finder'),
        ),
        body: FutureBuilder(
          future: _initGlobalConfig,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return HomePage();
            }
            return SizedBox.shrink();
          }
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  JobListRequest jobListRequest = JobListRequest("", null, ProviderType.ALL);
  ScrollController _scrollController;
  Jobs jobs;
  int currentPage = 0;
  JobService jobService = JobService();
  double _prevScrollPos = 0.0;
  final snackBarEmptyFetched = SnackBar(content: Text('No more jobs to fetch.'));
  Utils utils = Utils();

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
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    jobService.loadNext(jobListRequest, currentPage, pageSize);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    jobService.dispose();
    super.dispose();
  }

  void _fetchJobListFromSearch(){
    setState(() {
      currentPage = 0;
      jobService = JobService();
      jobService.loadFromSearch(jobListRequest, currentPage, pageSize);
    });
  }

  _scrollListener() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScrollPos = _scrollController.position.pixels;
    double delta = 100.0;

    if (maxScroll - currentScrollPos <= delta && _prevScrollPos - currentScrollPos < 0) {
      currentPage++;
      jobService.loadNext(jobListRequest, currentPage, pageSize)
          .then(
              (LoadNextStatus loadNextStatus) {
            if(!loadNextStatus.fetched){
              currentPage--;
            }
            if(loadNextStatus.fetched && loadNextStatus.emptyList){
              currentPage--;
              print("no more jobs to show...");
            }
          }
      )
          .catchError(
              (error) {
            currentPage--;
          });
    }

    _prevScrollPos = currentScrollPos;

    /*if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        print("###reach the bottom");
        _service.loadNext();
      });
    }

    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        print("###reach the top");
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return
      CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          makeHeader(),
          /// items list
          StreamBuilder(
            stream: jobService.items,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                final items = snapshot.data;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (_, int index) {
                      JobListItem jobListItem = items[index];
                      return getCardFromJobListItem(jobListItem);
                    },
                    childCount: items.length,
                  ),
                );
              } else {
                return SliverFillRemaining(
                  child: Card(
                    child: ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text("Loading..."),
                    ),
                  ),
                );
              }
            },
          ),

          StreamBuilder(
            stream: jobService.isLoadingNext,
            builder: (_, snapshot) {
              LoadingStatus status;
              if(snapshot.data != null){
                status = snapshot.data;
              }
              if (status != null && status.loading == true) {
                return SliverToBoxAdapter(
                  child: Container(
                    // color: Colors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Card(
                      child: ListTile(
                        leading: CircularProgressIndicator(),
                        title: Text("Loading..."),
                      ),
                    ),
                  ),
                );
              } else {
                if(status != null && status.emptyList == true){
                  WidgetsBinding.instance.addPostFrameCallback((_){
                    Scaffold.of(context).showSnackBar(snackBarEmptyFetched);
                  });
                  print("No more jobs to show.");
                }
                return SliverToBoxAdapter(
                  child: Container(height: 0),
                );
              }
            },
          ),

          SliverToBoxAdapter(
            child: SafeArea(
              child: Container(),
              bottom: true,
              top: false,
            ),
          )
        ],
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
                      _fetchJobListFromSearch();
                    },
                  ),
                )
            )
        ),
      ),
    );
  }

  Widget getCardFromJobListItem(JobListItem jobItem){
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
          leading: ClipOval(
            child: utils.getCompanyLogo(jobItem.companyLogo),
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