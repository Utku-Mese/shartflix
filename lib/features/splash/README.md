# Splash Feature Module

Bu modül uygulamanın splash screen (açılış ekranı) özelliğini içerir.

## Yapı

```
splash/
├── splash.dart                    # Barrel export file
└── presentation/
    ├── pages/
    │   └── splash_page.dart       # Ana splash screen sayfası
    ├── widgets/
    │   └── splash_logo.dart       # Logo widget'ı
    └── controllers/
        └── splash_controller.dart # Splash logic controller
```

## Kullanım

```dart
import 'features/splash/splash.dart';

// Ana uygulamada
home: const SplashPage(),
```

## Özellikler

- **SplashPage**: Ana splash screen sayfası
- **SplashLogo**: Animasyonlu logo widget'ı
- **SplashController**: Splash timing ve navigation logic'i

## Animasyonlar

- Fade in/out animasyonu
- Scale animasyonu
- 5 saniye splash süresi
- Otomatik login sayfasına yönlendirme
