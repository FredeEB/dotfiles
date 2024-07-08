{ pkgs, config, lib, modulesPath, ... }: {
  imports = [
    ../common/desktop.nix
    ../modules/default-system-layout.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "amdgpu" "kvm-amd" "wl" "b43" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    rocmPackages.clr.icd
  ];
  networking = {
    interfaces.enp39s0.wakeOnLan.enable = true;
    hostName = "dt";
    useDHCP = lib.mkDefault true;
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
