{ pkgs, inputs, ... }:
{
  _module.args.overrides = import ../overrides { inherit pkgs inputs; };
}
