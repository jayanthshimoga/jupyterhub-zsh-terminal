import { ILauncher } from '@jupyterlab/launcher';
const plugin = {
    id: 'zsh-launcher:plugin',
    autoStart: true,
    requires: [ILauncher],
    activate: (app, launcher) => {
        // Register the command that opens a Zsh terminal
        const commandID = 'zsh-launcher:open';
        app.commands.addCommand(commandID, {
            label: 'New Zsh Terminal',
            execute: () => app.commands.execute('terminal:create-new', { shell: '/usr/bin/zsh' })
        });
        // Add it to the Launcher
        launcher.add({
            command: commandID,
            category: 'Terminal',
            rank: 1
        });
    }
};
export default plugin;
//# sourceMappingURL=index.js.map