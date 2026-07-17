{ config, lib, ... }: {
  options = {
    modules.hardware.gpus.nvidia.enable = lib.mkEnableOption "NVIDIA GPU support";
  };

  config = lib.mkIf config.modules.hardware.gpus.nvidia.enable {
    hardware = {
      nvidia = {
        open = true;

        prime.offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };

      nvidia-container-toolkit.enable = true;
    };

    services.xserver.videoDrivers = [ "nvidia" "modesetting" "fbdev" ];

    programs = {
      sway.extraOptions = [ "--unsupported-gpu" ];

      # PRIME Render Offload
      gamescope.env = {
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
      };
    };
  };
}
