{
  mkShell,
  alejandra,
  jq,
  zig2nix,
  system,
}:
mkShell {
  name = "malum";

  packages = [
    # For builds
    jq
    zig2nix.packages.${system}.zon2nix
    alejandra
  ];
}
