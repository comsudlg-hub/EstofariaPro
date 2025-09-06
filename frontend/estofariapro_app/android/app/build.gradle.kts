plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // Apenas aplicar, sem versão
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.compersonalite.estofariapro"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.compersonalite.estofariapro"
        minSdk = 23 // Atualizado para padronização
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Firebase BOM gerencia automaticamente as versões dos serviços Firebase
    implementation(platform("com.google.firebase:firebase-bom:32.0.0"))
}

flutter {
    source = "../.."
}
