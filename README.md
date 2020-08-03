# Simple RESTful API

A simple api powered by sinatra and rack. Lives on Heroku [here](https://shrouded-sierra-29495.herokuapp.com/)

To set up locally
* Install [ruby](https://www.ruby-lang.org/en/documentation/installation/) v2.7.0 and [postgresql](https://www.postgresql.org/download/).
* To set up the postgreSQL DB, login to the postgres account (with `sudo su - postgres` on linux based os). Run`psql` to access the DB terminal. Then, add a new user with `create role simple_api with createdb login password 'veryGoodPassword';`. Don't worry, it's very secure.
* Back on your own account, clone the repo and run `bundle install` inside the newly created folder. Then run `bundle exec rake db:create` to create the DB.
* Because we don't want to hand out superuser accounts, at this point go back to the postgresql console and add the pgcrypto extension to the DB's we just created. This is done by 
    ```sql
    \c simple_api_development;
    create extension pgcrypto;
    \c simple_api_test;
    create extension pgcrypto;
    ```
    Then, again back in your own account and in the new project folder, run `bundle exec rake db:migrate`. Re run that command with `RACK_ENV=test` at the front to generate the test DB.
* Tests are run with `bundle exec rake test`.
* Start the server with `rackup -p [PORT] -s puma`, where PORT is any port of your choice.