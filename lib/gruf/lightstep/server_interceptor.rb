# Copyright (c) 2017-present, BigCommerce Pty. Ltd. All rights reserved
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
module Gruf
  module Lightstep
    ##
    # Intercepts inbound calls to provide LightStep tracing
    #
    class ServerInterceptor < Gruf::Interceptors::ServerInterceptor
      ##
      # Handle the gruf around hook and trace sampled requests
      #
      def call(&_block)
        return yield if options.fetch(:ignore_methods, []).include?(request.method_name)

        result = nil

        tracer = ::Bigcommerce::Lightstep::Tracer.instance
        tracer.start_span(request.method_name, context: request_method.headers.to_h) do |span|
          span.set_tag('grpc.method', request.method_key)
          span.set_tag('grpc.request_class', request.request_class)
          span.set_tag('grpc.service', request.service_key)

          begin
            result = yield
          rescue StandardError => e
            if e.is_a?(::GRPC::BadStatus)
              span.set_tag('error', true)
              span.set_tag('grpc.error', true)
              span.set_tag('grpc.error_code', e.code)
              span.set_tag('grpc.error_class', e.class)
            end
            raise # passthrough, we just want the annotations
          end
        end
        result
      end

      private

      def request_method
        Gruf::Lightstep::Method.new(request.active_call, request.method_key, request.message)
      end
    end
  end
end
