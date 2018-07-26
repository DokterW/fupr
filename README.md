# Fedora Upgrader Redux

Inspired by [fedup](https://fedoraproject.org/wiki/FedUp) and my wish for Fedora releasing a rolling release option.

# fupr has reached EOL

# Go and use [dupr](https://github.com/DokterW/dupr) instead.

## How to install

`wget https://raw.githubusercontent.com/DokterW/fupr/master/install_fupr.sh`

`chmod +x install_fupr.sh`

`./install_fupr.sh`

## More about fupr

fupr goes beyond what fedup was meant to do. It is more of an overlay of dnf to make it easier to keep your system up to date.

Additionally it also has support for flatpak and [doghum](https://github.com/DokterW/doghum) has been merged with fupr.

*fupr will eventually change name soon-ish. I just need to do some more testing and tweaking.*

*Read more about the risks of installing a beta [here](https://fedoraproject.org/wiki/Upgrading).*

Instead of typing _sudo dnf upgrade --refresh_, you just type _fupr update_.

You can also forget about typing
```
sudo dnf upgrade --refresh
sudo dnf system-upgrade download --releasever=XX
sudo dnf system-upgrade reboot
```
Just type _fupr upgrade_, and it also checks if a new released is available before it does the system upgrade. If not, it just updates the current version you have installed.

```
fupr <command> <args>

install
    Install software
remove
    Remove software
update
    Update Fedora XX
update pkg-name
    Update specified package/rpm
update
    Update Fedora XX and reload daemon(s)
updated pkg-name
    Update specified package/rpm and reload daemon(s)
check-update
    Check for updates
search
    Search for packages
upgrade
    Upgrade to Fedora XX
help
    List all commands for dnf, flatpak and doghum.
```

### Roadmap

* Add ability to use a blacklist of repos you know creates an issue when you upgrade to the next version.
* Add ability to have a whitelist of specific packages you want to update with a certain command.
* Add flatpak support.
* change name to remove fedora from the name.

### Changelog

#### 2017-07-24
* Added (partial) doghum support

#### 2017-05-12
* Removed schedule feature. fupr will be much faster now as it won't fetch from the schedule page.

#### 2017-03-24
* For the last two or three release Fedora has change how they name Beta and Final Release in their schedule. I have now removed the schedule checker. It will only show the dates from the schedule dump. Also, when doing a release upgrade it's up to you to know if it has been released or not, no check will be done. This feature might be re-added if schedule for 28 and 29 uses the same labelling.

#### 2017-01-26
* Instead install you can write in, instead of update up, instead upgrade upg, instead search ~~srch~~ sr, instead of check-update chup, instead of schedule schd, instead remove rm.
* Minor fixes.

#### 2017-11-30
* Now fupr also checks for the Final Release release date (ff the final release has the same name as last schedule).
* Tweaked it to speed up things. Fetching information from schedule only once instead of several times.
* If You haven't upgraded to the latest and the Fedora Wiki has been updated, it will not try to skip a version when checking schedule and upgrading.

#### 2017-10-09
* Added check-update.

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
