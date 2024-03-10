{ pkgs, ... }: {
  rebase-base = "log $(${pkgs.git}/bin/git merge-base HEAD $1)..$1";
}
