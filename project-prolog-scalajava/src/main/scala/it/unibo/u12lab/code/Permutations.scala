package it.unibo.u12lab.code

object Permutations extends App {

  // first an example of for-comprehension with streams..
  // note the first collection sets the type of all subsequent results

  val s: Stream[Int] = for (i <- (10 to 50 by 10).toStream; k = i + 1; j <- List(k - 1, k, k + 1)) yield j
  println(s) // Stream(10,?)
  println(s.take(10).toList) // a list with the first 10 results
  println(s) // the same stream, but now we know 10 elements of it
  println(s.toList) // all on list
  println(s) // the same stream, but now we know all its elements

  // now let's do permutations
  // fill this method remove such that it works as of the next println
  // - check e.g. how method "List.split" works
  def removeAtPos[A](list:List[A], n:Int): List[A] = (list, n) match {
    case (Nil, _) => Nil
    case (_::t, 0) => t
    case (h::t, n) => h :: removeAtPos(t, n-1)
  }
  println(removeAtPos(List(10,20,30,40),1)) // 10,30,40

  def permutations[A](list: List[A]): Stream[List[A]] = list match {
    case Nil => Stream(Nil)
    case _ =>
    /* here a for comprehension that:
       - makes i range across all indexes of list (converted as stream)
       - assigns e to element at position i
       - assigns r to the rest of the list as obtained from removeAtPos
       - makes pr range across all results of recursively calling permutations on r
       - combines by :: e with pr
       */
        for(
          i <- list.indices.toStream;
          e = list(i);
          r <- permutations(removeAtPos(list, i))
        ) yield e :: r
  }

  val list = List(10,20,30,40)
  println(permutations(list).toList)
  println(list.permutations.toList)

  println("Same as List.permutations? " + (permutations(list).toList.toSet == list.permutations.toSet))
}

