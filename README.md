# Fedora Upgrader Redux

Inspired by [fedup](https://fedoraproject.org/wiki/FedUp) and my wish for Fedora releasing a rolling release option.

It also makes keeping your system up to date a bit easier.

Instead of typing _sudo dnf upgrade --refresh_, you just type _fupr update_.

You can also forget about type
_sudo dnf upgrade --refresh_
_sudo dnf system-upgrade download --releasever=XX_
_sudo dnf system-upgrade reboot_
Just type _fupr upgrade_, and it also checks if a new released is available before it does the system upgrade. If not, it just updates the current version you have installed.

For now it's just a simple tool to upgrade to the next Fedora Beta, do a system upgrade of your current version with the _--refresh_ flag and to check when the next Fedora Beta might be released.

Read more about the risks of installing a beta [here](https://fedoraproject.org/wiki/Upgrading).

_fupr <command> <syntax>_

_install_
    _Install software_
_update_
    _Update Fedora XX_
_update pkg-name_
    _Update specified package/rpm_
_update daemon_
    _Update Fedora XX and reload daemon(s)_
_search_
    _Search for packages_
_upgrade_
    _Upgrade to Fedora XX_
_schedule_
    _Check when Fedora XX is released_

### Roadmap

* Add ability to use a blacklist of repos you know creates an issue when you upgrade to the next version.
* Add ability to upgrade to final release too if beta is too risky for you.
* Add a flag for if you're doing a system update that you restart your services.
* When Fedora 28 schedule is up I will do some testing to check that I fetch the right date, or any date at all.

### Changelog

#### 2017-10-05
* You can now reload daemons after you have updated your system.
* You can also upgrade a specific package/rpm.

#### 2017-10-04
* Added new commands, install & search, because why not.

#### 2017-10-03
* Before doing an upgrade a check for a decided date and if you have upgraded already, then default to a regular system update.
* Checks if you are root or not, if not, sudo is added to update/upgrade commands.

#### 2017-10-02
* Released!
