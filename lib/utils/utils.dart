import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Utils{

  DateTime getDateTimeFromString(String dateString){
    var stringSplit = dateString.split(" ");
    var timeSplit = stringSplit[3].split(":");

    int month;
    switch(stringSplit[1]){
      case 'Jan':
        month = 1;
        break;
      case 'Feb':
        month = 2;
        break;
      case 'Mar':
        month = 3;
        break;
      case 'Apr':
        month = 4;
        break;
      case 'May':
        month = 5;
        break;
      case 'Jun':
        month = 6;
        break;
      case 'Jul':
        month = 7;
        break;
      case 'Aug':
        month = 8;
        break;
      case 'Sep':
        month = 9;
        break;
      case 'Oct':
        month = 10;
        break;
      case 'Nov':
        month = 11;
        break;
      case 'Dec':
        month = 12;
        break;
      default:
        month = 0;
        break;
    }

    int day = int.parse(stringSplit[2]);
    int year = int.parse(stringSplit[5]);
    int hour = int.parse(timeSplit[0]);
    int minute = int.parse(timeSplit[1]);
    int second = int.parse(timeSplit[2]);

    DateTime dateTime = new DateTime.utc(year, month, day, hour, minute, second);

    return dateTime;
  }

  Widget getCompanyLogo(String companyLogo){
    if(companyLogo == null || companyLogo == ""){
      return CircleAvatar(
        backgroundImage: AssetImage('assets/company_logo_default.png'),
        backgroundColor: Colors.white,
      );
    }else {
      return CachedNetworkImage(
        width: 40,
        height: 40,
        fit: BoxFit.fitHeight,
        imageUrl: companyLogo,
        placeholder: (BuildContext context, String url) {
          return CircularProgressIndicator();
        },
        errorWidget: (BuildContext context, String url, dynamic error) {
          return CircleAvatar(
            backgroundImage: AssetImage('assets/company_logo_default.png'),
            backgroundColor: Colors.white,
          );
        },
      );
    }
  }

  Widget getCompanyLogoForDetailView(String companyLogo){
    if(companyLogo == null || companyLogo == ""){
      return Image(
        width: 120,
          fit: BoxFit.fitWidth,
        image: AssetImage('assets/company_logo_default.png')
      );
    }else {
      return CachedNetworkImage(
        width: 120,
        fit: BoxFit.fitWidth,
        imageUrl: companyLogo,
        placeholder: (BuildContext context, String url) {
          return CircularProgressIndicator();
        },
        errorWidget: (BuildContext context, String url, dynamic error) {
          return CircleAvatar(
            backgroundImage: AssetImage('assets/company_logo_default.png'),
            backgroundColor: Colors.white,
          );
        },
      );
    }
  }

}