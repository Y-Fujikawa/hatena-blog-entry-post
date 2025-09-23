# frozen_string_literal: true

require 'dotenv/load'

module HatenaBlog
  Config = Data.define(:username, :blog_domain, :api_key, :draft_mode) do
    def self.from_env
      config = new(
        username: ENV.fetch('USERNAME', nil),
        blog_domain: ENV.fetch('BLOG_DOMAIN', nil),
        api_key: ENV.fetch('API_KEY', nil),
        draft_mode: ENV.fetch('DRAFT_MODE', 'yes')
      )

      validate_config(config)
      config
    end

    def post_uri
      "https://blog.hatena.ne.jp/#{username}/#{blog_domain}/atom/entry"
    end

    private_class_method def self.validate_config(config)
      case config
      in { username: nil, ** }
        raise ConfigurationError, 'USERNAME is required'
      in { blog_domain: nil, ** }
        raise ConfigurationError, 'BLOG_DOMAIN is required'
      in { api_key: nil, ** }
        raise ConfigurationError, 'API_KEY is required'
      in { username: String, blog_domain: String, api_key: String }
        # valid configuration
      else
        raise ConfigurationError, 'Invalid configuration'
      end
    end
  end
end
