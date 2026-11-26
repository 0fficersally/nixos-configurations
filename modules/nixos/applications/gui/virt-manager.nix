# Virtual Machine Manager
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.gui.virt-manager.enable = lib.mkEnableOption "the virt-manager virtual machine manager";
  };

  config = lib.mkIf config.modules.applications.gui.virt-manager.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu.swtpm.enable = true; # TPM Emulation
    };

    programs.virt-manager.enable = true;

    # QEMU

    environment.systemPackages = with pkgs; [
      qemu
    ];

    systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ]; # UEFI Firmware Support
  };
}
