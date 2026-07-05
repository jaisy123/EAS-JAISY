plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.eas_mpl_jaisy"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.eas_mpl_jaisy"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 1. TENTUKAN DIMENSI FLAVOR (Sintaks Kotlin DSL)
    flavorDimensions.add("default")

    // 2. DAFTARKAN FLAVOR DEV DAN PROD (Sintaks Kotlin DSL)
    productFlavors {
        create("dev") {
            dimension = "default"
            applicationIdSuffix = ".dev" // Menghasilkan: com.example.eas_mpl_jaisy.dev
            resValue("string", "app_name", "DigiNews [DEV]")
        }
        create("prod") {
            dimension = "default"
            resValue("string", "app_name", "DigiNews")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}