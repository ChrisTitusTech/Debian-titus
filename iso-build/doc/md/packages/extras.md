
### Extras

Components that are not part of the official Debian distribution are listed in [Makefile.extra](https://gitlab.com/nodiscc/debian-live-config/-/blob/master/Makefile.extra):

<!-- grep '# EXTRA' Makefile.extra -->

 - <https://github.com/az0/cleanerml>
 - <https://github.com/nodiscc/user.js>
 - <https://github.com/EionRobb/pidgin-opensteamworks/>
 - <https://github.com/yt-dlp/yt-dlp>
 - <https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/>
 - <https://addons.mozilla.org/en-US/firefox/addon/cookie-autodelete/>

These components are downloaded from a [third-party repository](http://nodiscc.gitlab.io/toolbox) or directly from their upstream project. You will not receive any updates for these packages unless you [enable the APT repository manually](https://gitlab.com/nodiscc/debian-live-config/-/blob/bullseye/config/includes.chroot/etc/apt/sources.list.d/debian-live-config.list) or if an official package with the same name is someday [added to Debian repositories](https://wnpp.debian.net/).
