import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import options from '../../options.js';
import { range } from '../../utils.js';

/** @param {any} arg */
const dispatch = arg => Utils.execAsync(`swaymsg workspace ${arg}`);

const Workspaces = () => {
    const ws = options.workspaces.value;
    return Widget.Box({
        children: range(ws || 20).map(i => Widget.Button({
            setup: btn => btn.id = i,
            on_clicked: () => dispatch(i),
            child: Widget.Label({
                label: `${i}`,
                class_name: 'indicator',
                vpack: 'center',
            }),
            connections: [[Hyprland, btn => {
                btn.toggleClassName('active', Hyprland.active.workspace.id === i);
                btn.toggleClassName('occupied', Hyprland.getWorkspace(i)?.windows > 0);
            }]],
        })),
        connections: ws ? [] : [[Hyprland.active.workspace, box => box.children.map(btn => {
            btn.visible = Hyprland.workspaces.some(ws => ws.id === btn.id);
        })]],
    });
};

export default () => Widget.EventBox({
    class_name: 'workspaces panel-button',
    child: Widget.Box({
        // its nested like this to keep it consistent with other PanelButton widgets
        child: Widget.EventBox({
            on_scroll_up: () => dispatch('m+1'),
            on_scroll_down: () => dispatch('m-1'),
            class_name: 'eventbox',
            binds: [['child', options.workspaces, 'value', Workspaces]],
        }),
    }),
});
