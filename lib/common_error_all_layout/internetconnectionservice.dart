import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionService {
  static final InternetConnectionService _instance =
      InternetConnectionService._internal();
  factory InternetConnectionService() => _instance;

  final _connectionController = StreamController<InternetStatus>.broadcast();
  StreamSubscription? _internetConnectionStreamSubscription;

  InternetConnectionService._internal() {
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((status) {
      _connectionController.add(status);
    });
  }

  Stream<InternetStatus> get connectionStatus => _connectionController.stream;

  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    _connectionController.close();
  }
}
