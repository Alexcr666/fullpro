import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fullpro/config.dart';

import 'package:fullpro/models/homeTrendingServices.dart';

import 'package:fullpro/provider/Appdata.dart';

import 'package:fullpro/styles/statics.dart' as Static;

import 'package:fullpro/widgets/DataLoadedProgress.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

class MapSample extends StatefulWidget {
  const MapSample();

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  servicesComponent({required HomeTrendingServices kServices}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        child: MaterialButton(
          elevation: 0.0,
          hoverElevation: 0.0,
          focusElevation: 0.0,
          highlightElevation: 0.0,
          minWidth: 70,
          height: 75,
          color: Static.themeColor[500],
          onPressed: () {
            //
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  kServices.image!,
                  width: 100,
                  height: 100,
                  errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.withOpacity(0.3),
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 30,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    );
                  },
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: Text(
                      kServices.name!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Roboto-Bold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    kServices.chargemod!,
                    style: const TextStyle(
                      color: Static.colorLightGrayFair,
                      fontSize: 13,
                    ),
                  ),
                  Row(
                    children: [
                      kServices.discount! != '0'
                          ? Text(
                              currencyPos == 'left'
                                  ? '$currencySymbol${int.parse(kServices.price!)}'
                                  : '${int.parse(kServices.price!)}$currencySymbol',
                              style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.white,
                                decorationThickness: 2,
                              ),
                            )
                          : const SizedBox(),
                      kServices.discount! != '0' ? const SizedBox(width: 15) : const SizedBox(),
                      Text(
                        currencyPos == 'left'
                            ? '$currencySymbol${int.parse(kServices.price!) - int.parse(kServices.discount!)}'
                            : '${int.parse(kServices.price!) - int.parse(kServices.discount!)}$currencySymbol',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 3,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.green,
                        ),
                        Text(
                          kServices.rating!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        Container(
            margin: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
            child: Positioned.fill(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 130,
                child: Provider.of<AppData>(context).homeTrendingData.isNotEmpty
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          return servicesComponent(
                            kServices: Provider.of<AppData>(context).homeTrendingData[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                        itemCount: Provider.of<AppData>(context).homeTrendingData.length,
                        physics: const ClampingScrollPhysics(),
                      )
                    : const Center(child: DataLoadedProgress()),
              ),

              /* ClipRRect(

                        borderRadius: BorderRadius.circular(25),

                        child: Container(

                          color: Colors.white,

                          height: 100,

                          child: Row(children: [

                            SizedBox(

                              width: 10,

                            ),

                            ClipRRect(

                              borderRadius: BorderRadius.circular(25),

                              child: Image.network(

                                "",

                                errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {

                                  return Container(

                                    width: 90,

                                    height: 90,

                                    color: Colors.grey.withOpacity(0.3),

                                  );

                                },

                                width: 80,

                                height: 80,

                                fit: BoxFit.cover,

                              ),

                            ),

                            SizedBox(

                              width: 30,

                            ),

                            Column(

                              crossAxisAlignment: CrossAxisAlignment.start,

                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [

                                Text("Titulo"),

                                SizedBox(

                                  height: 10,

                                ),

                                Text("Descripción"),

                              ],

                            )

                          ]),

                        ))*/
            ))),
      ],
    )

        /* floatingActionButton: FloatingActionButton.extended(

        onPressed: _goToTheLake,

        label: const Text('To the lake!'),

        icon: const Icon(Icons.directions_boat),

      ),*/

        );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;

    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
