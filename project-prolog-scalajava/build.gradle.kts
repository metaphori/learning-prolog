plugins {
    scala
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.scala-lang:scala-library:2.12.8")
    implementation("it.unibo.alice.tuprolog:2p-core:4.1.1")
}

tasks.withType<ScalaCompile> {
    sourceCompatibility = "1.8"
    targetCompatibility = "1.8"
}