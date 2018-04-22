var request = require('request');
var moment = require('moment');
exports.registerPee = (req, res) => {

  var hex = (n) => {
    n = n || 32;
    var result = '';
    while (n--){
      result += Math.floor(Math.random()*16).toString(16);
    }
    return result;
  };

  now = moment().utcOffset(9);
  unixtime = now.valueOf();
  datetime2 = Math.floor(unixtime / 300000) * 300000;
  date = parseInt(now.format('YYYYMMDD'), 10);
  time = now.format('HH:mm');
  datetime = date + ' ' + time;
  event_id = hex();
  minor_version = 2496;

  request.post( {
    uri: 'https://api.piyolog.com/sync',
    headers: {
      'Content-type': 'application/json'
    },
    json: {
      "main_version":1,
      "data":{
        "baby_event":[{
          "datetime2": datetime2,
          "value":0,
          "deleted":false,
          "memo":"",
          "modified_at": unixtime,
          "date": date,
          "main_version":0,
          "amount":0,
          "type": 6,
          "minor_version":0,
          "right_time":0,
          "left_time":0,
          "created_at": unixtime,
          "baby_id":"BABY_ID",
          "image_url":"",
          "user_id":"USER_ID",
          "event_id": event_id,
          "time": time,
          "datetime": datetime
        }]
      },
      "user_id":"USER_ID",
      "minor_version": minor_version,
      "api_version":1,
      "token":"TOKEN"
    }
  }, (error, response, body) => {
    if (error) {
      res.status(400).send('Unknown error!');
    } else {
      if (body.status == 200) {
        res.status(200).send('Success!');
      } else {
        res.status(503).send('Error! status: ' + body.status);
      }
    }
  });
};
