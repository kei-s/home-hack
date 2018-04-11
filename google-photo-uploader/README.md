# Google Photo Uploader

## Preperation

```
$ cp credentials.json.sample credentials.json
```

See [https://qiita.com/tamanobi/items/be3eede75c9ede41fce4#curl%E3%81%A7%E7%B0%A1%E5%8D%98picasa-web-albums-data-api%E3%82%92%E4%BD%BF%E3%81%86%E3%81%9F%E3%82%81%E3%81%AE%E8%AA%8D%E5%8F%AF%E6%89%8B%E9%A0%86](Picasa Web Albums Data APIを使うための認可手順)

```
$ bundle install
```

## Run

```
$ ruby server.rb -o 0.0.0.0
```

## Upload file

Upload photos to `http://your-host:4567/upload`
