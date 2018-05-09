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
    # Intercepts calls to provide Lightstep tracing
    #
    class Interceptor < Gruf::Interceptors::ServerInterceptor
      ##
      # Handle the gruf around hook and trace sampled requests
      #
      def call(&_block)
        span = LightStep.start_span(request.method_name)
        Gruf.logger.debug "[gruf-lightstep] Tracing #{request.method_key}"
        result = yield
        span.finish
        # LightStep.instance.flush
        Gruf.logger.debug '[gruf-lightstep] Span finished.'
        Gruf.logger.debug span.to_h.inspect
        result
      end
    end
  end
end
