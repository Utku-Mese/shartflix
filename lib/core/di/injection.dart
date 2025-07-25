import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../services/firebase_service.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Firebase'i ilk başlat
  await FirebaseService.initialize();

  // Diğer dependencies'leri başlat
  await getIt.init();
}
