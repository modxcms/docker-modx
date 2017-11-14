# About this Repo

This is the Git repo of the Docker image for MODX.

## How to use this image
docker-compose.yml
```yml
web:
  image: maki/modx
  links:
    - db:mysql
  ports:
    - 80:80
db:
  image: mysql
  environment:
    MYSQL_ROOT_PASSWORD: example
  ports:
    - 3306:3306
  command: mysqld --sql-mode=NO_ENGINE_SUBSTITUTION
```
