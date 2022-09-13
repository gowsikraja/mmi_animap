<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

While working in map with Live-Tracking, You may like to show marker moving animation. This package
will help you to animate marker over MapMyIndia's Map.

## Features

This initial version will use to move marker icon with smooth animation.

## Getting started

This package only support in MapMyIndia's map. Tested android and Ios

## Usage

To initialize `MmiAnimarker` you need to pass `MapmyIndiaMapController` and `vsync`

```dart
late MmiAnimarker mmiAnimarker;

_onMapCreated(MapmyIndiaMapController controller) {
  mmiAnimarker = MmiAnimarker(controller, this);
}
```

```dart
late Symbol carMarkerSymbol;
String carMarker = 'carMarker';

_addCarMarker(LatLng cabLatLng) async {
  var symbolOptions = SymbolOptions(
    geometry: cabLatLng,
    iconImage: carMarker,
    iconSize: 0.8,
  );
  cabMarkerSymbol = await mmiAnimarker.addAnimarkerSymbol(
      carMarker, AppImages.IMG_CAR_MARKER, symbolOptions);
}
```

```dart
 _animateCabIcon(LatLng currentLatLng) async {
  if (cabMarkerSymbol != null)
    await mmiAnimarker.animateMarker(currentLatLng, cabMarkerSymbol!);
}
```
## Screenshot

<img src="https://user-images.githubusercontent.com/23701518/189908643-957c79f4-b8f2-4a1b-b99a-475b511b2b73.gif" alt="">