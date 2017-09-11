const express = require('express');
const http = require('http');
const makeSocketIo = require('socket.io');

const PORT = 3000;
const PUBLIC_DIR = 'public';

const app = express();
const server = http.Server(app);
const socketIo = makeSocketIo(server);

const emit = (event, data) => {
    console.log(`${event} emitted!`);
    socketIo.emit(event, data);
};

const on = (listener, event, handler) => {
    console.log(`${event} received!`);
    listener.on(event, handler);
};

const passthrough = (listener, event) => {
    on(listener, event, (data) => {
        emit(event, data);
    });
};

on(socketIo, 'connection', (socket) => {
    on(socket, 'disconnect', () => {});
    passthrough(socket, 'request-application');
    passthrough(socket, 'current-application');
    passthrough(socket, 'run-shortcut');
});

app.use(express.static(PUBLIC_DIR));
server.listen(PORT, () => {
    console.log(`Server listening on :${PORT}!`);
});