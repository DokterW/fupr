# Fedora Upgrader Redux

Inspired by [fedup](https://fedoraproject.org/wiki/FedUp) and my wish for Fedora releasing a rolling release option.

For now it's just a simple tool to upgrade to the next Fedora Beta, do a system upgrade of your current version with the _--refresh_ flag and to check when the next Fedora Beta might be released.

Read more about the risks of installing a beta [here](https://fedoraproject.org/wiki/Upgrading).

_fupr <command>_

_upgrade - Upgrade to $FUPRBTV Beta._
_update - Update $FUPROSV_
_schedule - Check when $FUPRBTV Beta is released._

### Roadmap

* Add ability to use a blacklist of repos you know creates an issue when you upgrade to the next version.
* Add ability to upgrade to final release too if beta is too risky for you.
* Add check for if you are root or not, so you don't use sudo as root as it's not needed.
* Add a flag for if you're doing a system update that you restart your services.

### Changelog

#### 2017-10-02
* Released!
