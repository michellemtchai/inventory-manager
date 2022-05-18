# README

## Required Installations

-   [Docker](https://docs.docker.com/get-docker/)

## Local Development Setup

To setup the environmental variables, run either of the following command in your terminal:

```
# Linux & Mac
cp ./docker/dev.env .env
# Windows
copy .\docker\dev.env .env
```

Then, open up the newly created file `.env`. Replace the value for `OPENWEATHER_SECRET` with your own OpenAI secret API key.

You can also modify the `RAILS_PORT` and `DB_PORT` in `.env` if the port is not available.

To start the app, run the following:

```
docker-compose up
```

Once everything has been compiled, you should be able to view the app in your browser of choice at the following URL:

```
http://localhost:3000
```
