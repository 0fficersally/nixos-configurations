# GPU Vendors
{ ... }: {
  imports = [
    ./amd.nix
    ./nvidia.nix
  ];
}
