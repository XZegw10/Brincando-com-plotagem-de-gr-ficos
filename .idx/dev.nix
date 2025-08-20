# To learn more about how to use Nix to configure your environment
# see: https://firebase.google.com/docs/studio/customize-workspace
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.05"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    # Base tools like Go, Python, and Node are likely pre-installed in IDX.
    # We only add packages that are missing.
    
    # PHP Environment
    pkgs.php83
    pkgs.php83Packages.composer
    pkgs.phpunit
    pkgs.phpactor
    pkgs.phpdocumentor

    # New Dev Tools
    pkgs.git-lfs
    pkgs.direnv
    pkgs.yq-go # For yaml processing
  ];

  # Sets environment variables in the workspace
  env = {};
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      # "vscodevim.vim"
      "DEVSENSE.composer-php-vscode"
      "DEVSENSE.intelli-php-vscode"
      "DEVSENSE.phptools-vscode"
      "DEVSENSE.profiler-php-vscode"
    ];

previews = {
    enable = true;
    previews = {
      web = {
        # O servidor agora serve a raiz do projeto para exibir a galeria de módulos.
        command = ["php" "-S" "0.0.0.0:$PORT"];
        
        manager = "web";
      };
    };
  };

    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        # Example: install JS dependencies from NPM
        # npm-install = "npm install";
      };
      # Runs when the workspace is (re)started
      onStart = {
        # Example: start a background task to watch and re-build backend code
        # watch-backend = "npm run watch-backend";
      };
    };
  };
}
