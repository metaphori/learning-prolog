name := "pps-lab-scala-prolog-integration"

libraryDependencies += "it.unibo.alice.tuprolog" % "2p-core" % "4.1.1"

// https://www.scala-sbt.org/1.x/docs/Java-Sources.html
Compile / compileOrder := CompileOrder.ScalaThenJava
