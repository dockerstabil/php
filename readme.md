# dockerstabil/php


# Usage

```bash
# apache
docker run -p 80:80 -v "$PWD":/app --rm -it dockerstabil/php:apache

# cli
docker run -v "$PWD":/app --rm -it dockerstabil/php:cli php -v
```


# php.ini

* [https://github.com/php/php-src](https://github.com/php/php-src)

```bash
# get version
docker run --rm -it dockerstabil/php:apache php -v
# => PHP 7.2.5 [...]
curl -O https://raw.githubusercontent.com/php/php-src/php-7.2.5/php.ini-development
curl -O https://raw.githubusercontent.com/php/php-src/php-7.2.5/php.ini-production

# apache
docker run -p 80:80 -v "$PWD":/app -v "$PWD"/php.ini-development:/usr/local/etc/php/conf.d/php.ini --rm -it dockerstabil/php:apache
```


## License

MIT © [Michael Mayer](http://schnittstabil.de)
