# About this Repo

This is the Git repo of the Docker image for MODX.

## How to use this image

1. Change build context to `apache-simple`
2. Start docker containers

    ```sh
    docker-compose -p modx up -d
    ```

3. Visit [localhost:8000/setup](http://localhost:8000/setup)
4. Enter the installation information
    1. Install Options: `New Installation`
    2. Database Connection and Login
       1. Database Host: `host.docker.internal`
       2. Database Name: `modx`
       3. Database Username: `modx`
       4. Database Password: `modx`
       5. Table Prefix: `modx_`
    3. Default Admin User
       1. E-Mail: <E-MAIL>
       2. Administrator Username: <USERNAME>
       3. Administrator Password: <PASSWORD>
5. Stop docker containers

    ```sh
    docker-compose -p modx down
    ```

## Using apache-preinstalled as base image

1. Change build context to `apache-preinstalled`
2. Start docker containers

    ```sh
    docker-compose -p modx up -d
    ```

3. Visit [localhost:8000](http://localhost:8000)
4. Stop docker containers

    ```sh
    docker-compose -p modx down
    ```
