{
  cp = "cp -i";
  egrep = "egrep --color=auto";
  fgrep = "fgrep --color=auto";
  grep = "grep --color=auto";
  la = "ls -lah";
  ls = "ls --color=auto -FC";
  mv = "mv -i";
  rf = "rm -rf";
  dps = "docker ps -a";
  dcb =
    "COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose build --parallel";
  dcu = "docker-compose up";
  dcd = "docker-compose up -d";
  dck = "docker-compose down";
  dr = "docker restart";
  lzd =
    "docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock lazyteam/lazydocker";
  perf-rep = "perf report -g 'graph,0.5,caller'";
  perf-rec = "perf record -g";
  c = "clear";
  chat = "ssh bun@chat.shazow.net";
  z = "zathura";
  stowd = "stow -t/home/$USER -S *";
  lg = "lazygit";
  cdgr = "cd $(git rev-parse --show-toplevel)";
  shoot = "xprop | grep WM_PID | cut -d = -f 2 | xargs kill";
}
