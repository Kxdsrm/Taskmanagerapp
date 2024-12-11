import 'package:connectivity_plus/connectivity_plus.dart';

// Checks whether the device is online or not.
// Returns `true` if the device has an active internet connection,
// otherwise returns `false`.

Future<bool> _isOnline() async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}
