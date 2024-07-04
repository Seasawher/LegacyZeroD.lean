import SciLean.Data.DataArray
import SciLean.Tactic.InferVar

/- ## 1.5 NumPy
Lean で NumPy に相当するライブラリとして SciLean というのがある-/

/- ### 1.5.2 NumPy 配列の生成 -/
namespace Chapter152

-- np.array に相当するかも
#check SciLean.DataArrayN

open SciLean

def x := ⊞[1.0, 2.0, 3.0]

def y := ⊞[2.0, 4.0, 6.0]

#eval x + y

#eval x - y

-- 要素ごとの積になる
#eval x * y

-- 要素ごとの商になる
#eval x / y

-- こういう書き方はできない
#check_failure x / 2.0

-- 一応これでできる
#eval x.mapMono (· / 2.0)

-- これもできない
#check_failure 2 * x

end Chapter152

/- ### 1.5.4 NumPy の N 次元配列 -/
namespace Chapter154

open SciLean

set_option linter.hashCommand false

#check DataArrayN

def A := ⊞[1.0, 2.0; 3.0, 4.0]
def C := ⊞[1.0, 2.0]

#eval A

variable {α : Type} [pd : PlainDataType α] {ι : Type} [IndexType.{0,0} ι]

def _root_.SciLean.DataArrayN.shape (_xs : DataArrayN α ι) := ι

-- shape を出力するコマンドを作ってみる
-- そんなに需要はないかも
macro "#shape" F:term : command => `(#reduce SciLean.DataArrayN.shape $F)

#shape A

def B := ⊞[3.0, 0.0; 0.0, 6.0]

#eval A + B

-- 要素ごとに計算が行われる
#eval A * B

-- ブロードキャストによるスカラー倍はできない
#check_failure C * A

variable {α : Type} [pd : PlainDataType α] {ι : Type} [IndexType.{0,0} ι]

scoped instance [Mul α] : HMul α (DataArrayN α ι) (DataArrayN α ι) where
  hMul x xs := xs.mapMono (x * ·)

/-
{ hMul := fun x xs => xs.mapMono fun x_1 => x * x_1 }
-/
#whnf (inferInstance : HMul Float (DataArrayN Float (Fin 2)) (DataArrayN Float (Fin 2)))

-- あれ？なんでできないんだろう?
-- TODO: 失敗する理由を理解する
#check_failure 10.0 * C

end Chapter154

/- ### 1.5.5 ブロードキャスト -/
namespace Chapter155

open SciLean

def A := ⊞[1.0, 2.0; 3.0, 4.0]
def B := ⊞[10.0, 20.0]

-- ブロードキャストはできない
#check_failure A * B

-- reshape もできない．
-- サイズが異なるので
#check B.reshape (Fin 2 × Fin 2) (by sorry)

-- B をコピーすることによって Fin 2 × Fin 2 の要素を作りたい
-- 簡単に行う方法はなさそうなので自作
-- TODO: これを簡単に行う方法を作る
def B' : DataArrayN Float (Fin 2 × Fin 2) := ⊞ i j => B[j]
#eval B'

#eval A * B'

end Chapter155

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
-- TODO: flatten をきちんと実装する

/-- info: X.flatten ⋯ : DataArrayN Float (Fin (IndexType.card (Fin 3) * IndexType.card (Fin 2))) -/
#guard_msgs in #check X.flatten

end Chapter156
