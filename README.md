# Sinatra-sample

This is Memo app using Sinatra

## Installation

```
$ git clone -b feature/build-with-Sinatra https://github.com/kyokucho1989/Sinatra-sample.git
```

```
$ cd ./Sinatra-sample
$ bundle
```


```
$ createdb sinatra-db
$ psql sinatra-db
# CREATE SEQUENCE id;
# CREATE TABLE memotable(id integer, title varchar, content varchar);
```

And run with:

```
$ ruby my_app.rb
```

View at: http://localhost:4567
