
var homepage = "http://www.google.co.jp/";
user_pref("browser.startup.homepage", homepage);
user_pref("browser.newtab.url", homepage);

user_pref("browser.search.openintab", true);
user_pref("browser.cache.disk.parent_directory", "/tmp/ffcache");

// disable mousewheel action
// Firefox 16 or earlier
//user_pref("mousewheel.withcontrolkey.action", 0);
// Firefox 17 or later
user_pref("mousewheel.with_control.action", 0);

