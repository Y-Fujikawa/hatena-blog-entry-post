# frozen_string_literal: true

require 'atomutil'
require 'csv'
require_relative 'config'
require_relative 'errors'

module HatenaBlog
  EntryData = Data.define(:title, :doc_url) do
    def formatted_title
      "【Ruby】Ruby 再学習 | #{title}"
    end

    def content
      <<~CONTENT
        ## はじめに
        Sampleです。

        ## 詳細
        詳細サンプルです。
        [#{doc_url}:title]
      CONTENT
    end
  end

  class EntryGenerator
    attr_reader :config

    def initialize(config: Config.from_env)
      @config = config
    end

    def load_from_csv(file_path)
      raise CSVError, "CSV file not found: #{file_path}" unless File.exist?(file_path)

      entries = CSV.read(file_path, headers: true)
                   .filter_map { |row| parse_csv_row(row) }
                   .compact

      raise CSVError, 'No valid entries found in CSV file' if entries.empty?

      entries
    rescue CSV::MalformedCSVError => e
      raise CSVError, "Invalid CSV format: #{e.message}"
    end

    def generate_entries(csv_file_path)
      entry_data_list = load_from_csv(csv_file_path)

      entry_data_list.map do |entry_data|
        create_atom_entry(entry_data)
      end
    end

    private

    def parse_csv_row(row)
      case [row['title'], row['doc_url']]
      in [String => title, String => doc_url] if !title.empty? && !doc_url.empty?
        EntryData.new(title: title.strip, doc_url: doc_url.strip)
      else
        nil
      end
    end

    def create_atom_entry(entry_data)
      control = Atom::Control.new
      control.draft = config.draft_mode

      Atom::Entry.new(
        title: entry_data.formatted_title,
        control: control,
        content: entry_data.content
      )
    end
  end
end
