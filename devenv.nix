{ pkgs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";


  # add pre-commit hooks
  pre-commit.hooks = {
    # lint shell scripts
    shellcheck.enable = true;
    # execute example shell from Markdown files
    mdsh.enable = true;
    # format Python code
    black.enable = true;
  };


  # add processes as entrypoint in container
  name = "myapp";

  packages = [ pkgs.procps ];

  processes.hello-docker.exec = "while true; do echo 'Hello Docker!' && sleep 1; done";
  processes.hello-nix.exec = "while true; do echo 'Hello Nix!' && sleep 1; done";

  # Exclude the source repo to make the container smaller.
  containers."processes".copyToRoot = null; 


  # add services
  services.postgres = {
    enable = true;
    package = pkgs.postgresql_15;
    initialDatabases = [{ name = "mydb"; }];
    extensions = extensions: [
      extensions.postgis
      extensions.timescaledb
    ];
    settings.shared_preload_libraries = "timescaledb";
    initialScript = "CREATE EXTENSION IF NOT EXISTS timescaledb;";
  };

  # add processes
  processes = {
    silly-example.exec = "while true; do echo hello && sleep 1; done";
    ping.exec = "ping google.com";
  };


  # define languages
  languages.python.enable = true;
  languages.python.version = "3.8";
  languages.rust.enable = true;
  languages.rust.channel = "stable";




  # define script and enter into shell 
  scripts.hello.exec = "echo hello from $GREET";

  enterShell = ''
    hello
    rustc --version
    python3.8 --version
  '';

}
