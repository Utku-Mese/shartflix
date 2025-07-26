import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../services/firebase_service.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Initialize Firebase
  await FirebaseService.initialize();

  // Initialize other dependencies
  await getIt.init();
}
