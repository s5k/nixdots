#!/usr/bin/env bash
#
# setup-integration-tests.sh
# Prepares Magento 2 integration test configuration.
#

set -euo pipefail

ENV_FILE="app/etc/env.php"
CONFIG_DIR="dev/tests/integration/etc"
CONFIG_DIST="$CONFIG_DIR/install-config-mysql.php.dist"
CONFIG_TARGET="$CONFIG_DIR/install-config-mysql.php"
PHPUNIT_DIST="dev/tests/integration/phpunit.xml.dist"
PHPUNIT_TARGET="dev/tests/integration/phpunit.xml"

# --- Step 1: Verify required files ---
if [ ! -f "$ENV_FILE" ]; then
  echo "❌ Missing $ENV_FILE. Run Magento install first."
  exit 1
fi

if [ ! -f "$CONFIG_DIST" ]; then
  echo "❌ Missing $CONFIG_DIST. Cannot continue."
  exit 1
fi

# --- Step 2: Copy base config ---
cp "$CONFIG_DIST" "$CONFIG_TARGET"

# --- Step 3: Rewrite DB config inside install-config-mysql.php ---
php <<'PHP'
<?php
$envFile = 'app/etc/env.php';
$configFile = 'dev/tests/integration/etc/install-config-mysql.php';

// load db creds from env.php
$env = include $envFile;
$db = $env['db']['connection']['default'];
$dbNameIntegration = $db['dbname'] . '_integration_test';

// load existing integration config (copied from .dist)
$config = include $configFile;

// update db settings
$config['db-host'] = $db['host'];
$config['db-user'] = $db['username'];
$config['db-password'] = $db['password'];
$config['db-name'] = $dbNameIntegration;

// comment out AMQP entries (remove them from array)
foreach (array_keys($config) as $key) {
    if (strpos($key, 'amqp-') === 0) {
        unset($config[$key]);
    }
}

// rewrite PHP file
$content = "<?php\n\nreturn " . var_export($config, true) . ";\n";
file_put_contents($configFile, $content);

echo "✅ Wrote $configFile with DB {$dbNameIntegration}\n";
PHP

# --- Step 4: Copy phpunit.xml ---
if [ ! -f "$PHPUNIT_TARGET" ]; then
  cp "$PHPUNIT_DIST" "$PHPUNIT_TARGET"
  echo "✅ Copied $PHPUNIT_TARGET"
else
  echo "ℹ️  $PHPUNIT_TARGET already exists, skipping copy."
fi

echo "🎉 Integration test environment ready. Run: vendor/bin/phpunit -c dev/tests/integration/phpunit.xml"
