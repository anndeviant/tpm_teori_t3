import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MarkerInfo {
  final LatLng point;
  final String title;
  final String documentId;

  MarkerInfo(this.point, this.title, this.documentId);
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentLatLng;
  late final MapController _mapController;
  final List<MarkerInfo> _markerPoints = [];
  final List<MarkerInfo> _filteredMarkers = [];
  final TextEditingController _markerTitleController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<LatLng> _routePoints = [];
  MarkerInfo? _selectedMarker;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getUserLocation().then((_) {
      _loadMarkersFromFirebase();
    });

    _searchController.addListener(_filterMarkers);
  }

  @override
  void dispose() {
    _markerTitleController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterMarkers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMarkers.clear();
      if (query.isEmpty) return;
      _filteredMarkers.addAll(
        _markerPoints.where(
          (marker) => marker.title.toLowerCase().contains(query),
        ),
      );
    });
  }

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
    });
  }

  void _focusToCurrentPosition() {
    if (currentLatLng != null) {
      _mapController.move(currentLatLng!, 18);
    }
  }

  Future<void> _loadMarkersFromFirebase() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('markers')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      final loadedMarkers = snapshot.docs.map((doc) {
        final data = doc.data();
        final point = LatLng(data['latitude'], data['longitude']);
        final title = data['title'] ?? 'Tanpa Judul';
        return MarkerInfo(point, title, doc.id);
      }).toList();

      setState(() {
        _markerPoints.clear();
        _markerPoints.addAll(loadedMarkers);
        _filterMarkers();
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat marker dari server")),
      );
    }
  }

  Future<void> _handleTapOnMap(LatLng tappedPoint) async {
    _markerTitleController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Marker"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Latitude: ${tappedPoint.latitude}\nLongitude: ${tappedPoint.longitude}"),
            const SizedBox(height: 10),
            TextField(
              controller: _markerTitleController,
              decoration: const InputDecoration(
                labelText: "Judul Marker",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("BATAL"),
          ),
          TextButton(
            onPressed: () async {
              final title = _markerTitleController.text.trim();
              if (title.isNotEmpty) {
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  try {
                    final newDoc = await FirebaseFirestore.instance
                        .collection('markers')
                        .add({
                      'userId': currentUser.uid,
                      'latitude': tappedPoint.latitude,
                      'longitude': tappedPoint.longitude,
                      'title': title,
                      'timestamp': FieldValue.serverTimestamp(),
                    });

                    setState(() {
                      final newMarker =
                          MarkerInfo(tappedPoint, title, newDoc.id);
                      _markerPoints.add(newMarker);
                      _filterMarkers();
                    });

                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Marker berhasil disimpan!")),
                    );
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Gagal menyimpan marker")),
                    );
                  }
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Judul marker tidak boleh kosong")),
                );
              }
            },
            child: const Text("TAMBAH"),
          ),
        ],
      ),
    );
  }

  void _showMarkerPopup(MarkerInfo markerInfo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(markerInfo.title),
        content: Text(
          "Latitude: ${markerInfo.point.latitude}\n"
          "Longitude: ${markerInfo.point.longitude}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('markers')
                    .doc(markerInfo.documentId)
                    .delete();

                setState(() {
                  _markerPoints.remove(markerInfo);
                  _filterMarkers();
                });

                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Marker berhasil dihapus.")),
                );
              } catch (e) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Gagal menghapus marker dari server.")),
                );
              }

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: const Text("HAPUS", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedMarker = markerInfo;
              });
              Navigator.pop(context);
              _drawRoute(markerInfo.point);
            },
            child: const Text("RUTE", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Future<void> _drawRoute(LatLng destination) async {
    if (currentLatLng == null) return;

    final url =
        'https://router.project-osrm.org/route/v1/driving/${currentLatLng!.longitude},${currentLatLng!.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coords = data['routes'][0]['geometry']['coordinates'] as List;

        setState(() {
          _routePoints = coords
              .map((c) => LatLng(c[1] as double, c[0] as double))
              .toList();
        });

        // Zoom out to fit both markers and the route
        final bounds = LatLngBounds(
          LatLng(currentLatLng!.latitude, currentLatLng!.longitude),
          LatLng(destination.latitude, destination.longitude),
        );

        // ignore: deprecated_member_use
        _mapController.fitBounds(bounds,
            // ignore: deprecated_member_use
            options: FitBoundsOptions(padding: EdgeInsets.all(20)));
      } else {
        throw Exception("Gagal memuat rute");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menampilkan rute.")),
      );
    }
  }

  void _goToMarker(MarkerInfo markerInfo) {
    _mapController.move(markerInfo.point, 18);
    _searchController.clear();
    FocusScope.of(context).unfocus();
    _filterMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    // ignore: deprecated_member_use
                    center: currentLatLng,
                    // ignore: deprecated_member_use
                    zoom: 18,
                    onTap: (_, tappedPoint) => _handleTapOnMap(tappedPoint),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                      userAgentPackageName: 'com.tcc.favoritetracker',
                    ),
                    PolylineLayer(
                      polylines: [
                        if (_routePoints.isNotEmpty)
                          Polyline(
                            points: _routePoints,
                            strokeWidth: 5,
                            color: Colors.purple,
                          ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80,
                          height: 80,
                          point: currentLatLng!,
                          child: const Icon(
                            Icons.person_pin_circle,
                            size: 40,
                            color: Colors.red,
                          ),
                        ),
                        if (_selectedMarker != null)
                          Marker(
                            width: 80,
                            height: 80,
                            point: _selectedMarker!.point,
                            child: const Icon(
                              Icons.location_on,
                              size: 40,
                              color: Colors.green,
                            ),
                          ),
                        ..._markerPoints.map((markerInfo) => Marker(
                              width: 100,
                              height: 80,
                              point: markerInfo.point,
                              child: GestureDetector(
                                onTap: () => _showMarkerPopup(markerInfo),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 40,
                                      color: Colors.blue,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 2,
                                          )
                                        ],
                                      ),
                                      child: Text(
                                        markerInfo.title,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari marker...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterMarkers();
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      if (_filteredMarkers.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredMarkers.length,
                            itemBuilder: (context, index) {
                              final marker = _filteredMarkers[index];
                              return ListTile(
                                title: Text(marker.title),
                                onTap: () => _goToMarker(marker),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 80,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: _focusToCurrentPosition,
                    backgroundColor: Colors.white,
                    child:
                        const Icon(Icons.my_location, color: Colors.deepPurple),
                  ),
                ),
              ],
            ),
    );
  }
}
