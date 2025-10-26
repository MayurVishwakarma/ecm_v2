import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

Future<String> getCurrentLocationImage() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied.");
    }
  }

  final position = await Geolocator.getCurrentPosition();
  return "Location: ${position.latitude},${position.longitude}\nDateTime: ${DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now())}";
}
