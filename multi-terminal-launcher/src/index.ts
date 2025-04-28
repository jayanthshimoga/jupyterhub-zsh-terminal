import {
  JupyterFrontEnd, JupyterFrontEndPlugin
} from '@jupyterlab/application';
import {
  ILauncher
} from '@jupyterlab/launcher';
import { PageConfig } from '@jupyterlab/coreutils';

/**
 * Single “New Zsh Terminal” tile, now sending the correct XSRF header.
 */
const zshLauncher: JupyterFrontEndPlugin<void> = {
  id: 'zsh-launcher:plugin',
  autoStart: true,
  requires: [ILauncher],
  activate: (app: JupyterFrontEnd, launcher: ILauncher) => {
    const COMMAND = 'zsh-launcher:open';
    const base = app.serviceManager.serverSettings.baseUrl.replace(/\/$/, '');
    const url  = `${base}/api/zsh_terminal`;

    app.commands.addCommand(COMMAND, {
      label: 'New Zsh Terminal',
      execute: async () => {
        // Grab the XSRF token
        const xsrf = PageConfig.getToken();
        const resp = await fetch(url, {
          method: 'POST',
          credentials: 'same-origin',
          headers: {
            'X-XSRFToken': xsrf
          }
        });
        if (!resp.ok) {
          console.error('Zsh spawn failed:', await resp.text());
          return;
        }
        const model = await resp.json();
        return app.commands.execute('terminal:open', {
          name: model.name
        });
      }
    });

    launcher.add({ command: COMMAND, category: 'Terminal', rank: 2 });
  }
};

export default zshLauncher;
