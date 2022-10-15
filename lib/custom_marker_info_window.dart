import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class CustomMarkerInfoWindow extends StatefulWidget {
  const CustomMarkerInfoWindow({super.key});

  @override
  State<CustomMarkerInfoWindow> createState() => _CustomMarkerInfoWindowState();
}

class _CustomMarkerInfoWindowState extends State<CustomMarkerInfoWindow> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  Uint8List? marketimages;
  List<String> images = [
    'assets/iconmap.png',
    'assets/iconmap.png',
    'assets/iconmap.png',
    'assets/iconmap.png',
    'assets/iconmap.png',
    'assets/iconmap.png',
  ];

  final List<Marker> _markers = [];
  final List<LatLng> _latLang = <LatLng>[
    const LatLng(41.30669453305869, 69.25879298908676),
    const LatLng(41.29855444206393, 69.26795636513747),
    const LatLng(41.310207227827, 69.24742229910653),
    const LatLng(41.295465728894776, 69.2155623042479),
    const LatLng(41.28395179182451, 69.26120257369935),
    const LatLng(41.286271309487326, 69.23606735284203),
  ];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  loadData() async {
    for (var i = 0; i < _latLang.length; i++) {
      final Uint8List markIcons = await getImages(images[i], 100);
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          icon: BitmapDescriptor.fromBytes(markIcons),
          position: _latLang[i],
          onTap: () {
            DetailsMap(context);
          },
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
                target: LatLng(41.2995, 69.2401), zoom: 14),
            markers: Set<Marker>.of(_markers),
            onTap: (postition) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) =>
                _customInfoWindowController.onCameraMove,
            onMapCreated: (GoogleMapController controller) {
              _customInfoWindowController.googleMapController = controller;
            },
            //  zoomControlsEnabled: false,
            zoomGesturesEnabled: false,
            mapToolbarEnabled: false,
          ),
        ],
      ),
    );
  }
}

Future<dynamic> DetailsMap(context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: 88,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  color: Colors.white),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 17),
                    child: Icon(Icons.download),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.maps_home_work),
                      Text(
                          "Toshkent viloyati, Toshkent shaxar, Yunusobod tumani")
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 139,
                      width: 335,
                      color: Color(0xFFF2F2F7),
                    );
                  }),
            ),
          ],
        ),
      );
    },
    backgroundColor: Colors.transparent,
  );
}
