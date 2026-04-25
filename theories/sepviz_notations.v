From iris.heap_lang Require Import lang proofmode notation.

Declare Scope sepviz_scope.


(** ** Separation-logic formulas: heap props *)

Declare Custom Entry sep.

Notation "⟬ e ⟭" :=
  (e)
    (e custom sep at level 200, at level 0): sepviz_scope.

Notation "'Pure' ┆ P" :=
  (bi_pure P)
    (in custom sep at level 200,
     P constr at level 200): sepviz_scope.

Notation "'PointsTo' ┆ l ┆ v ┆ dq " :=
  (pointsto l dq v)
    (in custom sep at level 200,
     l constr, dq constr, v constr at level 200): sepviz_scope.

Notation "'Star' ┆ H1 ┆ H2" :=
  (bi_sep H1 H2)
    (in custom sep at level 200,
     H1 constr, H2 constr at level 200): sepviz_scope.

Notation "'Wand' ┆ H1 ┆ H2" :=
  (bi_wand H1 H2)
    (in custom sep at level 200,
     H1 constr, H2 constr at level 200): sepviz_scope.

Notation "'Later' ┆ H" :=
  (bi_later H)
    (in custom sep at level 200,
     H constr at level 200): sepviz_scope.

Notation "'Exist' ┆ x ┆ H" :=
  (bi_exist (fun x => H))
    (in custom sep at level 200,
     x constr, H constr at level 200): sepviz_scope.

Notation "⟬* 'PRE' @ P *⟭ e 'RET' pat ; ⟬* 'POST' @ Q *⟭" :=
  (∀ Φ, P -∗ ▷ (Q -∗ Φ pat%V) -∗ WP e {{ Φ }})
    (format "'⟬*'  'PRE'  '@'  P  '*⟭' '//' e '//' 'RET'  pat ; '//' '⟬*'  'POST'  '@'  Q  '*⟭'"): sepviz_scope.

Notation "Γ ⟬* H : P *⟭" := (environments.Esnoc Γ (INamed H) P%I)
  (at level 1, P at level 200,
  left associativity, format "Γ ⟬*  H  :  P  *⟭ '//'", only printing) : sepviz_scope.

Section septest.
  Open Scope sepviz_scope.
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

Notation "⟦ e ⟧" :=
  (e)
    (e custom val at level 200, at level 0): sepviz_scope.

Notation "'$LitV' ┆ v " :=
  (LitV v)
    (in custom val at level 200,
     v constr at level 200): sepviz_scope.

Notation "'$PairV' ┆ v1 ┆ v2" :=
  (PairV v1 v2)
    (in custom val at level 200,
     v1 constr, v2 constr at level 200): sepviz_scope.

Section valtest.
  Parameter x: val.
  Check (LitV 1).
  Check (InjLV x).
  Check (PairV (LitV 1) (LitV 2)).
  Check (PairV x (LitV 2)).
  Check (PairV x x).
  Check (PairV x (InjLV x)).
End valtest.
