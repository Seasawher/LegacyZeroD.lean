import SciLean.Data.DataArray
import SciLean.Tactic.InferVar

/- ### 1.5.6 要素へのアクセス -/
namespace Chapter156

open SciLean

def X := ⊞[51.0, 55.0; 14.0, 19.0; 0.0, 4.0]
#eval X

-- 本当はゼロ行目をとるつもりだったのだが，１番目の要素になってしまった
#eval X[0]

-- X[0] はこういうものとして解釈される
#eval X[0, 0]

-- TODO: ゼロ行目を取得する適切な方法は?

-- 現状ではこれがゼロ行目を取得する最も簡単な方法かな
#eval ⊞ i => X[0, i]

-- (0, 1) の要素
#eval X[0, 1]

-- これだとすべての要素を順に出すだけになってしまう
-- 「すべての行」にはなってくれない
#eval show IO Unit from
  for row in X do
    IO.println row

-- TODO: 行列の「すべての行成分」を取得する適切な方法を調べる
variable {α : Type} [pd : PlainDataType α] {ι : Type} [IndexType.{0,0} ι]

/-- すべての行を取得する関数 -/
def _root_.SciLean.DataArrayN.rows {m n : Nat} (xs : DataArrayN α (Fin m × Fin n)) : Array (DataArrayN α (Fin n)) := Id.run do
  let mut array := #[]
  for h : i in [0:m] do
    let i : Fin m := ⟨i, h.right⟩
    let row := ⊞ j => xs[i, j]
    array := array.push row
  return array

#eval X.rows

#eval show IO Unit from
  for row in X.rows do
    IO.println row

-- flatten 関数に相当するものもどこにあるのかわからないので自作する

def _root_.SciLean.DataArrayN.flatten (xs : DataArrayN α ι) {m : Nat} (h : m = IndexType.card ι := by infer_var) : DataArrayN α (Fin m) := by
  rw [h]
  exact xs.reshape (Fin (IndexType.card ι)) (by sorry_proof)

-- DataArrayN Float (Fin 6) という型になってほしいのにならない
-- flatten 失格である
/-- info: X.flatten ⋯ : DataArrayN Float (Fin (IndexType.card (Fin 3) * IndexType.card (Fin 2))) -/
#guard_msgs in #check X.flatten

-- simp 補題を追加する
@[simp] theorem IndexType.card_fin (n : Nat) : IndexType.card (Fin n) = n := by rfl

-- ちゃんと shape が Fin 6 になった！
#check X.flatten

end Chapter156
