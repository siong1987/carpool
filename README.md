# Carpool

A carpool app for Malaysian general election, 2018.

## Docker setup

We use [Docker](https://www.docker.com/community-edition) to manage our dependencies for development.

To setup docker, make sure that you follow these steps:

1.  Install [Docker](https://www.docker.com/community-edition#/download) on your computer.
2.  To create the dependencies, in the work directory, run `docker-compose build`.
3.  To install all the required Ruby gems, run `docker-compose run app bundle`.
4.  To setup the seed database, run `docker-compose run app rake db:setup`.
5.  To get the local server up, run `docker-compose up`.
6.  Visit `localhost:3000` for the local server.
