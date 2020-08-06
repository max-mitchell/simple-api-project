# helpers/application_helpers.rb
#
# Helpers, mostly for SimpleObjectApi
module ApplicationHelpers
    # Constants for error messages
    JSON_DATA_ERROR = "Bad JSON data."
    MISSING_UID_ERROR = "Could not find requested uid."
    SAVE_ERROR = "Could not save new object."
    
    # Parse incoming json data
    def json_params
        begin
            parsed = JSON.parse(request.body.read)
            # Drop any top level uid key, we don't want to store this
            parsed.delete('uid') if parsed.key?('uid')
            return parsed
        rescue
            halt(send_error(request, url, JSON_DATA_ERROR))
        end
    end

    # Send an array as json data
    def send_json(data)
        if !data.present?
            # Just in case something goes wrong
            "[]"
        else
            JSON.pretty_generate(JSON.load(data.to_json))
        end
    end

    # Format SimpleObject, then send
    def send_simple_object(obj)
        data = {:uid => obj.id}
        if obj.data.is_a? String
            data.merge!(JSON.parse(obj.data))
        else
            data.merge!(obj.data)
        end
        
        send_json data
    end

    # For sending error messages
    def send_error(req, url, msg)
        status 400
        send_json :verb => req.request_method, :url => url, :message => msg
    end
end