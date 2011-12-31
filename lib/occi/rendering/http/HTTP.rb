##############################################################################
#  Copyright 2011 Service Computing group, TU Dortmund
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##############################################################################

##############################################################################
# Description: OCCI Rendering
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

module OCCI
  module Rendering
    module HTTP

      ##############################################################################
      # HTTP Status Codes

      HTTP_OK                     = 200
      HTTP_RESOURCE_CREATED       = 201
      HTTP_ACCEPTED               = 202
      HTTP_BAD_REQUEST            = 400
      HTTP_UNAUTHORIZED           = 401
      HTTP_FORBIDDEN              = 403
      HTTP_NOT_FOUND              = 404
      HTTP_METHOD_NOT_ALLOWED     = 405
      HTTP_CONFLICT               = 409
      HTTP_GONE                   = 410
      HTTP_UNSUPPORTED_MEDIA_TYPE = 415
      HTTP_INTERNAL_SERVER_ERROR  = 500
      HTTP_NOT_IMPLEMENTED        = 501
      HTTP_SERVICE_UNAVAILABLE    = 503

      # ---------------------------------------------------------------------------------------------------------------------
      # rendering general parameters
      # responeAttributes: Hash object
      # respone: response object of Sinatra
      # return: text/plain and text/uri: response.body
      # return: text/occi: response[key] head

      def self.prepare_response(response, request)

        $log.info("#################### Information on the client ####################")
        $log.info("Client IP Adress: #{request.env['REMOTE_ADDR']}")
        $log.info("Client User Agent: #{request.env['HTTP_USER_AGENT']}")
        $log.info("###################################################################")

        # determine content type from request content type or reques accept, fallback to text/plain
        content_type = ""
        content_type = request.env['CONTENT_TYPE']  if request.env['CONTENT_TYPE']
        content_type = request.env['HTTP_ACCEPT']   if request.env['HTTP_ACCEPT']
 
        if content_type.include?('application/occi+json')
          response['Content-Type'] = 'application/occi+json'
          
        elsif content_type.include?('application/json')
          response['Content-Type'] = 'application/json'
          
        elsif content_type.include?('text/plain') || content_type.include?('text/*') || content_type.include?('*/*') || content_type == ""
          response['Content-Type'] = 'text/plain'

        elsif content_type.include?('text/uri-list')
          response['Content-Type'] = 'text/uri-list'

        elsif content_type.include?('text/occi')
          response['Content-Type'] = 'text/occi'

        else
          response.status = HTTP_STATUS_CODE["Unsupported Media Type"]
          raise "Unsupported Media Type"
        end

        response['Accept'] = "application/occi+json,application/json,text/plain,text/occi,text/uri-list"
        response['Server'] = "Ruby OCCI Framework/0.4 OCCI/1.1"

        $log.debug("Content type: #{response['Content-Type']}")
        $log.debug("Accept type: #{response['Accept']}")

        # content type independend parameters
        $log.debug("Server: #{response['Server']}")

        # Set default status
        response.status = HTTP_OK

        # Prepare renderer
        OCCI::Rendering::Rendering.prepare_renderer(response['Content-Type'])
      end

    end
  end
end