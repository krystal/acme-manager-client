module AcmeManager
  module Middleware
    # If your setup is such that you cannot use a load-balancer to automatically syphon off LE requests to
    # /.well-known/acme-challenge and direct them to acme-manager, you can use this middleware instead to act as a
    # proxy between LE and acme-manager
    class ForwardVerificationChallenge
      def initialize(app)
        @app = app
      end

      def call(env)
        if env['PATH_INFO'] =~ /\A\/.well-known\/acme-challenge\//
          result = Net::HTTP.get_response(URI("#{AcmeManager.config.host}#{env['PATH_INFO']}"))
          [result.code.to_i, result.to_hash, [result.body]]
        else
          @app.call(env)
        end
      end
    end
  end
end
