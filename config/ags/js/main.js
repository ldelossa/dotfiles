import { forMonitors } from './utils.js';
import options from './options.js';
import { reloadScss, scssWatcher } from './settings/scss.js';

import TopBar from './bar/TopBar.js';
import Dashboard from './dashboard/Dashboard.js';
import QuickSettings from './quicksettings/QuickSettings.js';
import PowerMenu from './powermenu/PowerMenu.js';
import Notifications from './notifications/Notifications.js';
import Verification from './powermenu/Verification.js';

const windows = () => [
    // forMonitors(TopBar),
    forMonitors(Notifications),
    Dashboard(),
    QuickSettings(),
	PowerMenu(),
	Verification(),
];

function init() {
	reloadScss();
	scssWatcher();
}

export default {
    onConfigParsed: init,
    windows: windows().flat(1),
    maxStreamVolume: 1.05,
    cacheNotificationActions: true,
    closeWindowDelay: {
        'quicksettings': options.transition.value,
        'dashboard': options.transition.value,
    },
};
