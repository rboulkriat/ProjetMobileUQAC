buildscript {
    repositories {
        google()
        mavenCentral()
        maven { setUrl("https://maven.google.com") } // ✅ Kotlin DSL Correct
        maven { setUrl("https://jitpack.io") } // ✅ Kotlin DSL Correct
    }
    dependencies {
        classpath("com.google.gms:google-services:4.3.10")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven { setUrl("https://maven.google.com") } // ✅ Correction Kotlin DSL
        maven { setUrl("https://jitpack.io") } // ✅ Correction Kotlin DSL
    }
}



val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
