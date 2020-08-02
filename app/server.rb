# server.rb
# Control for the api.
# Provides ability to create, edit, fetch, and destroy
# simple json objects

# Require environment
require './config/environment'

before do
    if !request.body.read.blank?
        request.body.rewind
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

    # Error messages
    def empty_error
        status 200
        send_json :error => "Received no data"
    end

    def save_error
        status 200
        send_json :error => "Failed to save json data"
    end

    def find_error
        status 200
        send_json :error => "No object exists for that uid"
    end
end

# Create route
post '/api/objects' do
    if !@json_data
        empty_error
    else
        # Read json data from request and make a new simple_object
        @simple_object = SimpleObject.create(data: @json_data)

        # If the object saves, return the object
        if @simple_object.save
            send_json @simple_object
        else
            # Otherwise, return an error
            save_error
        end
    end
end

# Edit route
put '/api/objects/:id' do
    if !@json_data
        empty_error
    else
        # Find object for given id
        @simple_object = SimpleObject.where(id: params[:id]).first

        # If the object can't be found, return an error
        if @simple_object.blank?
            find_error
        else
            # Otherwise, update and return
            @simple_object.update(data: @json_data)
            send_json @simple_object
        end
    end
end

# Edit route
get '/api/objects/:id' do
    # Find object for given id
    @simple_object = SimpleObject.where(id: params[:id]).first

    # If the object can't be found, return an error
    if @simple_object.blank?
        find_error
    else
        # Otherwise return
        send_json @simple_object
    end
end
