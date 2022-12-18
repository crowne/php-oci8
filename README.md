# php-oci8

This project creates a docker image for running php7 with oci8 to connect to an Oracle database.  

## Build

```shell
$ docker build --force-rm=true --no-cache=true -t crowne/php-oci8:7-fpm-alpine -f Dockerfile .
$ docker push crowne/php-oci8:7-fpm-alpine
```

## Test

```shell
$ cd test
$ docker compose up -d
```

Wait a minute for the database to start.  
Open your browser at http://localhost:8080/dbtest.php

For a terminal on the containers
```shell
$ docker exec -it hexcontainerid sh
```

To shut-down
```shell
$ docker compose down
```
