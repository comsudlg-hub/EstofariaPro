plugins {
    id("com.android.library") apply false
    id("org.jetbrains.kotlin.android") apply false
    id("dev.flutter.flutter-gradle-plugin") apply false
    id("com.google.gms.google-services") version "4.4.0" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

dependencies {
    // Dependências globais podem ser adicionadas aqui, se necessário
}
