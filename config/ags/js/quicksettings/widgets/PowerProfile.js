import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import icons from '../../icons.js';
import Profilectl from '../../services/powerprofilectl.js';
import { ArrowToggleButton, Menu } from '../ToggleButton.js';

export const ProfileToggle = () => ArrowToggleButton({
    name: 'powerprofilectl-profile',
    icon: Widget.Icon({
        binds: [['icon', Profilectl, 'profile', p => icons.powerprofilectl.profile[p]]],
    }),
    label: Widget.Label({
        binds: [['label', Profilectl, 'profile']],
    }),
    connection: [Profilectl, () => Profilectl.profile !== 'balanced'],
    activate: () => Profilectl.setProfile('power-saver'),
    deactivate: () => Profilectl.setProfile('balanced'),
    activateOnArrow: false,
});

export const ProfileSelector = () => Menu({
    name: 'powerprofilectl-profile',
    icon: Widget.Icon({
        binds: [['icon', Profilectl, 'profile', p => icons.powerprofilectl.profile[p]]],
    }),
    title: Widget.Label('Profile Selector'),
    content: [
        Widget.Box({
            vertical: true,
            hexpand: true,
            children: [
                Widget.Box({
                    vertical: true,
                    children: Profilectl.profiles.map(prof => Widget.Button({
                        on_clicked: () => Profilectl.setProfile(prof),
                        child: Widget.Box({
                            children: [
                                Widget.Icon(icons.powerprofilectl.profile[prof]),
                                Widget.Label(prof),
                            ],
                        }),
                    })),
                }),
            ],
        }),
    ],
});
