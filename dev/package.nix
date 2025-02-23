{
  lib,
  stdenv,
  callPackage,
  git,
  zig_0_13,
  revision ? "dirty",
  optimize ? "Debug",
}: let
  zig_hook = zig_0_13.hook.overrideAttrs {
    zig_default_flags = "-Dcpu=baseline -Doptimize=${optimize} --color off";
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "malum";
    version = "0.1.0";

    src = lib.fileset.toSource {
      root = ../.;
      fileset = lib.fileset.intersection (lib.fileset.fromSource (lib.sources.cleanSource ../.)) (
        lib.fileset.unions [
          ../src
          ../build.zig
          ../build.zig.zon
          ../build.zig.zon.nix
        ]
      );
    };

    deps = callPackage ../build.zig.zon.nix {name = "malum-cache-${finalAttrs.version}";};

    nativeBuildInputs = [
      git
      zig_hook
    ];

    dontConfigure = true;

    zigBuildFlags = [
      "--system"
      "${finalAttrs.deps}"
      "-Dversion-string=${finalAttrs.version}-${revision}-nix"
    ];

    outputs = [
      "out"
    ];

    meta = {
      homepage = "https://github.com/kawaranaide/malum";
      license = lib.licenses.mit;
      platforms = [
        "x86_64-linux"
      ];
      mainProgram = "malum";
    };
  })
