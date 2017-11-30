#!/bin/bash
# fupr v0.9
# Made by Dr. Waldijk
# Fedora Upgrader Redux makes it easier to keep your system updated and hassle free upgrade to the next beta release.
# Read the README.md for more info, but you will find more info here below.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
FUPRNAM="fupr"
FUPRVER="0.9"
FUPRCOM=$1
FUPRARG=$2
FUPROSV=$(cat /etc/os-release | grep PRETTY | sed -r 's/.*"Fedora ([0-9]{2}) \(.*\)"/\1/')
FUPRUSR=$(whoami)
FUPREOL="0"
if [[ "$FUBRUSR" != "root" ]]; then
    FUPRSUDO="sudo"
fi
if [[ ! -f /usr/lib/systemd/system/dnf-system-upgrade.service ]]; then
    $FUPRSUDO dnf -y install dnf-plugin-system-upgrade
fi
if [[ ! -f /usr/bin/lynx ]]; then
    $FUPRSUDO dnf -y install lynx
fi
FUPRDMP=$(lynx -dump -nolist https://fedoraproject.org/wiki/Schedule)
fuprfrv () {
    FUPRFEV=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o '[0-9]{2}')
    FUPRFVT=$(expr $FUPROSV + 1)
    echo $FUPRFVT
    echo $FUPRFEV
    if [[ $FUPRFVT -ne $FUPRFEV ]]; then
        FUPRFEV=$(expr $FUPRFEV - 1)
        FUPREOL="1"
    fi
}
# -----------------------------------------------------------------------------------
if [[ -z "$FUPRCOM" ]]; then
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
    if [[ "$FUPROSV" != "$FUPRFEV" ]]; then
        echo "upgrade"
        echo "    Upgrade to Fedora $FUPRFEV"
        if [[ "$FUPREOL" = "0" ]]; then
            echo "schedule"
            echo "    Check when Fedora $FUPRFEV is released"
        fi
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
        echo "[fupr] Updating Fedora $FUPROSV"
        $FUPRSUDO dnf upgrade --refresh
    elif [[ -n "$FUPRARG" ]]; then
        echo "[fupr] Updating Fedora $FUPROSV"
        $FUPRSUDO dnf upgrade $FUPRARG
    fi
elif [[ "$FUPRCOM" = "updated" ]]; then
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
elif [[ "$FUPRCOM" = "check-update" ]]; then
    echo "[fupr] Checking for updates"
    $FUPRSUDO dnf check-update --refresh
elif [[ "$FUPRCOM" = "search" ]]; then
    echo "[fupr] Search for packages"
    $FUPRSUDO dnf search $FUPRARG
elif [[ "$FUPRCOM" = "upgrade" ]]; then
    if [[ "$FUPREOL" = "0" ]]; then
        echo "[fupr] Checking release version"
        FUPRBTD=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Beta Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
        FUPRFND=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Fedora [0-9]{2} Final Release \(GA\)$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
    fi
    if [[ -n "$FUPRBTD" ]]; then
        fuprfrv
        if [[ "$FUPROSV" != "$FUPRFEV" ]]; then
            if [[ "$FUPREOL" = "0" ]]; then
                echo "[fupr] Checking date"
                FUPRBTU=$(date -d "$FUPRBTD" +%s)
                FUPRFNU=$(date -d "$FUPRFND" +%s)
                FUPRDAT=$(TZ=UTC date +%Y-%m-%d)
                FUPRDAT=$(date -d "$FUPRDAT" +%s)
            else
                FUPRDAT="6"
                FUPRBTU="6"
            fi
            if [[ "$FUPRDAT" -ge "$FUPRBTU" ]] && [[ -z "$FUPRFND" ]]; then
                while :; do
                    echo "[fupr] Are you sure you want to upgrade from Fedora $FUPROSV to Fedora $FUPRFEV"
                    read -p "[fupr] (y/n) " -s -n1 FUPRKEY
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
            elif [[ -z "$FUPRBTU" ]] && [[ "$FUPRDAT" -ge "$FUPRFNU" ]]; then
                while :; do
                    echo "[fupr] Are you sure you want to upgrade from Fedora $FUPROSV to Fedora $FUPRFEV"
                    read -p "[fupr] (y/n) " -s -n1 FUPRKEY
                    case "$FUPRKEY" in
                        [yY])
                            break
                        ;;
                        [nN])
                            exit
                        ;;
                        *)
                        echo "Y for yes / N for no"
                        sleep 3s
                        ;;
                    esac
                done
                echo "[fupr] Updating Fedora  $FUPROSV"
                $FUPRSUDO dnf upgrade --refresh
                echo "[fupr] Upgrading to Fedora $FUPRFEV"
                # FUPRFEV=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o '[0-9]{2}')
                $FUPRSUDO dnf system-upgrade download --releasever=$FUPRFEV
                $FUPRSUDO dnf system-upgrade reboot
            else
                # FUPRBTD=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Beta Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
                echo "[fupr] Fedora $FUPRFEV is not available until $FUPRBTD"
                echo "[fupr] Only Fedora $FUPROSV will be updated"
                $FUPRSUDO dnf upgrade --refresh
            fi
        else
            # FUPRBTD=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Beta Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
            echo "[fupr] You have already upgraded to Fedora $FUPRFEV"
            echo "[fupr] Only doing an update of the system"
            $FUPRSUDO dnf upgrade --refresh
        fi
    else
        # FUPRBTD=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Beta Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
        echo "[fupr] No decided release date for Fedora $FUPRFEV yet"
        echo "[fupr] Only doing an update of the system"
        $FUPRSUDO dnf upgrade --refresh
    fi
elif [[ "$FUPRCOM" = "schedule" ]]; then
    echo "[fupr] Checking schedule"
    FUPRBTD=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Beta Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
    FUPRFND=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Fedora [0-9]{2} Final Release \(GA\)$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
    fuprfrv
    if [[ -n "$FUPRBTD" ]] && [[ -z "$FUPRFND" ]]; then
        if [[ "$FUPROSV" != "$FUPRFEV" ]]; then
            # FUPRFEV=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o '[0-9]{2}')
            # FUPRBTD=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Beta Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
            FUPRBTU=$(date -d "$FUPRBTD" +%s)
            FUPRDAT=$(TZ=UTC date +%Y-%m-%d)
            FUPRDAT=$(date -d "$FUPRDAT" +%s)
            if [[ "$FUPRDAT" -lt "$FUPRBTU" ]]; then
                # FUPRBTD=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2} Beta Release$' | grep -E -o '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
                echo "Fedora $FUPRFEV Beta is scheduled for release on $FUPRBTD."
                echo "Fedora $FUPRFEV Final Release has no release date yet."
            elif [[ "$FUPRDAT" -ge "$FUPRBTU" ]]; then
                echo "Fedora $FUPRFEV Beta has been released."
                echo "Fedora $FUPRFEV Final Release has no release date yet."
            fi
        else
            echo "[fupr] You have already upgraded to Fedora $FUPRFEV"
        fi
    elif [[ -n "$FUPRBTD" ]] && [[ -n "$FUPRFND" ]]; then
        if [[ "$FUPROSV" != "$FUPRFEV" ]]; then
            # FUPRFEV=$(echo "$FUPRDMP" | sed -r 's/^\s+//g' | grep -E 'Fedora [0-9]{2} Schedule' | grep -E -o '[0-9]{2}')
            FUPRBTU=$(date -d "$FUPRBTD" +%s)
            FUPRFNU=$(date -d "$FUPRFND" +%s)
            FUPRDAT=$(TZ=UTC date +%Y-%m-%d)
            FUPRDAT=$(date -d "$FUPRDAT" +%s)
            if [[ "$FUPRDAT" -lt "$FUPRFNU" ]]; then
                echo "Fedora $FUPRFEV Beta has been released."
                echo "Fedora $FUPRFEV Final Release is scheduled for release on $FUPRFND."
            elif [[ "$FUPRDAT" -ge "$FUPRFNU" ]]; then
                echo "Fedora $FUPRFEV Final Release has been released."
            fi
        else
            echo "[fupr] You have already upgraded to Fedora $FUPRFEV"
        fi
    else
        echo "[fupr] No official release date for Fedora $FUPRFEV yet"
    fi
else
    echo "[fupr] $FUPRCOM was not recognised"
fi
