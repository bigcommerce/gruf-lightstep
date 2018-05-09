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
require 'lightstep'
require_relative 'lightstep/version'
require_relative 'lightstep/configuration'
require_relative 'lightstep/interceptor'
require_relative 'lightstep/headers'
require_relative 'lightstep/method'
require_relative 'lightstep/trace'
require_relative 'lightstep/transport'

##
# Gruf main base module
module Gruf
  ##
  # Lightstep gruf module
  #
  module Lightstep
    extend Configuration

    def self.start
      transport = ::Gruf::Lightstep::Transport.new(
        host: host,
        port: port.to_i,
        verbose: verbosity.to_i,
        encryption: port.to_i == 443 ? ::Gruf::Lightstep::Transport::ENCRYPTION_TLS : ::Gruf::Lightstep::Transport::ENCRYPTION_NONE,
        ssl_verify_peer: ssl_verify_peer,
        access_token: access_token
      )
      ::LightStep.logger = Gruf.logger
      ::LightStep.configure(
        component_name: component_name,
        transport: transport
      )
      ::LightStep.instance.enable
    end
  end
end

module LightStep
  class Tracer
    class << self
      attr_accessor :active_span
    end
  end
end

module LightStep
  ##
  # Monkey patch of the LightStep library to make it not swallow reporting errors
  #
  class Reporter
    def flush
      reset_on_fork

      return if @span_records.empty?

      now = LightStep.micros(Time.now)

      span_records = @span_records.slice!(0, @span_records.length)
      dropped_spans = 0
      @dropped_spans.update do |old|
        dropped_spans = old
        0
      end

      report_request = {
        runtime: @runtime,
        oldest_micros: @report_start_time,
        youngest_micros: now,
        span_records: span_records,
        internal_metrics: {
          counts: [
            { name: 'spans.dropped', int64_value: dropped_spans }
          ]
        }
      }

      @report_start_time = now

      Gruf.logger.debug 'Sending request to lightstep collector'

      begin
        @transport.report(report_request)
      rescue StandardError => e
        Gruf.logger.error "Failed to send request to collector: #{e.message}"
        # an error occurs, add the previous dropped_spans and count of spans
        # that would have been recorded
        @dropped_spans.increment(dropped_spans + span_records.length)
      end
    end
  end
end
