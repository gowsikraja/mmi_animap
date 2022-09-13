import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'dart:math' as math;

class MmiAnimarker {
  MapmyIndiaMapController mmiController;
  TickerProvider vsync;
  AnimationController? controller;
  late Animation animation;

  MmiAnimarker(this.mmiController, this.vsync);

  ///[oldLatLng] this will used to save previous location for smooth animation
  LatLng? oldLatLng;

  bool isCarAnimating = false;

  Future<void> addImageFromAsset(String imageName, String assetPath) async {
    final ByteData bytes = await rootBundle.load(assetPath);
    final Uint8List list = bytes.buffer.asUint8List();
    return await mmiController.addImage(imageName, list);
  }

  Future<Symbol> addAnimarkerSymbol(
      String imageName, String assetPath, SymbolOptions symbolOptions) async {
    await addImageFromAsset(imageName, assetPath);
    oldLatLng = symbolOptions.geometry;
    return await mmiController.addSymbol(symbolOptions);
  }

  animateMarker(LatLng newLatLng, Symbol markerSymbol,
      {bool focusTracking = true}) {
    assert(oldLatLng != null);
    if (!isCarAnimating) {
      controller =
          AnimationController(vsync: vsync, duration: Duration(seconds: 3));
      var tween = Tween<double>(begin: 0, end: 1);
      animation = tween.animate(controller!);

      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          oldLatLng = newLatLng;
          isCarAnimating = false;
          if (focusTracking) _moveCurrentLocation(newLatLng);
        } else if (status == AnimationStatus.forward) {
          isCarAnimating = true;
        }
      });

      controller?.forward();
      var bearing = getBearing(oldLatLng!, newLatLng);

      animation.addListener(() async {
        var v = animation.value;
        var lng = v * newLatLng.longitude + (1 - v) * oldLatLng!.longitude;
        var lat = v * newLatLng.latitude + (1 - v) * oldLatLng!.latitude;

        var latLng = LatLng(lat, lng);

        var cabSymbolOptions = SymbolOptions(
          geometry: latLng,
          iconRotate: bearing,
        );
        await mmiController.updateSymbol(markerSymbol, cabSymbolOptions);
      });
    }
  }

  Future<void> _moveCurrentLocation(LatLng latLng) async {
    await mmiController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
  }

  static double getBearing(LatLng start, LatLng end) {
    var lat1 = start.latitude * math.pi / 180;
    var lng1 = start.longitude * math.pi / 180;
    var lat2 = end.latitude * math.pi / 180;
    var lng2 = end.longitude * math.pi / 180;

    var dLon = (lng2 - lng1);
    var y = math.sin(dLon) * math.cos(lat2);
    var x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    var bearing = math.atan2(y, x);
    bearing = (bearing * 180) / math.pi;
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  dispose() {
    controller?.dispose();
  }
}
