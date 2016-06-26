# Multi Cursor simulation via WebSockets - built with `elm`

### Dev setup
```sh
$ npm install -g elm
$ git clone https://github.com/rajasharan/elm-mice
$ cd elm-mice

$ elm reactor
Listening on http://localhost:8000/
```

### Full compilation
```sh
$ elm make Main.elm --output elm.js

# Run local webserver using lite-server or python or any framework of choice
# Navigate to index.html where the local server is deployed
$ npm install -g lite-server
$ lite-server
Localhost Started on 3001
```

### Broadcast to Multiple Users via WebSockets
```sh
$ cd server
$ npm install
$ node server.js
WebSocketServer started on port 3000
```

## Connect to WebSocket Server
```html
Now append the <server-ip>:<port> as a hash Location
For e.g: http://rajasharan.github.io/elm-mice/#ws://192.168.X.XX:3000
```

```html
Or if the elm frontend server is running in localhost:2000 and websocket server in localhost:3000
then url is: http://localhost:2000/#ws://localhost:3000

Open in multiple browsers to test.</port>
```

### [License](/LICENSE)
The MIT License (MIT)
