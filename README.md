# Initial configuration

1. Allow local ssh access via the Synology web user interface.
2. While you're in there, create home directories for your users.


## BusyBox configuration

Note that the `root` and `admin` users share the same password.
We'll pretend you called your Synology `Fileserver` and have `ssh` listening on the usual port 22.

1. `ssh root@Fileserver.local`
2. While BusyBox is a Debian flavor of linux, it doesn't provide `dpkg`.
   Instead, install `ipkg` by running [`setup_ipkg.sh`](setup_ipkg.sh) as root on `Fileserver`:

       ssh root@Fileserver.local sh < setup_ipkg.sh

   The `setup_ipkg.sh` script is based on @trepmag's [optware bootstrap](https://github.com/trepmag/ds213j-optware-bootstrap).

These pages were also helpful:

* http://setaoffice.com/2011/04/08/how-to-install-compiled-programs-on-a-synology-nas/
* http://forum.synology.com/wiki/index.php/Overview_on_modifying_the_Synology_Server,_bootstrap,_ipkg_etc

And these are the Optware lists that different distros pull from:

* http://ipkg.nslu2-linux.org/feeds/optware/syno-i686/cross/stable/
* http://ipkg.nslu2-linux.org/feeds/optware/ds101/cross/unstable/ds101-bootstrap_1.0-4_armeb.xsh
* http://ipkg.nslu2-linux.org/feeds/optware/syno-i686/cross/unstable/syno-i686-bootstrap_1.2-7_i686.xsh
* http://ipkg.nslu2-linux.org/feeds/optware/syno-x07/cross/unstable/syno-x07-bootstrap_1.2-7_arm.xsh
* http://ipkg.nslu2-linux.org/feeds/optware/cs08q1armel/cross/unstable/ipkg-opt_0.99.163-10_arm.ipk

Depending on the make and model of your Synology NAS, you'll need to fetch a different feed.

I have a DS214se (Series "x14"), and its specs are:

* CPU: Marvell Armada 370 armv7l
* GHz: 0.8
* Cores: 1
* Threads: 1
* Package Arch: armada370
* RAM: DDR3 256MB


## Notes on Synology's BusyBox configuration

* `/etc/shells` is not accurate.
* Run `ipkg update` as root to update the list of available ipkg-installable packages.
* Run `ipkg install tmux bash` as root, for example, to install tmux and bash.
* `~admin` should expand to `/var/services/homes/admin`
* `~admin/.ssh/authorized_keys2` is a typical `authorized_keys` file where the admin user's public SSH keys are stored.
  If it doesn't let you login using SSH key authentication, the permissions are probably wrong.
  They should be:

      lrwxrwxrwx root:root   /var/services/homes -> /volume1/homes
      drwxr-xr-x admin:users /var/services/homes/admin
      drwx------ admin:users /var/services/homes/admin/.ssh
      -rw-r--r-- admin:users /var/services/homes/admin/.ssh/authorized_keys2

  If not, the following commands should fix them:

      chown -R admin:users ~admin
      chmod 777 ~admin/.ssh
      chmod 644 ~admin/.ssh/authorized_keys2


## Restoring normalcy (customizations) after a system update

1. Login as root: `ssh root@Fileserver.local`
2. Run `cat ~admin/etc-profile > /etc/profile`
3. Logout
4. Login as admin, `ssh admin@Fileserver.local` and do whatever you wanted to do.
