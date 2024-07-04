import Lake
open Lake DSL

package «ZeroD» where
  -- add package configuration options here

lean_lib «ZeroD» where
  -- add library configuration options here

@[default_target]
lean_exe «zerod» where
  root := `Main
