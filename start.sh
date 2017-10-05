#!/bin/bash
# fupr v0.4
# Made by Dr. Waldijk
# Fedora Upgrader Redux makes it easier to keep your system updated and hassle free upgrade to the next beta release.
# Read the README.md for more info, but you will find more info here below.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
FUPRNAM="fupr"
FUPRVER="0.4"
FUPRCOM=$1
FUPRSYN=$2
FUPROSV=$(cat /etc/os-release | grep PRETTY | sed -r 's/.*"(.*) \(.*\)"/\1/')
if [[ ! -f /usr/lib/systemd/system/dnf-system-upgrade.service ]]; then
    sudo dnf install dnf-plugin-system-upgrade
fi
FUPRUSR=$(whoami)
if [[ "$FUBRUSR" != "root" ]]; then
    FUPRSUDO="sudo"
fi
# -----------------------------------------------------------------------------------
if [[ -z "$FUPRCOM" ]]; then
    FUPRBTV=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o 'Fedora [0-9]{2}')
    echo "$FUPRNAM v$FUPRVER"
    echo ""
    echo "    fupr <command> <syntax>"
    echo ""
    echo "install"
    echo "    Install software"
    echo "update"
    echo "    Update $FUPROSV"
    echo "update pkg-name"
    echo "    Update specified package/rpm"
    echo "update daemon"
    echo "    Update $FUPROSV and reload daemon(s)"
    echo "search"
    echo "    Search for packages"
    echo "upgrade"
    echo "    Upgrade to $FUPRBTV"
    echo "schedule"
    echo "    Check when $FUPRBTV is released"
elif [[ "$FUPRCOM" = "install" ]]; then
    echo "[fupr] Installing software"
    $FUPRSUDO dnf install $FUPRSYN
elif [[ "$FUPRCOM" = "update" ]]; then
    if [[ -z "$FUPRSYN" ]]; then
        echo "[fupr] Updating $FUPROSV"
        $FUPRSUDO dnf upgrade --refresh
    elif [[ -z "$FUPRSYN" ]]; then
        if [[ "$FUPRSYN" = "daemon" ]]; then
            echo "[fupr] Updating $FUPROSV"
            $FUPRSUDO dnf upgrade --refresh
            echo "[FUPR] Reloading daemons"
            $FUPRSUDO systemctl daemon-reload
        else
            echo "[fupr] Updating $FUPRSYN"
            $FUPRSUDO dnf upgrade $FUPRSYN
        fi
    fi
elif [[ "$FUPRCOM" = "search" ]]; then
    echo "[fupr] Search for packages"
    $FUPRSUDO dnf search $FUPRSYN
elif [[ "$FUPRCOM" = "upgrade" ]]; then
    echo "[fupr] Checking release version"
    FUPRBTD=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep 'Beta Release' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
    if [[ -n "$FUPRBTD" ]]; then
        FUPRBTV=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o 'Fedora [0-9]{2}')
        if [[ "$FUPROSV" != "$FUPRBTV" ]]; then
            echo "[fupr] Checking date"
            FUPRBTD=$(date -d "$FUPRBTD" +%s)
            FUPRDAT=$(TZ=UTC date +%Y-%m-%d)
            FUPRDAT=$(date -d "$FUPRDAT" +%s)
            if [[ "$FUPRDAT" -ge "$FUPRBTD" ]]; then
                echo "[fupr] Updating $FUPROSV"
                $FUPRSUDO dnf upgrade --refresh
                echo "[fupr] Upgrading to $FUPRBTV"
                FUPRBTV=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o '[0-9]{2}')
                $FUPRSUDO dnf system-upgrade download --releasever=$FUPRBTV
                $FUPRSUDO dnf system-upgrade reboot
            else
                FUPRBTD=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep 'Beta Release' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
                echo "[fupr] $FUPRBTV is not available until $FUPRBTD"
                echo "[fupr] Only $FUPROSV will be updated"
                $FUPRSUDO dnf upgrade --refresh
            fi
        else
            FUPRBTD=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep 'Beta Release' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
            echo "[fupr] You have already upgraded to $FUPRBTV"
            echo "[fupr] Only doing an update of the system"
            $FUPRSUDO dnf upgrade --refresh
        fi
    else
        FUPRBTD=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep 'Beta Release' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
        echo "[fupr] No decided release date for $FUPRBTV yet"
        echo "[fupr] Only doing an update of the system"
        $FUPRSUDO dnf upgrade --refresh
    fi
elif [[ "$FUPRCOM" = "schedule" ]]; then
    echo "[fupr] Checking schedule"
    FUPRBTD=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep 'Beta Release' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
    if [[ -n "$FUPRBTD" ]]; then
        FUPRBTV=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o 'Fedora [0-9]{2}')
        if [[ "$FUPROSV" != "$FUPRBTV" ]]; then
            FUPRBTV=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o 'Fedora [0-9]{2}')
            FUPRBTD=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep 'Beta Release' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
            echo "$FUPRBTV is scheduled for release on $FUPRBTD."
        else
            echo "[fupr] You have already upgraded to $FUPRBTV"
        fi
    else
        echo "[fupr] No decided release date for $FUPRBTV yet"
    fi
else
    echo "[fupr] $FUPRCOM was not recognised"
fi
