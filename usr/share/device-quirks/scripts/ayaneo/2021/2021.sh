#!/bin/bash
if [ $(whoami) != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi
 
if [ -d /tmp/frzr_root ]; then
  source ${MOUNT_PATH}/etc/device-quirks/device-quirks.conf
else
  source /etc/device-quirks/device-quirks.conf
fi

if [[ $USE_FIRMWARE_OVERRIDES == 1 ]]; then
  # Do DSDT override.
  DSDT_OVERRIDES="ayaneo_2021_0x03.dsl ayaneo_2021_0xE3.dsl"
  for dsdt in $DSDT_OVERRIDES; do
    APPLY_PATCH=$($DQ_PATH/scripts/verify_dsdt $dsdt)
    if [[ $APPLY_PATCH == 1 ]]; then
      $DQ_PATH/scripts/override_dsdt $dsdt
      break
    fi
  done
else
  echo "Firmware overrides are disabled, skipping...\n"
  echo "To enable firmware overrides, edit /etc/device-quirks/device-quirks.conf"
fi
