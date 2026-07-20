set lazy
set lists
set unstable
# set default-list
set ignore-comments

# set shell := ["fish", "-c"]

host := "bamibal"

export GITHUB_TOKEN := env("GITHUB_TOKEN", `gh auth token`)

[no-exit-message]
default:
  just remote \
    "just update" \
    "just push 'bamibal:/etc/nixos'" \
    "just switch"

[no-exit-message]
remote *args="just switch": push
  ssh haring -qtR 2345:localhost:22  "cd nixos && {{ join_list(args, ' && ') }}"

update *args:
  nom flake update --access-tokens "github.com=$GITHUB_TOKEN" {{ args }}

sync from to:
  rsync -az --exclude "result" --delete --out-format '%n' {{ from }} {{ to }} | awk '!/(\/$|\.git|\.jj)/'

push to="haring:nixos": (sync "." to)

pull from="bamibal:/etc/nixos/": (sync from ".")

[arg('host', long="host", short="c", help="which host configuration to build")]
build host=host *args:
  nom build .#nixosConfigurations.{{ host }}.config.system.build.toplevel --print-out-paths {{ args }}

[no-exit-message]
switch host=host *args: (build host args)
  just copy
  test "$(realpath ./result)" != "$(ssh {{ host }} realpath /run/current-system)"
  # https://github.com/NixOS/nixpkgs/issues/82851
  ssh -qt {{ host }} \
    "dix --color=always /run/current-system $(realpath ./result) && \
    sudo nix build --no-link --profile /nix/var/nix/profiles/system $(realpath ./result) && \
    sudo $(realpath ./result)/bin/switch-to-configuration switch"

copy host=host:
  #!/usr/bin/env -S parallel --shebang --line-buffer
  nix copy ./result --to "ssh://{{ host }}?compress=true" -s
  nix copy ./result --derivation --to "ssh://{{ host }}?compress=true" -s

eval host=host *args:
  nix eval --raw {{ args }} .#nixosConfigurations.{{ host }}.config.system.build.toplevel

bench-eval-time host=host: push
  ssh haring -t nix-hyperfine --eval ./nixos#nixosConfigurations.{{ host }}.config.system.build.toplevel -- -w2 -r3

bench-eval-time-local host=host:
  time nix eval --no-eval-cache .#nixosConfigurations.{{ host }}.config.system.build.toplevel
