# app/simple_object_api.rb
# Control for the api.
# Provides ability to create, edit, fetch, and destroy
# simple json objects

class SimpleObjectApi < Sinatra::Base
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
                status 500
            else
                JSON.pretty_generate(JSON.load(data.to_json))
            end
        end

        # Format SimpleObject, then send
        def send_simple_object(obj)
            send_json ["uid" => obj.id, "json-data" => obj.data]
        end

        # Error messages
        def send_error(req, url, msg)
            status 400
            send_json :verb => req.request_method, :url => url, :error => msg
        end
    end

    # Create route
    post '/api/objects' do
        if !@json_data
            send_error request, url, "No data provided."
        else
            # Read json data from request and make a new simple_object
            @simple_object = SimpleObject.create(data: @json_data)

            # If the object saves, return the object
            if @simple_object.save
                # Send back data
                send_simple_object @simple_object
            else
                # Otherwise, return an error
                send_error request, url, "Could not save new object."
            end
        end
    end

    # Edit route
    put '/api/objects/:id' do
        if !@json_data
            send_error request, url, "No data provided."
        else
            # Find object for given id
            @simple_object = SimpleObject.where(id: params[:id]).first

            # If the object can't be found, return an error
            if @simple_object.blank?
                send_error request, url, "Could not find requested uid."
            else
                # Otherwise, update and return
                @simple_object.update(data: @json_data)

                # Send back data
                send_simple_object @simple_object
            end
        end
    end

    # Fetch route
    get '/api/objects/:id' do
        # Find object for given id
        @simple_object = SimpleObject.where(id: params[:id]).first

        # If the object can't be found, return an error
        if @simple_object.blank?
            send_error request, url, "Could not find requested uid."
        else
            # Send back data
            send_simple_object @simple_object
        end
    end

    # Fetch all route
    get '/api/objects' do
        # Get all objects
        all_objects = []
        SimpleObject.all.each do |obj|
            all_objects << {:url => "#{url}/#{obj.id}"}
        end

        # Return list of urls
        send_json all_objects
    end

    # Delete route
    delete '/api/objects/:id' do
        # Find object for given id
        @simple_object = SimpleObject.where(id: params[:id]).first

        # If the object is real, delete it
        if !@simple_object.blank?
            @simple_object.destroy
        end
            status 200
    end
end