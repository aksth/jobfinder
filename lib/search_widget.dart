import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/placesapi/place_model/place_model.dart';
import 'package:jobfinder/placesapi/places_field.dart';
import 'package:jobfinder/provider/model/provider_model.dart';
import 'package:jobfinder/provider/providers_dropdown.dart';

class SearchWidget extends StatefulWidget {

  Function(String, Place, ProviderType) onSubmit;
  String initJobDescription;
  Place initPlace;
  ProviderType initProviderType;

  SearchWidget({Key key, this.onSubmit, this.initJobDescription, this.initPlace, this.initProviderType}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState(onSubmit: onSubmit,
      jobDescription: initJobDescription, place: initPlace, providerType: initProviderType);
}

class _SearchWidgetState extends State<SearchWidget> {

  String jobDescription;
  Place place;
  ProviderType providerType;
  Function(String, Place, ProviderType) onSubmit;
  TextEditingController _jobDescriptionController;

  _SearchWidgetState({this.onSubmit, this.jobDescription, this.place, this.providerType});

  @override
  void initState() {
    super.initState();
    _jobDescriptionController = new TextEditingController(text: jobDescription);
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return SingleChildScrollView(child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _jobDescriptionController,
            decoration: const InputDecoration(
              labelText: 'Enter job description',
            ),
            onChanged: (text) {
              jobDescription = text;
            }
          ),
          PlacesField(
            initialSearchText: place != null ? place.description : "",
            onChanged: (Place newValue){
              place = newValue;
            },
          ),
          SizedBox(
              width: 200.0,
              child: ProvidersDropdown(
                initialProvider: providerType,
                onChanged: (ProviderType newValue){
                  providerType = newValue;
                },
              ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  onSubmit(jobDescription, place, providerType);
                }
              },
              child: Text('Search'),
            ),
          ),
        ],
      ),
    ));
  }
}
