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
    rescue StandardError => e
      logger.error "Failed to create entry: #{e.message}"
      raise PostError, "Failed to create entry: #{e.message}"
    end

    def create_entries(entries)
      entries.each_with_index(1).map { |entry, index| process_entry(entry, index, entries.size) }
    end

    private

    def process_entry(entry, index, total)
      logger.info "Processing entry #{index}/#{total}"

      url = create_entry(entry)
      { success: true, url: url, entry: entry }
    rescue PostError => e
      logger.error "Entry #{index} failed: #{e.message}"
      { success: false, error: e.message, entry: entry }
    end

    def build_client
      auth = Atompub::Auth::Wsse.new(
        username: config.username,
        password: config.api_key
      )

      Atompub::Client.new(auth: auth)
    rescue StandardError => e
      raise AuthenticationError, "Failed to create client: #{e.message}"
    end
  end
end
