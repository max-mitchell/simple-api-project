# app/simple_object_api.rb
# Control for the api.
# Provides ability to create, edit, fetch, and destroy
# simple json objects

class SimpleObjectApi < Sinatra::Base
    # Constants for error messages
    JSON_DATA_ERROR = "Bad JSON data."
    MISSING_UID_ERROR = "Could not find requested uid."
    SAVE_ERROR = "Could not save new object."
    EMPTY_DB_ERROR = "No objects to fetch."
    SERVER_ERROR = "Server error."


    # Helper methods for the various api routes
    helpers do
        # Parse incoming json data
        def json_params
            begin
                JSON.parse(request.body.read)
            rescue
                halt(send_error(request, url, JSON_DATA_ERROR))
            end
        end

        # Send an array as json data
        def send_json(data)
            if data.blank?
                send_error "", "", SERVER_ERROR
            else
                JSON.pretty_generate(JSON.load(data.to_json))
            end
        end

        # Format SimpleObject, then send
        def send_simple_object(obj)
            data = {
                "uid": obj.id,
                "json-data": obj.data
            }
            send_json data
        end

        # Error messages
        def send_error(req, url, msg)
            status 400
            send_json :verb => req.request_method, :url => url, :error => msg
        end
    end

    # Create route
    post '/api/objects' do
        # Read json data from request and make a new simple_object
        simple_object = SimpleObject.create(data: json_params)

        # If the object saves, return the object
        if simple_object.save
            send_simple_object simple_object
        else
            # Otherwise, return an error
            send_error request, url, SAVE_ERROR
        end
    end

    # Edit route
    put '/api/objects/:id' do
        # Find object for given id
        simple_object = SimpleObject.where(id: params[:id]).first

        # If the object can't be found, return an error
        halt(send_error(request, url, MISSING_UID_ERROR)) unless simple_object
        # Otherwise, update and return
        simple_object.update(data: json_params)

        # Send back data
        send_simple_object simple_object
    end

    # Fetch route
    get '/api/objects/:id' do
        # Find object for given id
        simple_object = SimpleObject.where(id: params[:id]).first

        # If the object can't be found, return an error
        halt(send_error(request, url, MISSING_UID_ERROR)) unless simple_object
        # Send back data
        send_simple_object simple_object
    end

    # Fetch all route
    get '/api/objects' do
        # Get all objects
        all_objects = []
        SimpleObject.all.each do |obj|
            all_objects << {:url => "#{url}/#{obj.id}"}
        end

        # If the list is empty, return an error
        halt(send_error(request, url, EMPTY_DB_ERROR)) unless !all_objects.empty?
        # Otherwise, return the objects urls
        send_json all_objects
    end

    # Delete route
    delete '/api/objects/:id' do
        # Find object for given id
        simple_object = SimpleObject.where(id: params[:id]).first

        # If the object is real, delete it
        simple_object.destroy if simple_object
        status 200
    end
end