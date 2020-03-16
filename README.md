# hasura-boilerplate

Hasura GraphQL Engine is a blazing-fast GraphQL server that gives you instant, realtime GraphQL APIs over Postgres, with webhook triggers on database events, and remote schemas for business logic.

Read more at [hasura.io](https://hasura.io/) and the [docs](https://docs.hasura.io/).

## Installation

### [Docker](https://docs.docker.com/install/)

Docker Engine is an open source containerization technology for building and containerizing your applications.

Hasura GraphQL Engine runs on Docker.

### [Docker-compose](https://docs.docker.com/compose/install/)

Docker Compose relies on Docker Engine for any meaningful work, so make sure you have Docker Engine installed either locally or remote, depending on your setup.

## Getting started

### .env (Environment variables)

Before running a Hasura GraphQL Engine, you should set the environment variables(.env).

key settings are described below. (Use "awk -v ORS='\\n' '1' ./.key/public.pem")

```
HASURA_GRAPHQL_PORT=8080
HASURA_GRAPHQL_ADMIN_SECRET=1234
HASURA_GRAPHQL_JWT_SECRET={"type": "RS256", "key": "here", "claims_namespace": "claims", "claims_format": "json"}

POSTGRES_PORT=5432
POSTGRES_PASSWORD=1234
POSTGRES_DB=postgres
POSTGRES_VOLUME=./postgres

PGADMIN_PORT=5433
PGADMIN_USER=postgres
PGADMIN_PASSWORD=1234
```

### config.yaml

This is for Hasura CLI.

```
endpoint: http://localhost:8080/
admin_secret: 1234
```

### Let's run the server

Install Package(included [Hasura-CLI](https://docs.hasura.io/1.0/graphql/manual/hasura-cli/install-hasura-cli.html) is a command line interface which is the primary mode of managing Hasura projects and migrations.)

```shell
yarn install
```

Run Hasura GraphQL Engine, first.

```shell
yarn start
```

Go to the root directory of the project and run below command.

```shell
yarn migrate:apply
```

### Gen JWT key(RS256)

Generate the RSA keys

```shell
mkdir .key
openssl genrsa -out ./.key/private.pem 2048
openssl rsa -in ./.key/private.pem -pubout > ./.key/public.pem
```

print the keys in an escaped format

```shell
awk -v ORS='\\n' '1' ./.key/private.pem
awk -v ORS='\\n' '1' ./.key/public.pem
```

https://hasura.io/blog/hasura-authentication-explained/#custom-jwt-server

https://hasura.io/blog/add-authentication-and-authorization-to-next-js-8-serverless-apps-using-jwt-and-graphql/
