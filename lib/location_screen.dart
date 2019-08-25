import 'dart:async';

import 'package:agin_gaz/shared/dimens.dart';
import 'package:agin_gaz/shared/places/places.dart';
import 'package:agin_gaz/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import "package:google_maps_webservice/places.dart";
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class LocationScreen extends StatefulWidget {
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<LocationScreen>
    with TickerProviderStateMixin {
  MapController _mapController = MapController();
  List<Marker> _markers = List();
  Geolocator _geolocator = Geolocator();
  StreamSubscription<Position> _positionStream;
  bool _locationBtnPressed = true;
  Position _currentPos;
  AnimationController _opacityController;
  Animation _opactityAnimation;
  AutoCompleteTextField searchTextField;
  //final _places = GoogleMapsPlaces(apiKey: Strings.MAP_API_ANDROID_KEY);
  List<Map<String, dynamic>> _placesFound = List();
  GlobalKey<AutoCompleteTextFieldState<Map<String, dynamic>>> _autoCompleteKey =
      new GlobalKey();
  final _width = Dimens.WIDTH, _height = Dimens.HEIGHT;

  Places _places;

  var _adr;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    /*gmap.Marker m2 = gmap.Marker(
        markerId: gmap.MarkerId('2'),
        position: gmap.LatLng(34.733937, 10.751812),
        icon: gmap.BitmapDescriptor.defaultMarkerWithHue(
            gmap.BitmapDescriptor.hueYellow));
    markers.add(m2);
    markers.add(gmap.Marker(
        markerId: gmap.MarkerId('3'),
        position: gmap.LatLng(34.759812, 10.778937),
        icon: gmap.BitmapDescriptor.defaultMarkerWithHue(
            gmap.BitmapDescriptor.hueYellow)));

    _mapView.setMarkers(<Marker>[
      Marker('1', 'Agile', 34.733937, 10.751812, color: Colors.yellowAccent),
      Marker('2', 'Agile', 34.759812, 10.778937, color: Colors.yellowAccent),
    ]);
*/

    _geolocator.checkGeolocationPermissionStatus();
    _positionStream = _geolocator
        .getPositionStream(LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    ))
        .listen((pos) {
      if (pos != null) {
        print('position is: ${pos.latitude}, ${pos.longitude}');
        Marker m = Marker(
            width: 17.5,
            height: 17.5,
            point: LatLng(pos.latitude, pos.longitude),
            builder: (context) {
              return Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.cyan),
                    ),
                  ),
                ),
              );
            });
        _currentPos = pos;
        _places = Places(pos);
        if (_locationBtnPressed)
          _mapController.move(LatLng(pos.latitude, pos.longitude),
              _mapController.zoom <= 6.5 ? 17.5 : _mapController.zoom);
        setState(() {
          if (_markers.isNotEmpty) _markers.removeAt(0);
          _markers.insert(0, m);
        });
      } else {
        print("pos is numlll");
      }
    });

    _opacityController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _opactityAnimation = Tween(begin: 1.0, end: .6).animate(
        CurvedAnimation(parent: _opacityController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _flutterMap(),
            AnimatedBuilder(
              animation: _opactityAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _opactityAnimation.value,
                  child: Padding(
                    padding: EdgeInsets.only(top: _height * .05),
                    child: Stack(
                      children: <Widget>[
                        _searchBox(),
                        _trackBtn(),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _flutterMap() {
    return Listener(
      onPointerDown: (pointer) {
        _locationBtnPressed = false;
        _changeTrackerConfig();
        _opacityController.forward();
      },
      onPointerUp: (pointer) {
        setState(() {
          _opacityController.reverse();
        });
      },
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
            center: LatLng(33.8869, 9.5375), zoom: 6.5, maxZoom: 20.0),
        layers: [
          TileLayerOptions(
              zoomReverse: true,
              maxZoom: 20.0,
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/djamiirr/cjf46ttfy11rx2rs5jjf4ye82/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGphbWlpcnIiLCJhIjoiY2pmNDZmMm1lMWFhaDJ4cXgxaHppeWdpaSJ9.5ICqofr7rawa9uo2FyvsXg",
              additionalOptions: {
                'accessToken':
                    "pk.eyJ1IjoiZGphbWlpcnIiLCJhIjoiY2pzeGo1anR6MHB5ejQzcHZyYjN0eTZ2YiJ9.1ILoCvRgnLGf_AIOaus8aQ",
                'id': "mapbox.satellite"
              }),
          MarkerLayerOptions(markers: _markers)
        ],
      ),
    );
  }

  void _changeTrackerConfig() {
    setState(() {
      if (_locationBtnPressed)
        _mapController.move(LatLng(_currentPos.latitude, _currentPos.longitude),
            _mapController.zoom <= 6.5 ? 17.5 : _mapController.zoom);
    });
  }

  Widget _trackBtn() {
    return Align(
        alignment: Alignment.bottomRight,
        child: Container(
            width: 50.0,
            height: 50.0,
            margin: EdgeInsets.only(bottom: 20.0, right: 20.0),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
            child: InkWell(
              onTap: () {
                _locationBtnPressed = !_locationBtnPressed;
                _changeTrackerConfig();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: _locationBtnPressed ? Colors.white30 : Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                  child: Transform.rotate(
                    angle: 0.785398,
                    child: Icon(
                      Icons.navigation,
                      color:
                          _locationBtnPressed ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ),
            )));
  }

  Widget _searchBox() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _width * .025),
        child: AutoCompleteTextField<Map<String, dynamic>>(
            itemSubmitted: (item) => print(item),
            key: _autoCompleteKey,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: Colors.white24,
              filled: true,
              hintText: _adr,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.yellowAccent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    BorderSide(color: Colors.yellowAccent.withOpacity(.7)),
              ),
            ),
            suggestions: _placesFound,
            itemBuilder: (context, item) {
              return InkWell(
                onTap: () {
                  _mapController.move(
                      item['latlng'],
                      _mapController.zoom);
                  _autoCompleteKey.currentState.setState(() {
                    _adr = item['title'].toString();
                    _placesFound.clear();
                  });
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
                  child: Text(item['title']),
                ),
              );
            },
            itemSorter: (a, b) {
              return a['title'].toString().compareTo(b['title'].toString());
            },
            textChanged: (txt) {
              print(txt);
              _places.getPlace(txt).then((place){
                if (place.isNotEmpty) {
                  print("value ${place[0].address}");
                  _placesFound.clear();
                  for (Place place in place) {
                    Map<String, dynamic> found = Map();
                    found['title'] = place.address;
                    found['latlng'] = LatLng(place.lng, place.lat);
                    _autoCompleteKey.currentState.setState(() {
                      setState(() {
                        _placesFound.add(found);
                      });
                    });

                  }
                }
              });
            },
            itemFilter: (item, query) {
              return true;
            }),
      ),
    );
  }
}
