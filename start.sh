#!/bin/bash
# fupr v0.18
# Made by Dr. Waldijk
# Fedora Upgrader Redux makes it easier to keep your system updated and hassle free upgrade to the next beta release.
# Read the README.md for more info, but you will find more info here below.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
FUPRNAM="fupr"
FUPRVER="0.18"
FUPRCOM=$1
FUPRARG=$2
FUPRSUB=$3
FUPROSV=$(cat /etc/os-release | grep PRETTY | sed -r 's/.*"Fedora ([0-9]{2}) \(.*\)"/\1/')
FUPRUSR=$(whoami)
FUPREOL="0"
FUPRRPN=".x86_64.rpm"
FUPRBSN="start.sh"
if [[ "$FUBRUSR" != "root" ]]; then
    FUPRSUDO="sudo"
fi
if [[ ! -f /usr/lib/systemd/system/dnf-system-upgrade.service ]]; then
    $FUPRSUDO dnf -y install dnf-plugin-system-upgrade
fi
# Function --------------------------------------------------------------------------
fuprchk () {
    # Check if it's a bash script or a rpm.
    FUPRBSH=$(curl -s --connect-timeout 10 https://raw.githubusercontent.com/DokterW/fupr/master/fuprbsh)
    FUPRRPM=$(curl -s --connect-timeout 10 https://raw.githubusercontent.com/DokterW/fupr/master/fuprrpm)
    FUPRCHK1=$(echo "$FUPRBSH" | cut -d , -f 1 | tr '[:upper:]' '[:lower:]' | grep $FUPRARG)
    FUPRCHK2=$(echo "$FUPRRPM" | cut -d , -f 1 | tr '[:upper:]' '[:lower:]' | grep $FUPRARG)
}
fuprurlverfetch () {
    if [[ "$FUPRARG" = "$FUPRCHK1" ]]; then
        # Regex out the version.
        FUPRLTS=$(curl -ILs -o /dev/null -w %{url_effective} --connect-timeout 10 https://github.com/DokterW/$FUPRARG/releases/latest | egrep -o '([0-9]{1,2}\.)*[0-9]{1,2}')
    elif [[ "$FUPRARG" = "$FUPRCHK2" ]]; then
        # Fetch latest version URL.
        FUPRURL=$(curl -ILs -o /dev/null -w %{url_effective} --connect-timeout 10 https://github.com/$FUPRARG/$FUPRARG/releases/latest)
        # Same as above, but regex out the version.
        FUPRLTS=$(curl -ILs -o /dev/null -w %{url_effective} --connect-timeout 10 https://github.com/$FUPRARG/$FUPRARG/releases/latest | egrep -o '([0-9]{1,2}\.)*[0-9]{1,2}')
    fi
}
fuprbashdl () {
    # Download bash script and make it an executable if it's not.
    wget -q -N --show-progress https://raw.githubusercontent.com/DokterW/$FUPRARG/master/$FUPRBSN -P $HOME/.dokter/$FUPRARG/
    if [[ ! -x $HOME/.dokter/$FUPRARG/$FUPRBSN ]]; then
        chmod +x $HOME/.dokter/$FUPRARG/$FUPRBSN
    fi
}
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
    echo "$FUPRNAM v$FUPRVER"
    echo ""
    echo "You are running Fedora $FUPROSV"
    echo ""
    echo "    fupr <command> <syntax>"
    echo ""
    echo "DNF"
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
    echo ""
    echo "Flatpak"
    echo ""
    echo "finstall pkg-name"
    echo "    Install package"
    echo "fremove pkg-name"
    echo "    Removes package"
    echo "fupdate"
    echo "    Updates package(s)"
    echo "fsearch"
    echo "    Search for package"
    echo "fadd name repo-url"
    echo "    Adds remote repo"
    echo ""
    echo "Dokter's bash script"
    echo ""
    echo "dinstall pkg-name"
    echo "    Install package"
    echo "dupdate"
    echo "    Updates package(s)"
    echo "dlist"
    echo "    List package"
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
# DNF
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
# Flatpak
elif [[ "$FUPRCOM" = "finstall" ]] || [[ "$FUPRCOM" = "fin" ]]; then
    echo "[fupr flatpak] Installing flatpak"
    if [[ -n "$FUPRARG" ]]; then
        FUPRFRP=$(flatpak remotes | head -n +2 | sed -r 's/\t/,/' | cut -d , -f 1)
        flatpak install $FUPRFRP $FUPRARG
    else
        echo "[fupr flatpak] Specify what you want to install"
    fi
elif [[ "$FUPRCOM" = "fupgrade" ]] || [[ "$FUPRCOM" = "fup" ]]; then
    echo "[fupr flatpak] Updating flatpak"
    if [[ -n "$FUPRARG" ]]; then
        flatpak update $FUPRARG
    else
        flatpak update
    fi
elif [[ "$FUPRCOM" = "fremove" ]] || [[ "$FUPRCOM" = "frm" ]]; then
    echo "[fupr flatpak] Removing flatpak"
    if [[ -n "$FUPRARG" ]]; then
        flatpak uninstall $FUPRARG
    else
        echo "[fupr flatpak] Specify what you want to uninstall"
    fi
elif [[ "$FUPRCOM" = "fsearch" ]] || [[ "$FUPRCOM" = "fsr" ]]; then
    echo "[fupr flatpak] Searching flatpaks"
    flatpak search $FUPRARG
elif [[ "$FUPRCOM" = "fadd" ]] || [[ "$FUPRCOM" = "fa" ]]; then
    echo "[fupr flatpak] Adding flatpak repo"
    flatpak remote-add --if-not-exists $FUPRARG $FUPRSUB
# Dokter
elif [[ "$FUPRCOM" = "dinstall" ]] || [[ "$FUPRCOM" = "din" ]]; then
    fuprchk
    if [[ -z "$FUPRCHK1" ]] && [[ -z "$FUPRCHK2" ]]; then
        echo "$FUPRARG is not available."
        echo "Type 'dogum list' to get a list of available scripts and software."
    elif [[ "$FUPRARG" = "$FUPRCHK1" ]]; then
        if [[ ! -d $HOME/.dokter/$FUPRARG ]]; then
            mkdir $HOME/.dokter/$FUPRARG
            fuprbashdl
            echo "alias $FUPRARG='$HOME/.dokter/$FUPRARG/$FUPRBSN'" >> $HOME/.bashrc
            source ~/.bashrc
            # Adding alias so user don't need to restart terminal.
            # It does not work. I will fix that later.
            # alias $FUPRARG='$HOME/.dokter/$FUPRARG/$FUPRBSN'
        else
            echo "You cannot install a bash script that is already installed."
        fi
    elif [[ "$FUPRARG" = "$FUPRCHK2" ]]; then
        if [[ ! -d $HOME/.dokter/$FUPRARG ]]; then
            fuprurlverfetch
            # Download URL
            FUPRDLD="https://github.com/$FUPRARG/$FUPRARG/releases/download/v"
            wget -q --show-progress $FUPRDLD$FUPRLTS/$FUPRARG$FUPRRPN -P /tmp/
            sudo dnf -y install /tmp/$FUPRARG$FUPRRPN
            rm /tmp/$FUPRARG$FUPRRPN
        else
            echo "You cannot install software that is already installed."
        fi
    fi
elif [[ "$FUPRCOM" = "dupgrade" ]] || [[ "$FUPRCOM" = "dup" ]]; then
    fuprchk
    if [[ -z "$FUPRCHK1" ]] && [[ -z "$FUPRCHK2" ]]; then
        echo "$FUPRARG is not available."
        echo "Type 'dogum list' to get a list of available scripts and software."
    elif [[ "$FUPRARG" = "$FUPRCHK1" ]]; then
        if [[ -d $HOME/.dokter/$FUPRARG ]]; then
            fuprurlverfetch
            FUPRIND=$(cat $HOME/.dokter/$FUPRARG/$FUPRBSN | sed -n "2p" | egrep -o '([0-9]{1,2}\.)*[0-9]{1,2}')
            if [[ "$FUPRLTS" != "$FUPRIND" ]]; then
                if [[ "$FUPRARG" = "fupr" ]]; then
                    wget -q -N --show-progress https://raw.githubusercontent.com/DokterW/fupr/master/upgrade_fupr.sh -P $HOME/.dokter/fupr/
                    chmod +x $HOME/.dokter/fupr/upgrade_fupr.sh
                    exec $HOME/.dokter/fupr/upgrade_fupr.sh
                else
                    fuprbashdl
                fi
            else
                echo "You already have the latest version of $FUPRARG v$FUPRLTS installed."
            fi
        else
            echo "You cannot update a bash script that is not installed."
        fi
    elif [[ "$FUPRARG" = "$FUPRCHK2" ]]; then
        if [[ -e /bin/$FUPRARG ]]; then
            fuprurlverfetch
            # Download URL
            FUPRDLD="https://github.com/$FUPRARG/$FUPRARG/releases/download/v"
            # Fetch version of installed software.
            FUPRIND=$(dnf info $FUPRARG | grep Version | egrep -o '([0-9]{1,2}\.)*[0-9]{1,2}')
            if [ "$FUPRLTS" != "$FUPRIND" ]; then
                # Download, upgrade & remove d/l file
                wget -q --show-progress $FUPRDLD$FUPRLTS/$FUPRARG$FUPRRPN -P /tmp/
                sudo dnf -y upgrade /tmp/$FUPRARG$FUPRRPN
                rm /tmp/$FUPRARG$FUPRRPN
            else
                echo "You already have the latest version of $FUPRARG v$FUPRLTS installed."
            fi
        else
            echo "You cannot update software that is not installed."
        fi
    fi
elif [[ "$FUPRCOM" = "dlist" ]] || [[ "$FUPRCOM" = "dls" ]]; then
    FUPRBSH=$(curl -s --connect-timeout 10 https://raw.githubusercontent.com/DokterW/fupr/master/fuprbsh)
    # FUPRRPM=$(curl -s --connect-timeout 10 https://raw.githubusercontent.com/DokterW/fupr/master/fuprrpm)
    echo $FUPRNAM v$FUPRVER
    echo ""
    # echo "$FUPRRPM" | cut -d , -f 1,2 | sed 's/,/ - /g'
    echo "$FUPRBSH" | cut -d , -f 1,2 | sed 's/,/ - /g'
# All up
elif [[ "$FUPRCOM" = "updateall" ]] || [[ "$FUPRCOM" = "upa" ]]; then
    echo "[fupr dnf] Updating Fedora $FUPROSV"
    $FUPRSUDO dnf upgrade --refresh
    echo "[fupr flatpak] Updating flatpak"
    flatpak update
else
    echo "[fupr] $FUPRCOM was not recognised"
fi
