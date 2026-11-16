# ==============================================================================
# SAYURHUB - PROGUARD & R8 RULES FOR PRODUCTION RELEASE
# ==============================================================================

# Flutter standard keep rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.**  { *; }

# Pertahankan metadata anotasi & line numbers untuk crash reporting (Firebase Crashlytics / Sentry)
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

# Sqflite SQLite Database JNI reflection
-keep class com.tekartik.sqflite.** { *; }

# Flutter Secure Storage Keystore reflection
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Image Picker camera provider
-keep class io.flutter.plugins.imagepicker.** { *; }

# Jangan buang generic signatures untuk serialisasi data
-keepattributes Signature
