/- # 1 章 Python 入門 -/
import Lean
import SciLean.Data.DataArray
import SciLean.Tactic.InferVar


/- ### 1.3.1 算術計算 -/

-- これはゼロになってしまう
#guard 1 - 2 = 0

#guard (1 - 2 : Int) = -1

#guard 4 * 5 = 20

-- これは１になってしまう
#guard 7 / 5 = 1

-- Float として計算しないと値は Float にならない
#eval (7 / 5 : Float)

-- べき乗
#guard 3 ^ 2 = 9


/- ### 1.3.2 データ型
省略．
-/


/- ### 1.3.3 変数
省略
-/


/- ### 1.3.4 リスト -/
namespace Chapter134

-- 配列（Python のリストは Lean の配列に相当しそう）
def a := #[1, 2, 3, 4, 5]

#eval a

-- リストの長さを取得する
#eval a.size

-- 最初の要素にアクセス
#eval a[0]

#eval a[4]

-- 値の代入（っぽいもの．実際には代入していない）
#eval a.set! 4 99

-- Python と似たような記法が使えるが，
-- 以下のように表示されてしまう.
-- これは嬉しくない
/-- info: #[1, 2].toSubarray -/
#guard_msgs in #eval a[0:2]

-- Subarray というのがある！
#check Subarray

-- array フィールドを使うと，元の配列が表示される
-- これは欲しいものではない
#eval a[0:2].array

-- toArray という関数があり，それでスライス先を表示できる
-- 0 ≤ i < 2 番目の要素を表示する
#eval a[0:2].toArray

-- こうやっても中身を表示できる
#eval (a[0:2] : Array Nat)

-- ToString インスタンスはこういうのになっている
#eval s!"{a[0:2]}"

-- インデックスの1から最後まで
#eval (a[1:] : Array Nat)

-- 最初からインデックスの３番目まで（３番目は含まない）
#eval (a[:3] : Array Nat)

-- Lean ではこういう書き方はできない
#check_failure a[:-1]

-- やるとしたらこうかな？
-- Julia だと `a[:end-1]` みたいな書き方をするよね
#eval (a[:a.size-1] : Array Nat)

#eval (a[:a.size-2] : Array Nat)

end Chapter134


/- ### 1.3.5 ディクショナリ -/
namespace Chapter135

open Lean

-- 文字列をキーとしてNatを値とする辞書の型
#check HashMap String Nat

-- リストからHashMapを作ることができる
def me := HashMap.ofList [("height", 180)]

-- 要素にアクセスすることができるが，
-- 当然返り値が Option に包まれている．
#guard me["height"] = some 180

-- Option に包まれた値を取り出す関数
-- none だった場合は Inhabited.default を使う
#check Option.get!

-- これをすると Option の値を取り出せる
#guard me["height"].get! = 180

-- 新しい要素を追加する
def me' := me.insert "weight" 70

-- 普通に #eval に渡すことはできない．
#guard_msgs (drop error) in #eval me'

-- toList をかませば表示できる
-- ほかの方法もありそう
#eval me'.toList

end Chapter135


/- ### 1.3.6 ブーリアン -/
namespace Chapter136

-- Lean ではBooleanは小文字
def hungry := true
def sleepy := false

#check hungry

-- 否定
#guard not hungry = false

-- これも否定
#guard ! hungry = false

-- 論理積
-- ∧ はProp用で，&&はBool用
#eval hungry ∧ sleepy
#eval hungry && sleepy

-- 論理和
#eval hungry ∨ sleepy
#eval hungry || sleepy

end Chapter136


/- ### 1.3.7 if 文 -/
namespace Chapter137

-- Lean にも if 文が一応ある

-- これは Prop
def hungry := true

def main (cond : Bool) : IO Unit :=
  if cond then
    IO.println "I'm hungry"
  else do
    IO.println "I'm not hungry"
    IO.println "I'm sleepy"

#eval main hungry

#eval main (! hungry)

end Chapter137


/- ### 1.3.8 for文 -/
namespace Chapter138

-- Lean にもfor 文はあって，do構文の一部として提供されています

def main : IO Unit :=
  for i in [1:4] do
    IO.println s!"{i}"

#eval main

end Chapter138


/- ### 1.3.9 関数 -/
namespace Chapter139

def hello := IO.println "Hello, world!"

#eval hello

-- 文字列の連結は ++ で行う
def hello' (name : String) : IO Unit :=
  IO.println <| "Hello, " ++ name ++ "!"

#eval hello' "cat"

end Chapter139

/- ## Python スクリプトファイル -/

/- ### 1.4.1 ファイルに保存

以下を実行する:
```bash
lean --run ZeroD/Hungry.lean
```

see: Hungry.lean
-/

/- ### 1.4.2 クラス

Lean には Python のクラスに相当するものはない.
近いもので近似することはできる．

```bash
lean --run ZeroD/Hungry.lean
```

see: Man.lean
-/

/- ## 1.5 NumPy
Lean で NumPy に相当するライブラリとして SciLean というのがある
-/


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

#eval A

-- shape 関数の実装は見つからず，自前で作るのも難しかったのでいったん断念
-- これは TODO として残しておく
def B := ⊞[3.0, 0.0; 0.0, 6.0]

#eval A + B

-- 要素ごとに計算が行われる
#eval A * B

-- ブロードキャストによるスカラー倍はできない
#check_failure A * 10

variable {α : Type} [pd : PlainDataType α] {ι : Type} [IndexType.{0,0} ι]

scoped instance [Mul α] : HMul α (DataArrayN α ι) (DataArrayN α ι) where
  hMul x xs := ⊞ i => x * xs[i]

-- あれ？なんでできないんだろう?
-- TODO: 失敗する理由を理解する
#check_failure 10 * A

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

-- TODO: 行列の「すべての行成分」を取得する方法を調べる
-- 現状，無理そうに思える

-- flatten 関数に相当するものもどこにあるのかわからないので自作する

variable {α : Type} [pd : PlainDataType α] {ι : Type} [IndexType.{0,0} ι]

def _root_.SciLean.DataArrayN.flatten (xs : DataArrayN α ι) {m : Nat} (h : m = IndexType.card ι := by infer_var) : DataArrayN α (Fin m) := by
  rw [h]
  exact xs.reshape (Fin (IndexType.card ι)) (by sorry_proof)

-- DataArrayN Float (Fin 6) という型になってほしいのにならない
-- flatten 失格である
-- TODO: flatten をきちんと実装する

/-- info: X.flatten ⋯ : DataArrayN Float (Fin (IndexType.card (Fin 3) * IndexType.card (Fin 2))) -/
#guard_msgs in #check X.flatten

end Chapter156
