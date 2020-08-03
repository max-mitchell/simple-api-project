# Simple RESTful API

A simple api powered by sinatra and rack. Lives on Heroku [here](https://shrouded-sierra-29495.herokuapp.com/)

To set up locally
* Install [ruby](https://www.ruby-lang.org/en/documentation/installation/) v2.7.0 and [postgresql](https://www.postgresql.org/download/).
* To set up the postgreSQL DB, login to the new postgres account (with `sudo su - postgres` on linux based os). Then run `psql` to access the DB terminal. In order to use UUID's, add the pgcrypto extension with `create extension pgcrypto`. Then, add a new user with `create role simple_api with createdb login password 'veryGoodPassword';`. Don't worry, it's very secure.
* Back on your own account, clone the repo and run `bundle install` inside the newly created folder. Then run `bundle exec rake db:create db:migrate` to create the DB.
* Start the server with `rackup -p [PORT] -s puma` and you are ready to go.