import PanelButton from "../PanelButton"
import options from "options"
import { sh, range } from "lib/utils"

const hyprland = await Service.import("hyprland")
const { workspaces } = options.bar.workspaces

const dispatch = (arg: string | number) => {
    sh(`hyprctl dispatch workspace ${arg}`)
}

// const Workspaces = (ws: number) => Widget.Box({
//     children: range(ws || 20).map(i => Widget.Label({
//         attribute: i,
//         vpack: "center",
//         label: `${i}`,
//         setup: self => self.hook(hyprland, () => {
//             self.toggleClassName("active", hyprland.active.workspace.id === i)
//             self.toggleClassName("occupied", (hyprland.getWorkspace(i)?.windows || 0) > 0)
//         }),
//     })),
//     setup: box => {
//         if (ws === 0) {
//             box.hook(hyprland.active.workspace, () => box.children.map(btn => {
//                 btn.visible = hyprland.workspaces.some(ws => ws.id === btn.attribute)
//             }))
//         }
//     },
// })

const Workspaces = () => Widget.EventBox({
    onScrollUp: () => dispatch('+1'),
    onScrollDown: () => dispatch('-1'),
    child: Widget.Box({
        children: Array.from({ length: 10 }, (_, i) => i + 1).map(i => Widget.Button({
            attribute: i,
            label: `${i}`,
            onClicked: () => dispatch(i),
        })),

        // remove this setup hook if you want fixed number of buttons
        setup: self => self.hook(hyprland, () => self.children.forEach(btn => {
            btn.visible = hyprland.workspaces.some(ws => ws.id === btn.attribute);
        })),
    }),
})

export default () => PanelButton({
    window: "overview",
    class_name: "workspaces",
    on_scroll_up: () => dispatch("m+1"),
    on_scroll_down: () => dispatch("m-1"),
    on_clicked: () => App.toggleWindow("overview"),
    child: workspaces.bind().as(Workspaces),
})
