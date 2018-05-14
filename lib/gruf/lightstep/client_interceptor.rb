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
    # Intercepts outbound calls to provide LightStep tracing
    #
    class ClientInterceptor < Gruf::Interceptors::ClientInterceptor
      def call(request_context:)
        span = active_span
        if span
          span_data = span.to_h
          logger.debug "[gruf-lightstep] Injecting current active span #{span_data[:span_guid]} into outbound request context for #{request_context.method_name}"
          request_context.metadata['ot-tracer-spanid'] = span_data[:span_guid].to_s
          request_context.metadata['ot-tracer-traceid'] = span_data[:trace_guid].to_s
          request_context.metadata['ot-tracer-sampled'] = '1'
        end

        yield
      end

      private

      ##
      # @return [::LightStep::Span|NilClass]
      #
      def active_span
        tracer = ::Bigcommerce::Lightstep::Tracer.instance
        return unless tracer

        span = tracer.active_span
        return unless span && span.is_a?(::LightStep::Span)

        span
      end
    end
  end
end
