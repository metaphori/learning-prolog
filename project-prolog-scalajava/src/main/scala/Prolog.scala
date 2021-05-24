package it.unibo

import Prolog.Terms._

object Prolog {

  sealed trait Term

  object Terms {

    type VID = Int
    type FUNCTOR = String

    sealed trait TermToString {
      self: Term =>
      override def toString() = self match {
        case Number(v) => "@" + v
        case Atom(s) => "@\"" + s + "\""
        case Compound(functor, args) => functor + args.mkString("(", ",", ")")
        case Var(vid) => "_" + vid
      }
    }

    case class Number(v: AnyVal) extends Term with TermToString

    case class Atom(s: String) extends Term with TermToString

    case class Compound(functor: FUNCTOR, args: List[Term]) extends Term with TermToString

    case class Var(vid: VID) extends Term with TermToString

  }

  trait VariablesStore {
    def freshVar(): Var
  }

  object VariablesStore {
    def apply(): VariablesStore = new VariablesStore {
      private var id: VID = 0
      override def freshVar(): Var = Var(try id finally id = id + 1)
    }
  }

  object Unification {

    trait Binding {

      def ++(b: Binding): Option[Binding]

      def bind(t: Term): Option[Term]

      def map: Map[Set[Var], Option[Term]]

    }

    object Binding {

      type Binder = (Var,Term)

      def apply(binders: Binder*): Binding = {
        opt(binders: _*).getOrElse(throw new IllegalArgumentException)
      }

      def opt(binders: Binder*): Option[Binding] = {
        binders.foldLeft[Option[BindingImpl]](Some(BindingImpl()))((b, e) => b.flatMap(_ + e))
      }

      def unification(t1: Term, t2: Term): Option[Binding] =
        (t1, t2) match {
          case (Number(n), Number(m)) if n == m => Binding.opt()
          case (Atom(a), Atom(b)) if a == b => Binding.opt()
          case (Compound(f, args), Compound(f2, args2)) if f == f2 && args.length == args2.length => unifications(args,args2)
          case (Var(vid), Var(vid2)) if vid == vid2 => Binding.opt()
          case (v1: Var, v2: Var) => Binding.opt(v1 -> v2)
          case (v: Var, term) => Binding.opt(v -> term)
          case (term, v: Var) => Binding.opt(v -> term)
          case _ => None
        }

      private def unifications(l1: List[Term], l2: List[Term]): Option[Binding] =
        (l1 zip l2).map { case (t1, t2) => unification(t1, t2) }
          .fold[Option[Binding]](Some(BindingImpl())){combineBinding(_,_)}

      private def combineBinding(ob1: Option[Binding], ob2: Option[Binding]): Option[Binding] =
        ob1.flatMap( b1 => ob2.flatMap( b2 => b1 ++ b2))

      private def combineBinderTerms(ot1: Option[Term], ot2: Option[Term]): Option[(Option[Term], Binding)] = (ot1, ot2) match {
        case (None, None) => Some(None, BindingImpl())
        case (Some(t), None) => Some(Some(t), BindingImpl())
        case (None, Some(t)) => Some(Some(t), BindingImpl())
        case (Some(t1), Some(t2)) => unification(t1, t2).flatMap(b => Some(b.bind(t1), b))
      }

      private case class BindingImpl(override val map: Map[Set[Var], Option[Term]] = Map()) extends Binding {

        type Entry = (Set[Var], Option[Term])

        override def ++(b: Binding): Option[BindingImpl] = {
          b.map.foldLeft[Option[BindingImpl]](Some(this)){ case (o,b) =>  o.flatMap( _ add b)}
        }

        def +(e: (Var, Term)): Option[BindingImpl] = e._2 match {
          case v: Var => add(Set(e._1, v) -> None)
          case t => add(Set(e._1) -> Some(t))
        }

        def add(e: Entry): Option[BindingImpl] = {
          val (map1, map2) = map partition { case (s2, ot) => (e._1 & s2).nonEmpty }
          val oeb = map1.foldLeft[Option[(Entry, Binding)]](Some((e, BindingImpl()))) {
            case (oeb1, e2) => oeb1.flatMap { case (e1, b1) => combineEntries(e1, e2).flatMap { case (e, b) => (b ++ b1).map((e, _)) } }
          }
          oeb.flatMap(eb => BindingImpl(map2 + (eb._1)) ++ eb._2)
        }

        override def bind(t: Term): Option[Term] = t match {
          case v: Var => map collectFirst { case (s, ot) if (s contains v) => ot.flatMap(bind(_)) } get
          case Compound(f, seq) => Some(seq map { t2 => (t2, bind(t2)) }) collect { case seq2 if (seq2 forall (_._2.isDefined)) => Compound(f, seq2 map {
            _._2.get
          })
          }
          case Number(_) | Atom(_) => Some(t)
        }

        private def combineEntries(e1: Entry, e2: Entry): Option[(Entry, Binding)] =
          combineBinderTerms(e1._2, e2._2) map { case (ot, b) => ((e1._1 ++ e2._1, ot), b) }
      }

    }

  }

  object Resolution {

    import Unification._


    case class Resolvent(goals: List[Term], binding: Binding)

    case class Rule(head: Term, body: List[Term])

    case class Theory(rules: Rule*)

    case class Result(binding: Binding, term: Term)


    trait Engine {

      def solve(theory: Theory)(goal: Term): Stream[Result]
    }

    object Engine {

      def make(implicit store: VariablesStore): Engine = new Engine() {

        def solve(theory: Theory)(goal: Term): Stream[Result] =
          solutions(theory)(Resolvent(List(goal), Binding())) map {result(goal)(_)}

        private def result(goal: Term)(binding: Binding): Result =
          binding.bind(goal).get match {case term => Result(Binding.unification(goal,term).get, term) }

        /**
         * The CORE of the "RESOLUTION" process is here.
         * @param theory
         * @param goal
         * @return
         */
        private def solutions(theory: Theory)(goal: Resolvent): Stream[Binding] = goal match {
          case Resolvent(Nil, binding) => Stream(binding)
          case Resolvent(first :: others, binding) =>
            for (
              rule <- theory.rules.toStream;
              Rule(head, body) = copyRule(rule);
              binder <- Binding.unification(head, first).toStream;
              newBinding <- (binding ++ binder).toStream;
              solution <- solutions(theory)(Resolvent(body ++ others, newBinding))
            ) yield solution
        }

        private def copyRule(rule: Rule, map: collection.mutable.Map[Var, Var] = collection.mutable.Map())
                     (implicit variablesStore: VariablesStore): Rule = {
          def copyTerm(term: Term): Term = term match {
            case v: Var => if (!map.isDefinedAt(v)) map(v) = variablesStore.freshVar(); map(v)
            case Compound(p, seq) => Compound(p, seq map (copyTerm(_)))
            case t => t
          }
          rule match {case Rule(head, body) => Rule(copyTerm(head), body map (copyTerm(_)))}
        }

      }
    }
  }


  object Syntax {

    import Terms._
    import Unification._
    import Resolution._

    class VarProxy(implicit env: VariablesStore) extends Var(env.freshVar().vid)


    trait PrologName {
      // FRAGILE!
      override def toString: String = this.getClass.getSimpleName.split("\\$").head
    }

    trait FunctorName extends PrologName {
      def apply(implicit args: Term*) = Compound(this.toString, args.toList)
    }

    class VarName(implicit env: VariablesStore) extends VarProxy with PrologName


    implicit def valToNumber(v: AnyVal): Term = Number(v)

    implicit def stringToAtom(s: String): Term = Atom(s)

    def Cmp(functor: FunctorName)(implicit args: Term*) = Compound(functor.toString, args.toList)

    def Cmp(functor: String)(implicit args: Term*) = Compound(functor, args.toList)

    def __(implicit env: VariablesStore): Term = env.freshVar()

    implicit def RichNameToTerm(n: FunctorName): Term = Cmp(n)()

    implicit class RichVariableForBinding(v: Var) {
      def /(t: Term): Binding = Binding(v -> t)
    }

    implicit class RichTermForUnification[T](t: T)(implicit f:T => Term) {
      def |||(t2: Term): Option[Binding] = Binding.unification(f(t), t2)
    }

    implicit class RichBindingToBind(o: Option[Binding]) {
      def >>(t: Term): Option[Term] = o.flatMap(b => b.bind(t))
    }

    implicit class RichTermForRule(t: Term) {
      def :-(body: Term*) = Rule(t, body.toList)
    }

    implicit class RichTermForResolvent(t: Term) extends Resolvent(List(t), Binding())

    implicit class RichTermForFact(t: Term) extends Rule(t, List())

    implicit def / = Binding()
  }
}


object WorkWithProlog extends App {

  def permutations[T](list: List[T]): Stream[List[T]] = {
    if (list.isEmpty) return Stream(List[T]())
    for {
      i <- (0 until list.size).toStream // enables lazyness..
      (l1, h :: t) = list.splitAt(i)
      l <- permutations(l1 ::: t)
    } yield (h :: l)
  }

  def combinations[T](set: Set[T]): Stream[List[T]] = {
    //List[T]() #:: combinations(set).flatMap(l => set.toStream.map(t => t::l))
    List[T]() #:: (for {
      l <- combinations(set);
      i <- set.toStream
    } yield (i :: l))
  }

  //permutations(List(10,20,30)).foreach(println(_))
  //combinations(Set(10,20,30)).take(10).foreach(println(_))

}
