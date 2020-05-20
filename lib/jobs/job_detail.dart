import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:jobfinder/jobs/model/job_detail_model.dart';
import 'package:jobfinder/provider/model/provider_model.dart';
import 'package:jobfinder/provider/provider.dart';
import 'package:jobfinder/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'jobs.dart';
import 'model/job_list_item_model.dart';

class JobDetail extends StatefulWidget {
  JobListItem jobItem;

  JobDetail({Key key, this.jobItem}) : super(key: key);

  @override
  _JobDetailState createState() => _JobDetailState(jobItem: jobItem);
}

class _JobDetailState extends State<JobDetail> {

  JobListItem jobItem;
  Future<JobDetailModel> jobDetailModel;
  Provider provider;
  Jobs jobs = Jobs();
  Utils utils = Utils();

  _JobDetailState({this.jobItem});

  @override
  void initState() {
    super.initState();
    jobDetailModel = jobs.getJobDetail(jobItem.providerType, jobItem.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(jobItem.title),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                FutureBuilder(
                    future: jobDetailModel,
                    builder: (context, AsyncSnapshot<JobDetailModel> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          JobDetailModel jobDetailModel = snapshot.data;
                          return Column(
                            children: <Widget>[
                              Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(jobItem.title),
                                      subtitle: Text("Job Title"),
                                    ),
                                    ListTile(
                                      trailing: Container(
                                        width: 120.0,
                                        child: utils.getCompanyLogoForDetailView(jobItem.companyLogo),
                                      ),
                                      title: Text("${jobItem.company}"),
                                      subtitle: Text("Company"),
                                    ),
                                    ListTile(
                                      title: Text(jobDetailModel.location),
                                      subtitle: Text("Location"),
                                    ),
                                    ListTile(
                                      title: Text(DateFormat('dd MMM, yyyy, hh:mm a').format(jobItem.createdAtDateTime)),
                                      subtitle: Text("Created Date"),
                                    ),
                                    ListTile(
                                      title: Text(jobDetailModel.type),
                                      subtitle: Text("Type"),
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: new EdgeInsets.fromLTRB(18.0, 20.0, 20.0, 0.0),
                                      alignment: Alignment(-1.0, -1.0),
                                      child:
                                      Text(
                                        "Job Description",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),

                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                                      child:HtmlWidget(
                                        jobDetailModel.description,
                                        onTapUrl: (url) {
                                          _launchURL(url);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: new EdgeInsets.fromLTRB(18.0, 20.0, 20.0, 0.0),
                                      alignment: Alignment(-1.0, -1.0),
                                      child:
                                      Text(
                                        "How to apply?",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),

                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                                      child: HtmlWidget(
                                        jobDetailModel.howToApply,
                                        onTapUrl: (url) {
                                          _launchURL(url);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              jobDetailModel.companyUrl != "" ?
                                Card(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: new EdgeInsets.fromLTRB(18.0, 20.0, 20.0, 0.0),
                                        alignment: Alignment(-1.0, -1.0),
                                        child:
                                          Text(
                                            "Company Website",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                            ),
                                          ),

                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                                        child: HtmlWidget(
                                          '<a href="${jobDetailModel.companyUrl}">${jobDetailModel.companyUrl}</a>',
                                          onTapUrl: (url) {
                                            _launchURL(url);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                              Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                                      child: ListTile(
                                        subtitle: Text(jobItem.providerType.name),
                                        title: Text(
                                          "Job Listing Provider",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: new EdgeInsets.fromLTRB(18.0, 0.0, 20.0, 0.0),
                                      alignment: Alignment(-1.0, -1.0),
                                      child:
                                      Text(
                                        "Job URL",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),

                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                                      child: HtmlWidget(
                                        '<a href="${jobDetailModel.url}">${jobDetailModel.url}</a>',
                                        onTapUrl: (url) {
                                          _launchURL(url);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                      }
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ListTile(
                              leading: CircularProgressIndicator(),
                              title: Text("Loading..."),
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ));
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
