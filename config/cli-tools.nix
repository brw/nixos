{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    psmisc
    lsof
    e2fsprogs
    wget
    (htop.override { withVimKeys = true; })
    tmux
    stow
    tree
    ripgrep
    unzip
    fzf
    ncdu
    fd
    moreutils
    _7zip-zstd-rar
    atproto-goat
    glow
    gping
    tcpdump
    conntrack-tools
    mtr
    traceroute
    wait4x
    file
    parallel-full
    aria2
    hyperfine
    poop
    hl-log-viewer
    multitime
    multitail
    httptap
  ];
}
