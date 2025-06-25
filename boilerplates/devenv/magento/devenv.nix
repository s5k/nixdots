{ inputs, pkgs, lib, config, ... }:
let
  pkgs-stable = import inputs.nixpkgs-stable { system = pkgs.stdenv.system; };
  php-xhprof = pkgs-stable.php82.buildPecl rec {
    pname = "xhprof";
    version = "2.3.10";
    sha256 = "JRrumcJybrxhJuH/C7Lbbi1f0iBWqjNehNufEFXVnZU=";
    sourceRoot = "xhprof-2.3.10/extension";
    buildInputs = [ pkgs.pcre2 ];
  };
in
{
  dotenv.disableHint = true;
  packages = [ pkgs.git pkgs.gnupatch pkgs.n98-magerun2 pkgs.nodejs_18 pkgs.nodePackages_latest.grunt-cli ];

  languages.php.enable = true;
  languages.php.package = pkgs-stable.php82.buildEnv {
    extensions = { all, enabled }: with all; enabled ++ [ xdebug xsl redis php-xhprof ];
    extraConfig = ''
      memory_limit = -1
      realpath_cache_ttl = 3600
      session.gc_probability = 0
      ${lib.optionalString config.services.redis.enable ''
      session.save_handler = redis
      session.save_path = "tcp://127.0.0.1:${toString config.services.redis.port}/0"
      ''}
      display_errors = On
      error_reporting = E_ALL
      assert.active = 0
      opcache.memory_consumption = 256M
      opcache.interned_strings_buffer = 20
      zend.assertions = 0
      short_open_tag = 0
      zend.detect_unicode = 0
      post_max_size = 32M
      upload_max_filesize = 32M

      xdebug.mode = "debug"
      xdebug.start_with_request = "trigger"
      xdebug.discover_client_host = 1
      xdebug.var_display_max_depth = -1
      xdebug.var_display_max_data = -1
      xdebug.var_display_max_children = -1

      #xdebug.mode = "profile"
      #xdebug.start_with_request = "yes"
      #xdebug.output_dir="/Users/hydra/Documents/projects/fulltime/magento/2.4/.devenv/state/php-fpm/xdebug/profiles";
      #xdebug.profiler_output_name=cachegrind.out.%p
    '';
  };
  languages.php.fpm.settings = {
    error_log = config.env.DEVENV_STATE + "/php-fpm/php-fpm.log";
    "emergency_restart_threshold" = 5;
    "emergency_restart_interval" = "1m";
    "process_control_timeout" = "10s";
  };
  languages.php.fpm.pools.web = {
    settings = {
      "clear_env" = "no";
      "pm" = "dynamic";
      "pm.max_children" = 20;
      "pm.start_servers" = 6;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 10;
    };
  };

  services.opensearch.enable = true;
  services.opensearch.package = pkgs.opensearch;

  services.mailhog.enable = true;
  services.redis.enable = true;
  services.redis.port = 6379;

  # Auto generete cert SSL for domain
  # certificates = [ DOMAIN ];

  # Add domain to /etc/hosts
  # hosts."${DOMAIN}" = "127.0.0.1";

  services.caddy.enable = true;
  # Remember always to add https://<domain>:<port> to the config, to avoid the redirect loop and delay.
  services.caddy.virtualHosts."https://example.local:443" = {
    extraConfig = ''
      encode zstd gzip
      root * example-dir/pub
      php_fastcgi unix/${config.languages.php.fpm.pools.web.socket} {
        trusted_proxies private_ranges
      }
      file_server
      encode

      @blocked {
        path /media/customer/* /media/downloadable/* /media/import/* /media/custom_options/* /errors/*
      }
      respond @blocked 403

      @notfound {
        path_regexp reg_notfound \/\..*$|\/errors\/.*\.xml$|theme_customization\/.*\.xml
      }
      respond @notfound 404

      @staticPath path_regexp reg_static ^/static/(version\d*/)?(.*)$
      handle @staticPath {
        @static file /static/{re.reg_static.2}
        rewrite @static /static/{re.reg_static.2}
        @dynamic not file /static/{re.reg_static.2}
        rewrite @dynamic /static.php?resource={re.reg_static.2}
      }

      @mediaPath path_regexp reg_media ^/media/(.*)$
      handle @mediaPath {
        @static file /media/{re.reg_media.1}
        rewrite @static /media/{re.reg_media.1}
        @dynamic not file /media/{re.reg_media.1}
        rewrite @dynamic /get.php?resource={re.reg_media.1}
      }

      encode zstd gzip
    '';
  };


  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb_105;
  services.mysql.settings.mysqld.port = 3306;
  services.mysql.settings.mysqld.innodb_buffer_pool_size = "10G";
  services.mysql.settings.mysqld.max_allowed_packet = "1073741824";
  services.mysql.initialDatabases = [{ name = "magento2"; }];
  services.mysql.ensureUsers = [
    {
      name = "magento2";
      password = "magento2";
      ensurePermissions = { "*.*" = "ALL PRIVILEGES"; };
    }
  ];

  # For development purposes not using cronjob
  processes = {
    # cronjob.exec = ''while true; do php ${MAGENTO_DIR}/bin/magento cron:run && sleep 60; done'';
    mysql = {
      process-compose = {
        shutdown.command = "killall -9 mysqld";
      };
    };

    # Run buggregator server with external docker container (you might install docker first via Nix, Orbstack, or Homebrew)
    buggregator = {
      exec = ''
        docker run --pull always \
          -p 127.0.0.1:8000:8000 \
          -p 127.0.0.1:1025:1025 \
          -p 127.0.0.1:9912:9912 \
          -p 127.0.0.1:9913:9913 \
          --rm \
          --name buggregator-devenv \
          ghcr.io/buggregator/server:latest
      '';
      process-compose = {
        shutdown.command = "docker stop buggregator-devenv";
      };
    };
  };
}
