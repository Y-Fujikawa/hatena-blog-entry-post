# frozen_string_literal: true

module HatenaBlog
  class Error < StandardError; end
  class ConfigurationError < Error; end
  class AuthenticationError < Error; end
  class PostError < Error; end
  class CSVError < Error; end
end
