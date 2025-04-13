{ pkgs ? import <nixpkgs> {}, lib ? pkgs.lib, version ? null, ... }:
let
  wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
  wl-paste = lib.getExe' pkgs.wl-clipboard "wl-paste";
  xclip = lib.getExe pkgs.xclip;
  php = lib.getExe pkgs.php;
  replaces = {
    "#!/usr/bin/env php" = "#!/usr/bin/env ${php}";
    "$tool = basename($result[0] ?? '');" = /* php */ ''
      if (getenv("XDG_SESSION_TYPE") == "wayland") {
        $tool = "wl-copy";
      } else {
        $tool = "xclip";
      }
    '';
    "= 'xclip"    = "= '${xclip}";
    "= 'wl-copy"  = "= '${wl-copy}";
    "= 'wl-paste" = "= '${wl-paste}";
  };
  script = pkgs.writeScriptBin "h-m-m" (let
    prevScript = lib.fileContents ./h-m-m;
  in if pkgs.stdenv.isDarwin then
    lib.replaceStrings [ "#!/usr/bin/env php" ] [ "#!/usr/bin/env ${php}" ] prevScript
  else
    lib.replaceStrings (lib.attrNames replaces) (lib.attrValues replaces) prevScript);
in script // lib.optionals (!isNull version) {
  inherit version;
} // {
  meta = script.meta // {
    description = "h-m-m is a keyboard-centric terminal-based tool for working with mind maps.";
	homepage = "https://github.com/nadrad/h-m-m";
	license = lib.licenses.gpl3;
  };
}
