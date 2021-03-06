import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final TextEditingController textController = TextEditingController();

  static final LatLng startPosition = LatLng(
    37.57093954906714,
    126.97892558649372,
  );

  static final CameraPosition initialPosition = CameraPosition(
    target: startPosition,
    zoom: 16,
  );

  static final List<Marker> lunchList = [
    Marker(
        markerId: MarkerId('폴리스 광화문D타워점'),
        position: LatLng(37.5707617408125, 126.97971518236)),
    Marker(
        markerId: MarkerId('엉뚱한국수'),
        position: LatLng(37.5708410632276, 126.97991891481)),
    Marker(
        markerId: MarkerId('후와후와 광화문점'),
        position: LatLng(37.5710499164304, 126.978900086079)),
    Marker(
        markerId: MarkerId('풍황'),
        position: LatLng(37.5708698757662, 126.979805710385)),
    Marker(
        markerId: MarkerId('포비 광화문점'),
        position: LatLng(37.5710030687241, 126.978922738673)),
    Marker(
        markerId: MarkerId('육대장 종로구청점'),
        position: LatLng(37.57238386946, 126.98178401978),
        consumeTapEvents: true,
        onTap: () {
          print("클릭이 되는군요");
        }),
    Marker(
        markerId: MarkerId('김밥천국'),
        position: LatLng(37.5706896573003, 126.979692562627)),
    Marker(
        markerId: MarkerId('광화문수제비 종로점'),
        position: LatLng(37.5707149215821, 126.979905365103)),
    Marker(
        markerId: MarkerId('야마야 디타워점'),
        position: LatLng(37.5709958583365, 126.978909157079)),
    Marker(
        markerId: MarkerId('수수커피디타워'),
        position: LatLng(37.5710679403785, 126.978922720392)),
    Marker(
        markerId: MarkerId('동락돼지'),
        position: LatLng(37.5710491080985, 126.974779716958)),
    Marker(
        markerId: MarkerId('광화문미진 본점'),
        position: LatLng(37.5708410632276, 126.97991891481)),
    Marker(
        markerId: MarkerId('이디야커피 종로르메이에르점'),
        position: LatLng(37.5707617408125, 126.97971518236)),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: checkPermission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == '위치 권한이 허가 되었습니다') {
            return Scaffold(
              appBar: renderAppBar(),
              body: Stack(
                children: [
                  _CustomGoogleMap(
                    initialPosition: initialPosition,
                    markerList: lunchList,
                  ),
                  _SearchBar(
                    textController: textController,
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Text(snapshot.data),
          );
        });
  }

  Future<String> checkPermission() async {
    // location service가 활성화 되어있는지 확인함
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      // 활성화 되어 있지 않으면 위치 서비스 활성화 해달라고 띄우자
      return '위치 서비스를 활성화 해주세요.';
    }

    // 활성화 되어 있다면 현재 위치서비스에 대해 갖고있는 권한을
    // LocationPermission 형태로 가져올 수 있다
    LocationPermission checkPermission = await Geolocator.checkPermission();

    if (checkPermission == LocationPermission.denied) {
      checkPermission = await Geolocator.requestPermission();
      if (checkPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요';
      }
    }

    if (checkPermission == LocationPermission.deniedForever) {
      return '설정에서 앱의 위치 권한을 허가해주세요';
    }

    return '위치 권한이 허가 되었습니다';
  }

  AppBar renderAppBar() {
    return AppBar(
      backgroundColor: Colors.grey[600],
      centerTitle: true,
      title: Text(
        '광화문 직장인 오늘 뭐 먹지',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.my_location),
        )
      ],
    );
  }
}

class _CustomGoogleMap extends StatelessWidget {
  final List<Marker> markerList;
  final CameraPosition initialPosition;
  const _CustomGoogleMap(
      {Key? key, required this.initialPosition, required this.markerList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GoogleMap(
        initialCameraPosition: initialPosition,
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        markers: Set.from(markerList),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController textController;
  const _SearchBar({Key? key, required this.textController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimSearchBar(
          rtl: true,
          width: MediaQuery.of(context).size.width,
          textController: textController,
          onSuffixTap: () {},
        ),
      ),
    );
  }
}
