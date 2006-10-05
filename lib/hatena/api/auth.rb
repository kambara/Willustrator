require 'open-uri'
require 'uri'

begin
  require 'md5'
rescue LoadError
end

begin
  require 'json'
rescue LoadError
  require 'rubygems'
  require 'json'
end

module Hatena
  module API
    class AuthError < RuntimeError;end
    class Auth
      BASE_URI = 'http://auth.hatena.ne.jp/'
      PATH = {
        :auth => '/auth',
        :json => '/api/auth.json'
      }.freeze
      VERSION = '0.1.0'

      attr_accessor :api_key, :secret
      def initialize(options = {})
        @api_key = options[:api_key]
        @secret  = options[:secret]
      end

      def uri_to_login
        uri = URI.parse BASE_URI
        uri.path = PATH[:auth]
        uri.query = query_with_api_sig
        uri
      end

      def login(cert)
        result = JSON.parse open(
                   uri_to_authcheck(cert),
                   'User-Agent' => "#{self.class}/#{VERSION} - Ruby"
                 ).read

        if result['has_error']
          raise AuthError.new(result['error']['message'])
        else
          result['user']
        end
      end

      private
      def api_sig(hash)
        Digest::MD5.hexdigest(@secret + hash.to_a.map.sort_by {|i| i.first.to_s}.join)
      end

      def uri_to_authcheck(cert)
        uri = URI.parse BASE_URI
        uri.path = PATH[:json]
        uri.query = query_with_api_sig(:cert => cert)
        uri
      end

      def query_with_api_sig(request = {})
        query = request.update(:api_key => @api_key)
        query[:api_sig] = api_sig(query)
        query.map {|i| i.join '=' }.join('&')
      end
    end
  end
end
