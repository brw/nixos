{ pkgs, ... }:

{
  time.timeZone = "Europe/Amsterdam";

  i18n = {
    glibcLocales = pkgs.glibcLocales.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [
        # en_NL locale
        (pkgs.fetchpatch2 {
          url = "https://gist.githubusercontent.com/DarkDefender/746e06b05d31ab6cd74c5924d1f73ba7/raw/c5ebfd9b5397b26f3cd84f4f6b3db4b8d16205be/add_en_NL.patch";
          hash = "sha256-XXmQaa3BSNV7CYH6TcZyUOHlHJ1LUtqRQN9UYFKh1Og=";
        })
      ];
    });

    defaultLocale = "en_NL.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_NL.UTF-8";
      LC_IDENTIFICATION = "en_NL.UTF-8";
      LC_MEASUREMENT = "en_NL.UTF-8";
      LC_MONETARY = "en_NL.UTF-8";
      LC_NAME = "en_NL.UTF-8";
      LC_NUMERIC = "en_NL.UTF-8";
      LC_PAPER = "en_NL.UTF-8";
      LC_TELEPHONE = "en_NL.UTF-8";
      LC_TIME = "en_NL.UTF-8";
    };
  };
}
