/**
 * A Theme is a set of options that will be applied
 * ontop of the default values. see options.js for possible options
 */
import { Theme, WP, lightColors } from './settings/theme.js';

export default [
    Theme({
        name: 'Dark',
        icon: '󰄛',
        'desktop.wallpaper.img': WP + 'kittybl.jpeg',
    }),
    Theme({
        name: 'Light',
        icon: '󰄛',
        'desktop.wallpaper.img': WP + 'kitty.jpeg',
        ...lightColors,
        'theme.widget.bg': '$accent',
        'theme.widget.opacity': 64,
    }),
];
