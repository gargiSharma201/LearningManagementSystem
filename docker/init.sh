#!/bin/bash

set -e

BENCH_PATH="/home/frappe/frappe-bench"
LOCAL_LMS="/workspace/lms"

echo "======================================"
echo " Starting LearningMgnt Docker Setup"
echo "======================================"

# --------------------------------------------------
# Create Bench
# --------------------------------------------------

if [ -d "$BENCH_PATH/apps/frappe" ]; then
    echo "Bench already exists."
else
    echo "Creating new Frappe Bench..."

    export PATH="${NVM_DIR}/versions/node/v${NODE_VERSION_DEVELOP}/bin/:${PATH}"

    bench init \
        --skip-redis-config-generation \
        frappe-bench
fi

cd "$BENCH_PATH"

# --------------------------------------------------
# MariaDB
# --------------------------------------------------

echo "Configuring MariaDB..."

bench set-mariadb-host mariadb

# --------------------------------------------------
# Redis
# --------------------------------------------------

echo "Configuring Redis..."

bench set-redis-cache-host redis://redis:6379
bench set-redis-queue-host redis://redis:6379
bench set-redis-socketio-host redis://redis:6379

# Remove Redis and watch from Procfile
sed -i '/redis/d' ./Procfile
sed -i '/watch/d' ./Procfile

# --------------------------------------------------
# Payments
# --------------------------------------------------

if [ ! -d "$BENCH_PATH/apps/payments" ]; then
    echo "Installing Payments..."

    bench get-app payments
fi

# --------------------------------------------------
# LOCAL LEARNINGMGNT LMS
# --------------------------------------------------

echo "Checking local LMS..."

if [ ! -d "$LOCAL_LMS" ]; then
    echo "ERROR: Local LMS not found at $LOCAL_LMS"
    exit 1
fi

echo "Local LMS found at:"
echo "$LOCAL_LMS"

# Remove an existing LMS installation/symlink if necessary
if [ -e "$BENCH_PATH/apps/lms" ] || [ -L "$BENCH_PATH/apps/lms" ]; then
    echo "Removing existing LMS reference..."
    rm -rf "$BENCH_PATH/apps/lms"
fi

echo "Linking local LearningMgnt LMS..."

ln -s "$LOCAL_LMS" "$BENCH_PATH/apps/lms"

# --------------------------------------------------
# Verify LMS
# --------------------------------------------------

if [ ! -f "$BENCH_PATH/apps/lms/lms/hooks.py" ]; then
    echo "ERROR: LMS app structure is invalid."
    echo "Expected: $BENCH_PATH/apps/lms/lms/hooks.py"
    exit 1
fi

echo "Local LMS successfully linked."

# --------------------------------------------------
# Create Site
# --------------------------------------------------

if [ ! -d "$BENCH_PATH/sites/lms.localhost" ]; then

    echo "Creating LMS site..."

    bench new-site lms.localhost \
        --force \
        --mariadb-root-password 123 \
        --admin-password admin \
        --no-mariadb-socket
fi

# --------------------------------------------------
# Install Payments
# --------------------------------------------------

if ! bench --site lms.localhost list-apps | grep -q "^payments$"; then

    echo "Installing Payments..."

    bench --site lms.localhost install-app payments
fi

# --------------------------------------------------
# Install Local LMS
# --------------------------------------------------

if ! bench --site lms.localhost list-apps | grep -q "^lms$"; then

    echo "Installing local LearningMgnt LMS..."

    bench --site lms.localhost install-app lms
fi

# --------------------------------------------------
# Developer Mode
# --------------------------------------------------

echo "Enabling developer mode..."

bench --site lms.localhost set-config developer_mode 1

bench --site lms.localhost clear-cache

bench use lms.localhost

echo "======================================"
echo " LearningMgnt is ready"
echo "======================================"

bench start