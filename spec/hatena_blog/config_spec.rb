# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HatenaBlog::Config do
  describe '.from_env' do
    let(:valid_env) do
      {
        'USERNAME' => 'test_user',
        'BLOG_DOMAIN' => 'test.example.com',
        'API_KEY' => 'test_api_key'
      }
    end

    before do
      valid_env.each { |key, value| ENV[key] = value }
    end

    after do
      valid_env.keys.each { |key| ENV.delete(key) }
      ENV.delete('DRAFT_MODE')
    end

    context 'with valid environment variables' do
      it 'creates a config instance' do
        config = described_class.from_env

        expect(config.username).to eq('test_user')
        expect(config.blog_domain).to eq('test.example.com')
        expect(config.api_key).to eq('test_api_key')
        expect(config.draft_mode).to eq('yes')
      end

      it 'generates correct post_uri' do
        config = described_class.from_env
        expected_uri = 'https://blog.hatena.ne.jp/test_user/test.example.com/atom/entry'

        expect(config.post_uri).to eq(expected_uri)
      end
    end

    context 'when USERNAME is missing' do
      before { ENV.delete('USERNAME') }

      it 'raises ConfigurationError' do
        expect { described_class.from_env }
          .to raise_error(HatenaBlog::ConfigurationError, 'USERNAME is required')
      end
    end

    context 'when BLOG_DOMAIN is missing' do
      before { ENV.delete('BLOG_DOMAIN') }

      it 'raises ConfigurationError' do
        expect { described_class.from_env }
          .to raise_error(HatenaBlog::ConfigurationError, 'BLOG_DOMAIN is required')
      end
    end

    context 'when API_KEY is missing' do
      before { ENV.delete('API_KEY') }

      it 'raises ConfigurationError' do
        expect { described_class.from_env }
          .to raise_error(HatenaBlog::ConfigurationError, 'API_KEY is required')
      end
    end

    context 'with custom DRAFT_MODE' do
      before { ENV['DRAFT_MODE'] = 'no' }

      it 'uses the specified draft mode' do
        config = described_class.from_env

        expect(config.draft_mode).to eq('no')
      end
    end
  end
end