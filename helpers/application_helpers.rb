# helpers/application_helpers.rb
#
# Helpers, mostly for SimpleObjectApi
module ApplicationHelpers
    # Constants for error messages
    JSON_DATA_ERROR = "Bad JSON data."
    MISSING_UID_ERROR = "Could not find requested uid."
    SAVE_ERROR = "Could not save new object."
    EMPTY_DB_ERROR = "No objects to fetch."
    SERVER_ERROR = "Server error."
    
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
        if !data.present?
            SERVER_ERROR
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