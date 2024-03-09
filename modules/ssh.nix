{ pkgs, ... }:
{
    services.openssh = {
        enable = true;
        settings = {
            AllowUsers = ["bun"];
            PasswordAuthentication = false;
        };
    };
}
