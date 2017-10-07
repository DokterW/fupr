# Fedora Upgrader Redux

Inspired by [fedup](https://fedoraproject.org/wiki/FedUp) and my wish for Fedora releasing a rolling release option.

fupr goes beyond what fedup was meant to do. It is more of an overlay of dnf to make it easier to keep your system up to date.

*Read more about the risks of installing a beta [here](https://fedoraproject.org/wiki/Upgrading).*

Instead of typing _sudo dnf upgrade --refresh_, you just type _fupr update_.

You can also forget about typing
_sudo dnf upgrade --refresh_
_sudo dnf system-upgrade download --releasever=XX_
_sudo dnf system-upgrade reboot_
Just type _fupr upgrade_, and it also checks if a new released is available before it does the system upgrade. If not, it just updates the current version you have installed.

_fupr <command> <args>_

_install_
    _Install software_
_update_
    _Update Fedora XX_
_update pkg-name_
    _Update specified package/rpm_
_update_
    _Update Fedora XX and reload daemon(s)_
_updated pkg-name_
    _Update specified package/rpm and reload daemon(s)_
_search_
    _Search for packages_
_upgrade_
    _Upgrade to Fedora XX_
_schedule_
    _Check when Fedora XX is released_

### Roadmap

* Add ability to use a blacklist of repos you know creates an issue when you upgrade to the next version.
* Add ability to have a whitelist of specific packages you want to update with a certain command.
* When Fedora 28 schedule is up I will do some testing to check that I fetch the right date, or any date at all (see below).
* Add ability to upgrade to final release too if beta is too risky for you (when date syntax has been sorted).

### Changelog

#### 2017-10-07
* Tweaked the code a bit.
* Before upgrading, you will be asked if you want to go through with it.

#### 2017-10-06
* Separated regular update and update+reload daemon(s).
* If you check the schedule when running the recent fedora release, instead of showing the release date it will just indicate you're already running the latest Fedora release.
* Fixed the regex for filtering out the beta release date, so it locks to the exact date, not allowing it to be greedy. If no date is found, it will notify that accurately.

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
