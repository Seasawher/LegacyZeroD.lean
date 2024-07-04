import Lake
open Lake DSL

package «ZeroD» where
  -- add package configuration options here
  leanOptions := #[
    ⟨`autoImplicit, false⟩,
    ⟨`relaxedAutoImplicit, false⟩
  ]

@[default_target]
lean_lib «ZeroD» where
  -- add library configuration options here
  globs := #[.submodules `ZeroD]
