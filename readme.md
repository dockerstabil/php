# dockerstabil/php


# Usage

```bash
# apache
docker run -p 80:80 -v "$PWD":/app --rm -it dockerstabil/php:apache

# cli
docker run -v "$PWD":/app --rm -it dockerstabil/php:cli php -v
```


## License

MIT © [Michael Mayer](http://schnittstabil.de)
