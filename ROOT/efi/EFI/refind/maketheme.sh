#!/usr/bin/env bash

scriptFolder=$(dirname $(readlink -f $0))
esp_device=$(mount | grep 'efi ' | cut -d' ' -f 1)
[ -z "${esp}" ] && esp=$(lsblk -no MOUNTPOINT ${esp_device})
# esp="/boot/efi"
refind_path="${esp}/EFI/refind"

case "${1}" in
  "make")
    rm -rf "${scriptFolder}"/refind-theme-regular_FINAL/*
    rsync -avz --delete "${scriptFolder}"/refind-theme-regular/ "${scriptFolder}"/refind-theme-regular_FINAL/
    rm -rf "${scriptFolder}"/refind-theme-regular_FINAL/{.git,LICENSE,install.sh,README.md,src}
    # sed -i "s/refind-theme-regular/refind-theme-regular_FINAL/" "${scriptFolder}"/refind-theme-regular_FINAL/theme.conf
    ;;
  "sync")
    rsync -avz --delete "${scriptFolder}"/refind-theme-regular/ "${scriptFolder}"/refind-theme-regular_FINAL/
    rm -rf "${scriptFolder}"/refind-theme-regular_FINAL/{.git,LICENSE,install.sh,README.md,src}
    # sed -i "s/refind-theme-regular/refind-theme-regular_FINAL/" "${scriptFolder}"/refind-theme-regular_FINAL/theme.conf
    sudo rsync -rltP --delete "${scriptFolder}"/refind-theme-regular_FINAL/ ${refind_path}/themes/refind-theme-regular
    sudo rsync -rltP --delete "${scriptFolder}"/bg.png ${refind_path}/themes/refind-theme-regular/
    sudo cp ${refind_path}/refind.conf ${refind_path}/refind_sample.conf

    sudo grep -qxF 'include themes/refind-theme-regular/theme.conf' ${refind_path}/refind.conf || echo 'include themes/refind-theme-regular/theme.conf' >> ${refind_path}/refind.conf
    sudo grep -qxF '#BACKGROUND IMAGE' ${refind_path}/refind.conf || echo '#BACKGROUND IMAGE' >> ${refind_path}/refind.conf
    sudo grep -qxF 'banner themes/refind-theme-regular/bg.png' ${refind_path}/refind.conf || echo 'banner themes/refind-theme-regular/bg.png' >> ${refind_path}/refind.conf
    sudo grep -qxF 'banner_scale fillscreen' ${refind_path}/refind.conf || echo 'banner_scale fillscreen' >> ${refind_path}/refind.conf
    ;;
  "rm")
    rm -rf "${scriptFolder}"/refind-theme-regular_FINAL/*
    ;;
  "up")
    git --git-dir="${scriptFolder}"/refind-theme-regular/.git --work-tree="${scriptFolder}"/refind-theme-regular pull
    rsync -avz --delete "${scriptFolder}"/refind-theme-regular/ "${scriptFolder}"/refind-theme-regular_FINAL/
    rm -rf "${scriptFolder}"/refind-theme-regular_FINAL/{.git,LICENSE,install.sh,README.md,src}
    # sed -i "s/refind-theme-regular/refind-theme-regular_FINAL/" "${scriptFolder}"/refind-theme-regular_FINAL/theme.conf
    ;;
  *)
    echo "No option or invalid option." ;
    echo "Try maketheme.sh {options}";
    printf "Options : sync (sync themes from here to ${refind_path}/themes/refind-theme-regular).\nmake (for copying themes from refind-theme-regular to refind-theme-regular_FINAL),\n rm (to remove), up ( to remove and then copy)";
    ;;
esac
