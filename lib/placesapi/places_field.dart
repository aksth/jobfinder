import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobfinder/http_service.dart';
import 'package:jobfinder/placesapi/place_model/place_model.dart';
import 'package:http/io_client.dart';

class PlacesField extends StatefulWidget {

  final Function(Place) onChanged;
  String initialSearchText;

  PlacesField({Key key, this.onChanged, this.initialSearchText}) : super(key : key);

  @override
  _PlacesFieldState createState() => _PlacesFieldState(onChanged: onChanged, currentSearchText: initialSearchText);
}

class _PlacesFieldState extends State<PlacesField> {

  final FocusNode _focusNode = FocusNode();
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  TextEditingController _placeSearchTextController;
  Timer _debounce;
  bool _autoCompleteDisplayed = false;
  String currentSearchText;
  HttpClient _httpClient = new HttpClient();
  final Function(Place) onChanged;
  final HttpService httpService = HttpService();

  _PlacesFieldState({this.onChanged, this.currentSearchText});

  @override
  void initState() {
    super.initState();
    _placeSearchTextController = new TextEditingController(text: currentSearchText);
    _placeSearchTextController.addListener(_getPlacesForAutoComplete);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        /*this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);*/
      } else {
        if(_autoCompleteDisplayed) {
          _placeSearchTextController.text = "";
          currentSearchText = "";
          this._overlayEntry.remove();
          _autoCompleteDisplayed = false;
        }else if(_placeSearchTextController.text == ""){
          currentSearchText = "";
          onChanged(null);
        }
      }
    });
  }

  _getPlacesForAutoComplete(){
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {

      print(_placeSearchTextController.text);

      if(!(_placeSearchTextController.text == "" || _placeSearchTextController.text == null)) {
        if(currentSearchText == _placeSearchTextController.text){
          return;
        }
        if(_autoCompleteDisplayed) {
          this._overlayEntry.remove();
          _autoCompleteDisplayed = false;
        }

        //create the autocomplete list widget as an overlay
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);

      }else if(_autoCompleteDisplayed){
        if(_placeSearchTextController.text == ""){
          currentSearchText = "";
          onChanged(null);
        }
        this._overlayEntry.remove();
        _autoCompleteDisplayed = false;
      }else if(_placeSearchTextController.text == ""){
        currentSearchText = "";
        onChanged(null);
      }
      print("do nothing.");
      return;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _placeSearchTextController.dispose();
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {

    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    Future<List<Place>> placesFuture = httpService.getPlacesAutoComplete(
        new IOClient(_httpClient), _placeSearchTextController.text);

    return OverlayEntry(
        builder: (context) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: this._layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
              elevation: 4.0,
              //Replace below
              child: FutureBuilder(
                  future: placesFuture,
                  builder: (context, AsyncSnapshot<List<Place>> snapshot) {
                    _autoCompleteDisplayed = true;
                    currentSearchText = _placeSearchTextController.text;
                    if(snapshot.connectionState == ConnectionState.done){
                      if (snapshot.hasData) {
                        List<Place> places = snapshot.data;
                        return ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: places
                              .map(
                                (Place place) => ListTile(
                              title: Text(place.description),
                              onTap: () {
                                onChanged(place);
                                _placeSearchTextController.text = place.description;
                                currentSearchText = place.description;
                                this._overlayEntry.remove();
                                _autoCompleteDisplayed = false;
                              },
                            ),
                          ).toList(),
                        );
                        //return Text(snapshot.data.description);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                    }
                    return ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: <Widget>[
                        ListTile(
                          leading: CircularProgressIndicator(),
                          title: Text("Loading..."),
                        ),
                      ],
                    );
                  }
              ),
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: TextFormField(
        focusNode: this._focusNode,
        controller: _placeSearchTextController,
        decoration: InputDecoration(
            labelText: 'Location'
        ),
      ),
    );
  }
}