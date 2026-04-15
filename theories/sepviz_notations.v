From iris.heap_lang Require Import lang proofmode notation.

(** ** Separation-logic formulas *)

Declare Custom Entry sep.

Notation "'⟬' e '⟭'" :=
  (e)
    (e custom sep at level 200, at level 0).

Notation "'Pure' '┆' P" :=
  (bi_pure P)
    (in custom sep at level 200,
     P constr at level 200).

Notation "'PointsTo' '┆' l '┆' 'PlainPointsTo' '┆' dq '┆' v" :=
  (pointsto l dq v)
    (in custom sep at level 200,
     l constr at level 200,
     dq constr at level 200,
     v constr at level 200).

Notation "'Star' '┆' H1 '┆' H2" :=
  (bi_sep H1 H2)
    (in custom sep at level 200,
     H1 constr at level 200,
     H2 constr at level 200).

Notation "'Wand' '┆' H1 '┆' H2" :=
  (bi_wand H1 H2)
    (in custom sep at level 200,
     H1 constr at level 200,
     H2 constr at level 200).

Notation "'Later' '┆' H" :=
  (bi_later H)
    (in custom sep at level 200,
     H constr at level 200).

Notation "'Exist' '┆' x '┆' H" :=
  (bi_exist (fun x => H))
    (in custom sep at level 200,
     x constr at level 200,
     H constr at level 200).

Notation "'⟬*' 'PRE' '@' P '*⟭' e 'RET' pat ; '⟬*' 'POST' '@' Q '*⟭'" :=
  (∀ Φ, P -∗ ▷ (Q -∗ Φ pat%V) -∗ WP e {{ Φ }})
    (format "'⟬*'  'PRE'  '@'  P  '*⟭' '//' e '//' 'RET'  pat ; '//' '⟬*'  'POST'  '@'  Q  '*⟭'"): stdpp_scope.

Notation "Γ ⟬* H : P *⟭" := (environments.Esnoc Γ (INamed H) P%I)
  (at level 1, P at level 200,
  left associativity, format "Γ ⟬*  H  :  P  *⟭ '//'", only printing) : proof_scope.

Section septest.
  Context `{!heapGS Σ}.
  Parameter A B C: iProp Σ.
  Parameter P: Prop.
  Check (bi_sep A B).
  Check (bi_sep (bi_sep A C) B).
  Check (bi_wand A B).
  Check (bi_wand (bi_sep (bi_sep A A) B) (bi_pure P)).
End septest.

(** ** Values *)

Declare Custom Entry val.

Notation "'⟦' e '⟧'" :=
  (e)
    (e custom val at level 200, at level 0).

Notation "'LITV' '┆' v " :=
  (LitV v)
    (in custom val at level 200,
     v constr at level 200).

Notation "'PAIRV' '┆' v1 '┆' v2" :=
  (PairV v1 v2)
    (in custom val at level 200,
     v1 constr at level 200,
     v2 constr at level 200).

Section valtest.
  Parameter x: val.
  Check (LitV 1).
  Check (InjLV x).
  Check (PairV (LitV 1) (LitV 2)).
  Check (PairV x (LitV 2)).
  Check (PairV x x).
  Check (PairV x (InjLV x)).
End valtest.
