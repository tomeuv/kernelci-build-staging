#!/bin/sh

# Strip the image to a small minimal system without removing the debian
# toolchain.

set -e

# Copy timezone file and remove tzdata package
rm -rf /etc/localtime
cp /usr/share/zoneinfo/Etc/UTC /etc/localtime


UNNEEDED_PACKAGES=" libfdisk1"\
" tzdata"\

export DEBIAN_FRONTEND=noninteractive

# Removing unused packages
for PACKAGE in ${UNNEEDED_PACKAGES}
do
	echo ${PACKAGE}
	if ! apt-get remove --purge --yes "${PACKAGE}"
	then
		echo "WARNING: ${PACKAGE} isn't installed"
	fi
done

apt-get autoremove --yes || true

# Removing unused files
find . -name *~ -print0 | xargs -0 rm -f

# Dropping logs
rm -rf /var/log/*

# documentation, localization, i18n files, etc
rm -rf /usr/share/doc/*
rm -rf /usr/share/locale/*
rm -rf /usr/share/man
rm -rf /usr/share/i18n/*
rm -rf /usr/share/info/*
rm -rf /usr/share/lintian/*
rm -rf /usr/share/common-licenses/*
rm -rf /usr/share/mime/*

# Drop udev hwdb not required on a stripped system
rm -f /lib/udev/hwdb.bin /lib/udev/hwdb.d/*

# Drop all gconv conversions apart from the more comon ISO ones and UTF8
rm usr/bin/iconv
rm usr/sbin/iconvconfig
rm usr/lib/*/gconv/lib*
rm usr/lib/*/gconv/[A-HJ-TV-Z]*
rm usr/lib/*/gconv/INIS*
rm usr/lib/*/gconv/IBM*
rm usr/lib/*/gconv/UHC*
rm usr/lib/*/gconv/ISO-2022*
rm usr/lib/*/gconv/UTF-7*
rm usr/lib/*/gconv/ISO8859-[2-9]*
rm usr/lib/*/gconv/ISO-IR*
