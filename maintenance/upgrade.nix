{ config, pkgs, ... }:
let
    str = pkgs.lib.strings;

    grabVers = s: 
        let 
            groups = builtins.match "Boltv([[:digit:]]+).([[:digit:]]+).([[:digit:]]+)" s;
            res = if groups != null then groups else ["0" "0" "0"];
        in 
            res;
    weight = l: 
        str.toInt ( str.elemAt (grabVers l) 0) * 1000000 + str.toInt ( str.elemAt (grabVers l) 1) * 10000 + str.toInt ( str.elemAt (grabVers l) 2);

    list = builtins.attrNames (builtins.readDir /nix/var/nix/profiles/system-profiles);
    recent = builtins.sort (a: b: (weight a) > (weight b) ) list;
    mostrecent = grabVers (builtins.elemAt recent 0);
    addtopatch = [(builtins.elemAt mostrecent 0) (builtins.elemAt mostrecent 1) (builtins.toString (str.toInt (builtins.elemAt mostrecent 2) + 1))];
in
{
    system.autoUpgrade = {
         enable = true;
         channel = https://nixos.org/channels/nixos-unstable;
         operation = "switch";
         flags = [
		"-p"
		"Boltv${builtins.elemAt addtopatch 0}.${builtins.elemAt addtopatch 1}.${builtins.elemAt addtopatch 2}"	
	 ];
    };
}
