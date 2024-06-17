{
  pkgs,
  user,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "dev-shell" ''
      if [ ''$# -gt 0 ]; then
          nix develop "/home/${user}/.nix#''$@"
      else
          nix develop ''$@
      fi
    '')
    (pkgs.writeShellScriptBin "generate-cert" ''
      domain=$1

      if [ -z "$2" ]; then
        # If the second argument is empty, set it to the current working directory
        directory=$(pwd)
      else
        # Use the provided second argument
        directory="$2"
      fi

      # Generate certificate
      ${pkgs.mkcert}/bin/mkcert -key-file "''${directory}/certs/''${domain}.key" -cert-file "''${directory}/certs/''${domain}.crt" "''${domain}" "*.''${domain}"

      # Append to ssl.yml
      echo "    - certFile: /etc/traefik/certs/''${domain}.crt" | tee -a ''${directory}/conf/traefik/ssl.yml
      echo "      keyFile: /etc/traefik/certs/''${domain}.key" | tee -a ''${directory}/conf/traefik/ssl.yml
    '')
  ];
}
