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
    # Abstraction accessor class for B3 propagation headers across GRPC ActiveCall objects
    #
    class Headers
      attr_reader :active_call

      ##
      # @property [Hash<Symbol|Array<String>>] Hash mapping of metadata keys
      #
      OT_KEYS = {
        parent_span_id: %w(ot-tracer-parentspanid OT-Tracer-ParentSpanId HTTP_X_OT_TRACER_PARENTSPANID),
        span_id: %w(ot-tracer-spanid OT-Tracer-SpanId HTTP_X_OT_TRACER_SPANID),
        trace_id: %w(ot-tracer-traceid OT-Tracer-TraceId HTTP_X_OT_TRACER_TRACEID),
        sampled: %w(ot-tracer-sampled OT-Tracer-Sampled HTTP_X_OT_TRACER_SAMPLED),
        flags: %w(ot-tracer-flags OT-Tracer-Flags HTTP_X_OT_TRACER_FLAGS)
      }.freeze

      delegate :has_key?, :key?, to: :metadata

      ##
      # @param [GRPC::ActiveCall] active_call
      #
      def initialize(active_call)
        @active_call = active_call
      end

      ##
      # Return a B3 propagation header if present
      #
      # @param [Symbol] key
      # @return [String|NilClass]
      #
      def value(key)
        return nil unless OT_KEYS.key?(key)
        OT_KEYS[key].each do |k|
          return metadata[k] if metadata.key?(k)
        end
        nil
      end

      ##
      # @return [Hash]
      #
      def metadata
        @active_call.metadata
      end

      ##
      # @return [Hash]
      #
      def to_h
        @active_call.metadata
      end
    end
  end
end
