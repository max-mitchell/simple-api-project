# app/simple_object_api.rb
# Control for the api.
# Provides ability to create, edit, fetch, and destroy
# simple json objects

class SimpleObjectApi < Sinatra::Base
    helpers ApplicationHelpers

    # Returns urls to all objects
    def return_all(req, source_url)
        all_objects = []
        SimpleObject.all.each do |obj|
            all_objects << {:url => "#{source_url}/#{obj.id}"}
        end

        # If the list is empty, return an error
        halt(send_error(req, source_url, EMPTY_DB_ERROR)) unless !all_objects.empty?
        # Otherwise, return the objects urls
        return all_objects
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
        # If the id is empty, assume the user wants all objects
        return send_json return_all(request, url) unless params[:id]
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
        send_json return_all(request, url)
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