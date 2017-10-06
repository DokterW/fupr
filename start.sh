#!/bin/bash
# fupr v0.6
# Made by Dr. Waldijk
# Fedora Upgrader Redux makes it easier to keep your system updated and hassle free upgrade to the next beta release.
# Read the README.md for more info, but you will find more info here below.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
FUPRNAM="fupr"
FUPRVER="0.6"
FUPRCOM=$1
FUPRARG=$2
FUPROSV=$(cat /etc/os-release | grep PRETTY | sed -r 's/.*"(.*) \(.*\)"/\1/')
FUPRUSR=$(whoami)
if [[ "$FUBRUSR" != "root" ]]; then
    FUPRSUDO="sudo"
fi
if [[ ! -f /usr/lib/systemd/system/dnf-system-upgrade.service ]]; then
    $FUPRSUDO dnf -y install dnf-plugin-system-upgrade
fi
if [[ ! -f /usr/bin/lynx ]]; then
    $FUPRSUDO dnf -y install lynx
fi
# -----------------------------------------------------------------------------------
if [[ -z "$FUPRCOM" ]]; then
    FUPRFEV=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o 'Fedora [0-9]{2}')
    echo "$FUPRNAM v$FUPRVER"
    echo ""
    echo "    fupr <command> <syntax>"
    echo ""
    echo "install pkg-name"
    echo "    Install software"
    echo "remove pkg-name"
    echo "    Install software"
    echo "update"
    echo "    Update $FUPROSV"
    echo "update pkg-name"
    echo "    Update specified package/rpm"
    echo "updated"
    echo "    Update $FUPROSV and reload daemon(s)"
    echo "updated pkg-name"
    echo "    Update specified package/rpm and reload daemon(s)"
    echo "search"
    echo "    Search for packages"
    if [[ "$FUPROSV" != "$FUPRFEV" ]]; then
        echo "upgrade"
        echo "    Upgrade to $FUPRFEV"
        echo "schedule"
        echo "    Check when $FUPRFEV is released"
    fi
elif [[ "$FUPRCOM" = "install" ]]; then
    if [[ -n "$FUPRARG" ]]; then
        echo "[fupr] Installing software"
        $FUPRSUDO dnf install $FUPRARG
    else
        echo "[fupr] Specify what you want to install"
    fi
elif [[ "$FUPRCOM" = "remove" ]]; then
    if [[ -n "$FUPRARG" ]]; then
        echo "[fupr] Removing software"
        $FUPRSUDO dnf remove $FUPRARG
    else
        echo "[fupr] Specify what you want to remove"
    fi
elif [[ "$FUPRCOM" = "update" ]]; then
    if [[ -z "$FUPRARG" ]]; then
        echo "[fupr] Updating $FUPROSV"
        $FUPRSUDO dnf upgrade --refresh
    elif [[ -n "$FUPRARG" ]]; then
        echo "[fupr] Updating $FUPROSV"
        $FUPRSUDO dnf upgrade $FUPRARG
    fi
elif [[ "$FUPRCOM" = "updated" ]]; then
    if [[ -z "$FUPRARG" ]]; then
        echo "[fupr] Updating $FUPROSV"
        $FUPRSUDO dnf upgrade --refresh
        echo "[FUPR] Reloading daemons"
        $FUPRSUDO systemctl daemon-reload
    elif [[ -n "$FUPRARG" ]]; then
        echo "[fupr] Updating $FUPROSV"
        $FUPRSUDO dnf upgrade $FUPRARG
        echo "[FUPR] Reloading daemons"
        $FUPRSUDO systemctl daemon-reload
    fi
elif [[ "$FUPRCOM" = "search" ]]; then
    echo "[fupr] Search for packages"
    $FUPRSUDO dnf search $FUPRARG
elif [[ "$FUPRCOM" = "upgrade" ]]; then
    echo "[fupr] Checking release version"
    FUPRBTD=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Beta Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
    if [[ -n "$FUPRBTD" ]]; then
        FUPRFEV=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o 'Fedora [0-9]{2}')
        if [[ "$FUPROSV" != "$FUPRFEV" ]]; then
            echo "[fupr] Checking date"
            FUPRBTD=$(date -d "$FUPRBTD" +%s)
            FUPRDAT=$(TZ=UTC date +%Y-%m-%d)
            FUPRDAT=$(date -d "$FUPRDAT" +%s)
            if [[ "$FUPRDAT" -ge "$FUPRBTD" ]]; then
                echo "[fupr] Updating $FUPROSV"
                $FUPRSUDO dnf upgrade --refresh
                echo "[fupr] Upgrading to $FUPRFEV"
                FUPRFEV=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o '[0-9]{2}')
                $FUPRSUDO dnf system-upgrade download --releasever=$FUPRFEV
                $FUPRSUDO dnf system-upgrade reboot
            else
                FUPRBTD=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Beta Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
                echo "[fupr] $FUPRFEV is not available until $FUPRBTD"
                echo "[fupr] Only $FUPROSV will be updated"
                $FUPRSUDO dnf upgrade --refresh
            fi
        else
            FUPRBTD=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Beta Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
            echo "[fupr] You have already upgraded to $FUPRFEV"
            echo "[fupr] Only doing an update of the system"
            $FUPRSUDO dnf upgrade --refresh
        fi
    else
        FUPRBTD=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Beta Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
        echo "[fupr] No decided release date for $FUPRFEV yet"
        echo "[fupr] Only doing an update of the system"
        $FUPRSUDO dnf upgrade --refresh
    fi
elif [[ "$FUPRCOM" = "schedule" ]]; then
    echo "[fupr] Checking schedule"
    FUPRBTD=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Beta Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
    #FUPRFND=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Final Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
    FUPRFEV=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o 'Fedora [0-9]{2}')
    if [[ -n "$FUPRBTD" ]]; then
        if [[ "$FUPROSV" != "$FUPRFEV" ]]; then
            FUPRFEV=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o 'Fedora [0-9]{2}')
            FUPRBTD=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Beta Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
            echo "$FUPRFEV Beta is scheduled for release on $FUPRBTD."
        else
            echo "[fupr] You have already upgraded to $FUPRFEV"
        fi
    else
        echo "[fupr] No decided release date for $FUPRFEV yet"
    fi
else
    echo "[fupr] $FUPRCOM was not recognised"
fi
