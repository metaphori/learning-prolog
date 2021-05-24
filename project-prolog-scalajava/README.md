# Java/Scala - Prolog integration

Running main programs

- `./gradlew runJob -PjobClass=it.unibo.u12lab.code.TicTacToeApp`
- `sbt "runMain it.unibo.u12lab.code.Permutations"`

Launching TuProlog GUI

- ` ./gradlew runJob -PjobClass=alice.tuprologx.ide.GUILauncher`

Playing TTT

```
$ sbt "runMain alice.tuprologx.ide.CUIConsole"
>  consult('src/main/resources/ttt.pl').
```
