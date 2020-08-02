# server.rb
# Control for the api.
# Provides ability to create, edit, fetch, and destroy
# simple json objects

# Require sinatra, as well as out object model
require 'sinatra'
require 'active_record'
require_relative '../models/simple_object'

# Set database config
def db_configuration
    db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'db', 'config.yml')
    YAML.load(File.read(db_configuration_file))
end
ActiveRecord::Base.establish_connection(db_configuration["development"])

before do
    request.body.rewind
    if !request.body.read.blank?
        @json_data = JSON.parse(request.body.read)
    else
        @json_data = false
    end
end

helpers do
    # Send an array as json data
    def send_json(data)
        if data.blank?
            return error_message
        else
            JSON.pretty_generate(JSON.load(data.to_json))
        end
    end

    # Simple error message
    def error_message
        status 200
        send_json :error => "no data"
    end
end

# Create route
get '/api/objects' do
    if !@json_data
        error_message
    else
        # Read json data from request and make a new simple_object
        @simple_object = SimpleObject.create(data: @json_data)

        # If the object saves, return the object
        if @simple_object.save
            send_json @simple_object
        else
            # Otherwise, return an error
            error_message
        end
    end
end
