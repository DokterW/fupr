#!/bin/bash
# fupr v0.14
# Made by Dr. Waldijk
# Fedora Upgrader Redux makes it easier to keep your system updated and hassle free upgrade to the next beta release.
# Read the README.md for more info, but you will find more info here below.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
FUPRNAM="fupr"
FUPRVER="0.14"
FUPRCOM=$1
FUPRARG=$2
FUPRSUB=$3
FUPROSV=$(cat /etc/os-release | grep PRETTY | sed -r 's/.*"Fedora ([0-9]{2}) \(.*\)"/\1/')
FUPRUSR=$(whoami)
FUPREOL="0"
if [[ "$FUBRUSR" != "root" ]]; then
    FUPRSUDO="sudo"
fi
if [[ ! -f /usr/lib/systemd/system/dnf-system-upgrade.service ]]; then
    $FUPRSUDO dnf -y install dnf-plugin-system-upgrade
fi
#if [[ ! -f /usr/bin/lynx ]]; then
#    $FUPRSUDO dnf -y install lynx
#fi
#FUPRDMP=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule)
# Function --------------------------------------------------------------------------
# -----------------------------------------------------------------------------------
if [[ -z "$FUPRCOM" ]]; then
    echo "$FUPRNAM v$FUPRVER"
    echo ""
    echo "You are running Fedora $FUPROSV"
    echo ""
    echo "    fupr <command> <syntax>"
    echo ""
    echo "help"
    echo "    List all commands"
elif [[ "$FUPRCOM" = "help" ]]; then
    fuprfrv
    echo "$FUPRNAM v$FUPRVER"
    echo ""
    echo "You are running Fedora $FUPROSV"
    echo ""
    echo "    fupr <command> <syntax>"
    echo ""
    echo "install pkg-name"
    echo "    Install software"
    echo "remove pkg-name"
    echo "    Remove software"
    echo "update"
    echo "    Update Fedora $FUPROSV"
    echo "update pkg-name"
    echo "    Update specified package/rpm"
    echo "updated"
    echo "    Update Fedora $FUPROSV and reload daemon(s)"
    echo "updated pkg-name"
    echo "    Update specified package/rpm and reload daemon(s)"
    echo "check-update"
    echo "    Check for updates"
    echo "search"
    echo "    Search for packages"
#    if [[ "$FUPROSV" != "$FUPRFEV" ]]; then
#        echo "upgrade"
#        echo "    Upgrade to Fedora $FUPRFEV"
#        if [[ "$FUPREOL" = "0" ]]; then
#            echo "schedule"
#            echo "    Check when Fedora $FUPRFEV is released"
#        fi
#    fi
    echo "help"
    echo "    List all commands (what you are viewing right now)"
elif [[ "$FUPRCOM" = "install" ]] || [[ "$FUPRCOM" = "in" ]]; then
    if [[ -n "$FUPRARG" ]]; then
        echo "[fupr] Installing software"
        $FUPRSUDO dnf install $FUPRARG
    else
        echo "[fupr] Specify what you want to install"
    fi
elif [[ "$FUPRCOM" = "remove" ]] || [[ "$FUPRCOM" = "rm" ]]; then
    if [[ -n "$FUPRARG" ]]; then
        echo "[fupr] Removing software"
        $FUPRSUDO dnf remove $FUPRARG
    else
        echo "[fupr] Specify what you want to remove"
    fi
elif [[ "$FUPRCOM" = "update" ]] || [[ "$FUPRCOM" = "up" ]]; then
    if [[ -z "$FUPRARG" ]]; then
        echo "[fupr] Updating Fedora $FUPROSV"
        $FUPRSUDO dnf upgrade --refresh
    elif [[ -n "$FUPRARG" ]]; then
        echo "[fupr] Updating Fedora $FUPROSV"
        $FUPRSUDO dnf upgrade $FUPRARG
    fi
elif [[ "$FUPRCOM" = "updated" ]] || [[ "$FUPRCOM" = "upd" ]]; then
    if [[ -z "$FUPRARG" ]]; then
        echo "[fupr] Updating Fedora $FUPROSV"
        $FUPRSUDO dnf upgrade --refresh
        echo "[FUPR] Reloading daemons"
        $FUPRSUDO systemctl daemon-reload
    elif [[ -n "$FUPRARG" ]]; then
        echo "[fupr] Updating Fedora $FUPROSV"
        $FUPRSUDO dnf upgrade $FUPRARG
        echo "[FUPR] Reloading daemons"
        $FUPRSUDO systemctl daemon-reload
    fi
elif [[ "$FUPRCOM" = "check-update" ]] || [[ "$FUPRCOM" = "chup" ]]; then
    echo "[fupr] Checking for updates"
    $FUPRSUDO dnf check-update --refresh
elif [[ "$FUPRCOM" = "search" ]] || [[ "$FUPRCOM" = "sr" ]]; then
    echo "[fupr] Searching for package(s)"
    $FUPRSUDO dnf search $FUPRARG
elif [[ "$FUPRCOM" = "upgrade" ]] || [[ "$FUPRCOM" = "upg" ]]; then
    #FUPRFEV=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o '[0-9]{2}')
    FUPRFEV=$(expr $FUPROSV + 1)
    if [[ "$FUPROSV" != "$FUPRFEV" ]]; then
        while :; do
            echo "[fupr] Are you sure you want to upgrade from Fedora $FUPROSV to Fedora $FUPRFEV"
            read -p "[fupr] (y/n) " -s -n1 FUPRKEY
            echo ""
            case "$FUPRKEY" in
                [yY])
                    break
                ;;
                [nN])
                    exit
                ;;
                *)
                echo "[fupr] Y for yes / N for no"
                sleep 3s
                ;;
            esac
        done
        echo "[fupr] Updating Fedora $FUPROSV"
        $FUPRSUDO dnf upgrade --refresh
        echo "[fupr] Upgrading to Fedora $FUPRFEV"
        # FUPRFEV=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o '[0-9]{2}')
        $FUPRSUDO dnf system-upgrade download --releasever=$FUPRFEV
        $FUPRSUDO dnf system-upgrade reboot
    else
        # FUPRBTD=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Beta Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
        echo "[fupr] You have already upgraded to Fedora $FUPRFEV"
        echo "[fupr] Only doing an update of the system"
        $FUPRSUDO dnf upgrade --refresh
    fi
#elif [[ "$FUPRCOM" = "schedule" ]] || [[ "$FUPRCOM" = "schd" ]]; then
#    echo "[fupr] Checking schedule"
#    FUPRSCHED=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}.*Release' | tail -n +2)
#    echo "[fupr] You are running Fedora $FUPROSV"
#    echo "$FUPRSCHED"
elif [[ "$FUPRARG" = "flatpak" ]] || [[ "$FUPRARG" = "fp" ]]; then
    continue
elif [[ "$FUPRARG" = "dokter" ]] || [[ "$FUPRARG" = "dr" ]]; then
    continue
else
    echo "[fupr] $FUPRCOM was not recognised"
fi
