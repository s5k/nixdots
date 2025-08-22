#!/usr/bin/env bash
#
# setup-integration-tests.sh
# Prepares Magento 2 integration test configuration.
#

set -euo pipefail

CONFIG_DIR="dev/tests/integration/etc"
CONFIG_DIST="$CONFIG_DIR/install-config-mysql.php.dist"
CONFIG_TARGET="$CONFIG_DIR/install-config-mysql.php"

# Ensure config directory exists
if [[ ! -d "$CONFIG_DIR" ]]; then
  echo "❌ Integration test config dir not found: $CONFIG_DIR"
  exit 1
fi

# Ensure env.php exists
if [[ ! -f "app/etc/env.php" ]]; then
  echo "❌ app/etc/env.php not found. Run Magento setup first."
  exit 1
fi

# Read DB credentials directly with PHP
DB_HOST=$(php -r '$env = include "app/etc/env.php"; echo $env["db"]["connection"]["default"]["host"] ?? "localhost";')
DB_USER=$(php -r '$env = include "app/etc/env.php"; echo $env["db"]["connection"]["default"]["username"] ?? "root";')
DB_PASS=$(php -r '$env = include "app/etc/env.php"; echo $env["db"]["connection"]["default"]["password"] ?? "";')
DB_NAME=$(php -r '$env = include "app/etc/env.php"; echo $env["db"]["connection"]["default"]["dbname"] ?? "magento";')

DB_NAME="${DB_NAME}_integration_test"

# Copy fresh template if missing
if [[ ! -f "$CONFIG_TARGET" ]]; then
  cp "$CONFIG_DIST" "$CONFIG_TARGET"
  echo "✅ Copied template to $CONFIG_TARGET"
fi

# Patch values safely with perl (inline replace)
perl -pi -e "s/'db-host'\s*=>\s*'.*?'/'db-host' => '$DB_HOST'/;" "$CONFIG_TARGET"
perl -pi -e "s/'db-user'\s*=>\s*'.*?'/'db-user' => '$DB_USER'/;" "$CONFIG_TARGET"
perl -pi -e "s/'db-password'\s*=>\s*'.*?'/'db-password' => '$DB_PASS'/;" "$CONFIG_TARGET"
perl -pi -e "s/'db-name'\s*=>\s*'.*?'/'db-name' => '$DB_NAME'/;" "$CONFIG_TARGET"

# Comment out AMQP lines
perl -pi -e "s/^(\s*'amqp-.*)/\/\/ \$1/" "$CONFIG_TARGET"

# Ensure phpunit.xml exists
PHPUNIT_DIST="dev/tests/integration/phpunit.xml.dist"
PHPUNIT_TARGET="dev/tests/integration/phpunit.xml"
if [[ ! -f "$PHPUNIT_TARGET" ]]; then
  cp "$PHPUNIT_DIST" "$PHPUNIT_TARGET"
  echo "✅ Copied PHPUnit template to $PHPUNIT_TARGET"
fi

echo "🎉 Integration test setup complete."
echo "👉 DB: $DB_USER@$DB_HOST / $DB_NAME"