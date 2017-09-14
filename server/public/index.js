let socket;

const command = (key) => `"${key}" using command down`;

const mixins = {
  editor: [
    {
      name: 'Save',
      shortcut: command('s')
    }
  ],
  tabbed: [
    {
      name: 'New Tab',
      shortcut: command('t')
    }
  ],
  windowed: [
    {
      name: 'New Window',
      shortcut: command('n')
    }
  ]
};

const applications = {
  'Nightly': [
    ...mixins.tabbed,
    ...mixins.windowed
  ],
  'Code': [
    ...mixins.editor,
    {
      name: 'New Tab',
      shortcut: command('n')
    }
  ]
};

const getButtons = () => Array.from(document.getElementsByTagName('button'));

const clearButtons = () => {
  getButtons().forEach((button) => {
    button.remove();
  });
};

const addButton = (name, shortcut) => {
  const button = document.createElement('button');
  button.appendChild(document.createTextNode(name));

  button.onclick = () => {
    socket.emit('run-shortcut', shortcut);
  };

  document.body.appendChild(button);
};

const loadApplication = (application) => {
  clearButtons();

  const currentApplication = applications[application];
  if (!currentApplication) {
    return;
  }

  currentApplication.forEach((shortcut) => {
    addButton(shortcut.name, shortcut.shortcut);
  });
};

document.addEventListener('DOMContentLoaded', () => {
  document.addEventListener('touchmove', event => event.preventDefault());

  socket = io(); // eslint-disable-line no-undef
  socket.on('current-application', loadApplication);
  socket.emit('request-application');
});
