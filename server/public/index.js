let socket;

const command = (key) => `"${key}" using command down`;

const applications = {
  'Nightly': [
    {
      name: 'New Tab',
      shortcut: command('t')
    }
  ],
  'Code': [
    {
      name: 'Save',
      shortcut: command('s')
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

  socket = io();
  socket.on('current-application', loadApplication);
  socket.emit('request-application');
});
