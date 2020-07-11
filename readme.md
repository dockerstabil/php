# dockerstabil/php


# Usage

```bash
# apache
docker run -p 80:80 -v "$PWD":/app --rm -it dockerstabil/php:7.4.8-apache
docker run -p 80:80 -v "$PWD":/app --rm -it dockerstabil/php:7.4.8-apache-dev

# cli
docker run -v "$PWD":/app --rm -it dockerstabil/php:7.4.8-cli php -v
docker run -v "$PWD":/app --rm -it dockerstabil/php:7.4.8-cli-dev php -v
```


# php.ini

* [https://github.com/php/php-src](https://github.com/php/php-src)

```bash
# get version
docker run --rm -it dockerstabil/php:7.4.8-apache-dev php -v
# => PHP 7.4.8 [...]
curl -O https://raw.githubusercontent.com/php/php-src/php-7.4.8/php.ini-development
curl -O https://raw.githubusercontent.com/php/php-src/php-7.4.8/php.ini-production

# apache
docker run -p 80:80 -v "$PWD":/app -v "$PWD"/php.ini-development:/usr/local/etc/php/conf.d/php.ini --rm -it dockerstabil/php:7.4.8-apache-dev
```


## License

MIT © [Michael Mayer](http://schnittstabil.de)
