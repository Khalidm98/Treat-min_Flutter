# Treat-min

1. Clone the project
2. Copy these files `lib/utils/google_api_key.dart`, `android/key.properties`, `../upload-keystore.jks`
3. Add `GOOGLE_API_KEY` in 'android/local.properties'
4. `flutter build appbundle --build-number <android/key.properties:flutter.versionCode + 1>`
