allprojects {
    repositories {
        google()
        central()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// === TAMBAHKAN BLOK INI DI PALING BAWAH DEN! ===
// Logika ini mendeteksi jika ada plugin isar yang rewel, lalu otomatis menyuntikkan namespace agar AGP baru tidak protes
subprojects {
    afterEvaluate {
        if (project.plugins.hasPlugin("com.android.library")) {
            val androidExtension = project.extensions.findByName("android") as? com.android.build.gradle.LibraryExtension
            if (androidExtension != null && androidExtension.namespace == null) {
                // Menyuntikkan namespace darurat berdasarkan nama projectnya (menyelamatkan isar_flutter_libs)
                androidExtension.namespace = "dev.isar.${project.name.replace("-", "_")}"
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}