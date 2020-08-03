# Require sinatra, as well as out object model
require'./app/models/simple_object'

# Set database config
db_configuration = YAML.load(File.read('./db/config.yml'))
environment = ENV.fetch('RACK_ENV') { 'development' }
db_env = db_configuration[environment]

# If production, include the url here so we
# don't have to mess with erb
if environment == "production"
    db_env = ENV['DATABASE_URL']
end

ActiveRecord::Base.establish_connection(db_env)