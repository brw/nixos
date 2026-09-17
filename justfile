set lazy
set lists
set unstable
# set default-list
set ignore-comments

# set shell := ["fish", "-c"]

hostname := "bamibal"

export GITHUB_TOKEN := env("GITHUB_TOKEN", `gh auth token`)

[no-exit-message]
default:
  just remote \
    "just update" \
    "just push 'bamibal:/etc/nixos' --update" \
    "just switch"

[no-exit-message]
remote *args="just switch": push
  ssh haring -qtR 2345:localhost:22  "cd nixos && {{ join_list(args, ' && ') }}"

[no-exit-message]
switch-remote *args:
  just remote "just switch {{ args }}"

update *args:
  nix flake update --access-tokens "github.com=$GITHUB_TOKEN" {{ args }}

sync from to *args:
  rsync -az {{args}} --exclude "result" --delete --out-format '%n' {{ from }} {{ to }} | awk '!/(\/$|\.git|\.jj)/'

push to="haring:nixos" *args: (sync "." to args)

pull from="bamibal:/etc/nixos/" *args: (sync from "." args)

[arg('hostname', long, short="c", help="host configuration to build")]
[arg('nix', long, help="nix command/wrapper to use")]
build hostname=hostname nix="nom" *args:
  # nix flake prefetch-inputs
  nix flake archive
  {{ nix }} build .#nixosConfigurations.{{ hostname }}.config.system.build.toplevel --print-out-paths --show-trace {{ args }}

[no-exit-message]
[arg('hostname', long, short="c", help="host configuration to switch to")]
[arg('nix', long, help="nix command/wrapper to use")]
switch hostname=hostname nix="nom" *args: (build hostname nix args)
  if test "$(hostname)" != "{{ hostname }}"; then just copy; fi
  test "$(realpath ./result)" != "$(ssh {{ hostname }} realpath /run/current-system)"
  # https://github.com/NixOS/nixpkgs/issues/82851
  ssh -qt {{ hostname }} \
    "dix --color=always /run/current-system $(realpath ./result) && \
    sudo nix build --no-link --profile /nix/var/nix/profiles/system $(realpath ./result) && \
    sudo $(realpath ./result)/bin/switch-to-configuration switch"

[arg('hostname', long, short="c", help="hostname to copy to")]
copy hostname=hostname:
  #!/usr/bin/env -S parallel --shebang --line-buffer
  nix copy ./result --to "ssh-ng://{{ hostname }}?compress=true" -s
  nix copy ./result --derivation --to "ssh-ng://{{ hostname }}?compress=true" -s

[arg('hostname', long, short="c", help="host configuration to evaluate")]
eval hostname=hostname *args:
  nix eval --raw {{ args }} .#nixosConfigurations.{{ hostname }}.config.system.build.toplevel

[arg('hostname', long, short="c", help="host configuration to benchmark")]
bench-eval-time hostname=hostname: push
  ssh haring -t nix-hyperfine --eval ./nixos#nixosConfigurations.{{ hostname }}.config.system.build.toplevel -- -w2 -r3

[arg('hostname', long, short="c", help="host configuration to benchmark")]
bench-eval-time-local hostname=hostname:
  nix-hyperfine --eval .#nixosConfigurations.{{ hostname }}.config.system.build.toplevel -- -w2 -r3

diff one two:
  nix-diff --character-oriented --context=1 --color=always {{ one }} {{ two }} | cut -c-1000
