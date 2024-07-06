{inputs, ...}: {
  perSystem = {
    config,
    lib,
    pkgs,
    system,
    inputs',
    self',
    ...
  }: let
    inherit (self'.packages) rust-toolchain;
    inherit (self'.legacyPackages) cargoExtraPackages;

    devTools = [
      pkgs.bacon
      pkgs.cargo-audit
      pkgs.cargo-udeps
      rust-toolchain
    ];
  in {
    devShells = {
      default = pkgs.mkShell rec {
        packages = devTools ++ cargoExtraPackages;

        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath packages;
        LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
        RUST_SRC_PATH = "${self'.packages.rust-toolchain}/lib/rustlib/src/rust/src";
        LIBCAMERA_IPA_PROXY_PATH = "${inputs'.libcamera.packages.libcamera}/libexec/libcamera";
        LIBPISP_BE_CONFIG_FILE = "${inputs'.libcamera.packages.libpisp}/share/libpisp/backend_default_config.json";
      };
    };
  };
}
