# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'
require 'csv'

RSpec.describe HatenaBlog::EntryGenerator do
  let(:config) { HatenaBlog::Config.new(username: 'test', blog_domain: 'test.com', api_key: 'key', draft_mode: 'yes') }
  let(:generator) { described_class.new(config: config) }

  describe '#load_from_csv' do
    let(:csv_content) do
      CSV.generate(headers: true) do |csv|
        csv << %w[title doc_url]
        csv << ['String#gsub', 'https://docs.ruby-lang.org/ja/3.4/method/String/i/gsub.html']
        csv << ['Array#map', 'https://docs.ruby-lang.org/ja/3.4/method/Array/i/map.html']
      end
    end

    let(:tempfile) do
      file = Tempfile.new(['test', '.csv'])
      file.write(csv_content)
      file.rewind
      file
    end

    after { tempfile.close! }

    it 'loads entries from CSV' do
      entries = generator.load_from_csv(tempfile.path)

      expect(entries).to have_attributes(size: 2)
      expect(entries.first).to have_attributes(
        title: 'String#gsub',
        doc_url: 'https://docs.ruby-lang.org/ja/3.4/method/String/i/gsub.html'
      )
    end

    context 'when file does not exist' do
      it 'raises CSVError' do
        expect { generator.load_from_csv('nonexistent.csv') }
          .to raise_error(HatenaBlog::CSVError, /CSV file not found/)
      end
    end
  end

  describe HatenaBlog::EntryData do
    let(:entry_data) { described_class.new(title: 'String#gsub', doc_url: 'https://example.com') }

    describe '#formatted_title' do
      it 'formats title with prefix' do
        expect(entry_data.formatted_title).to eq('【Ruby】Ruby 再学習 | String#gsub')
      end
    end

    describe '#content' do
      it 'generates blog content' do
        content = entry_data.content

        expect(content).to include('## はじめに')
        expect(content).to include('[https://example.com:title]')
      end
    end
  end
end
