let express = require('express');
let morgan = require('morgan');
let googlehome = require('google-home-notifier');
let app = express();
app.use(morgan('combined'));

let credentials = require('./credentials.json');

app.get('/speak', (req, res) => {
  console.log(req.query);
  let text = req.query.text;

  if (credentials.deviceName) {
    googlehome.device(credentials.deviceName, credentials.language);
  } else {
    googlehome.ip(credentials.ip, credentials.language);
  }

  if (!text) {
    res.send('Request: GET /speak?text=こんにちは');
  }

  try {
    googlehome.notify(text, (notifyRes) => {
      console.log(notifyRes);
      res.send(credentials.deviceName + ' will say: ' + text + '\n');
    });
  } catch (err) {
    console.log(err);
    res.sendStatus(500);
    res.send(err);
  }
});

let server = app.listen(credentials.port, () => {
  console.log('Server started on: %s:%s', server.address().address, server.address().port);
});
