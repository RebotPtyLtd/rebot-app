import 'dart:io';

/// Selects the appropriate .env file based on the platform.
String getEnvFile() {
  if (Platform.isAndroid) {
    return '.env.mobile.android';
    }
  if (Platform.isIOS) {
    return '.env.mobile.ios';
  }
  return '.env';
}
