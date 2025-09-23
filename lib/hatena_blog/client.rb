# frozen_string_literal: true

require 'atomutil'
require 'logger'
require_relative 'config'
require_relative 'errors'

module HatenaBlog
  class Client
    attr_reader :config, :logger

    def initialize(config: Config.from_env, logger: Logger.new($stdout))
      @config = config
      @logger = logger
      @client = build_client
    end

    def create_entry(entry)
      logger.info "Creating entry: #{entry.title}"

      entry_url = @client.create_entry(config.post_uri, entry)
      logger.info "Successfully created entry: #{entry_url}"

      entry_url
    rescue => e
      logger.error "Failed to create entry: #{e.message}"
      raise PostError, "Failed to create entry: #{e.message}"
    end

    def create_entries(entries)
      results = []

      entries.each.with_index(1) do |entry, index|
        logger.info "Processing entry #{index}/#{entries.size}"

        begin
          url = create_entry(entry)
          results << { success: true, url: url, entry: entry }
        rescue PostError => e
          logger.error "Entry #{index} failed: #{e.message}"
          results << { success: false, error: e.message, entry: entry }
        end
      end

      results
    end

    private

    def build_client
      auth = Atompub::Auth::Wsse.new(
        username: config.username,
        password: config.api_key
      )

      Atompub::Client.new(auth: auth)
    rescue => e
      raise AuthenticationError, "Failed to create client: #{e.message}"
    end
  end
end