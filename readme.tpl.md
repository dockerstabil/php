# dockerstabil/php


# Usage

```bash
# apache
docker run -p 80:80 -v "$PWD":/app --rm -it dockerstabil/php:{{.PHP_VERSION}}-apache
docker run -p 80:80 -v "$PWD":/app --rm -it dockerstabil/php:{{.PHP_VERSION}}-apache-dev

# cli
docker run -v "$PWD":/app --rm -it dockerstabil/php:{{.PHP_VERSION}}-cli php -v
docker run -v "$PWD":/app --rm -it dockerstabil/php:{{.PHP_VERSION}}-cli-dev php -v
```


# php.ini

* [https://github.com/php/php-src](https://github.com/php/php-src)

```bash
# get version
docker run --rm -it dockerstabil/php:{{.PHP_VERSION}}-apache-dev php -v
# => PHP {{.PHP_VERSION}} [...]
curl -O https://raw.githubusercontent.com/php/php-src/php-{{.PHP_VERSION}}/php.ini-development
curl -O https://raw.githubusercontent.com/php/php-src/php-{{.PHP_VERSION}}/php.ini-production

# apache
docker run -p 80:80 -v "$PWD":/app -v "$PWD"/php.ini-development:/usr/local/etc/php/conf.d/php.ini --rm -it dockerstabil/php:{{.PHP_VERSION}}-apache-dev
```


## License

MIT © [Michael Mayer](http://schnittstabil.de)
