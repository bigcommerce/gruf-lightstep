require 'net/http'
require 'lightstep/transport/base'

module Gruf
  module Lightstep
    # This is a transport that sends reports via HTTP in JSON format.
    # It is thread-safe, however it is *not* fork-safe. When forking, all items
    # in the queue will be copied and sent in duplicate.
    class Transport < ::LightStep::Transport::Base
      LIGHTSTEP_HOST = 'collector.lightstep.com'.freeze
      LIGHTSTEP_PORT = 443

      ENCRYPTION_TLS = 'tls'.freeze
      ENCRYPTION_NONE = 'none'.freeze

      # Initialize the transport
      # @param host [String] host of the domain to the endpoind to push data
      # @param port [Numeric] port on which to connect
      # @param verbose [Numeric] verbosity level. Right now 0-3 are supported
      # @param encryption [ENCRYPTION_TLS, ENCRYPTION_NONE] kind of encryption to use
      # @param ssl_verify_peer [Boolean]
      # @param access_token [String] access token for LightStep server
      # @return [Transport]
      def initialize(
        access_token:,
        host: LIGHTSTEP_HOST,
        port: LIGHTSTEP_PORT,
        verbose: 0,
        encryption: ENCRYPTION_TLS,
        ssl_verify_peer: true
      )
        @host = host
        @port = port
        @verbose = verbose
        @encryption = encryption
        @ssl_verify_peer = ssl_verify_peer

        raise ::LightStep::Tracer::ConfigurationError, 'access_token must be a string' unless access_token.is_a?(String)
        raise ::LightStep::Tracer::ConfigurationError, 'access_token cannot be blank'  if access_token.empty?
        @access_token = access_token
      end

      # Queue a report for sending
      def report(report)
        Gruf.logger.info report if @verbose >= 3

        https = ::Net::HTTP.new(@host, @port)
        https.use_ssl = @encryption == ENCRYPTION_TLS
        https.verify_mode = ::OpenSSL::SSL::VERIFY_NONE unless @ssl_verify_peer
        req = Net::HTTP::Post.new('/api/v0/reports')
        req['LightStep-Access-Token'] = @access_token
        req['Content-Type'] = 'application/json'
        req['Connection'] = 'keep-alive'
        req.body = report.to_json
        res = https.request(req)

        Gruf.logger.info res.to_s if @verbose >= 3

        nil
      end
    end
  end
end
