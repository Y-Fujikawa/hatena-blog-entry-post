# frozen_string_literal: true

require_relative 'lib/hatena_blog'

begin
  generator = HatenaBlog::EntryGenerator.new
  client = HatenaBlog::Client.new

  entries = generator.generate_entries('sample.csv')
  results = client.create_entries(entries)

  success_count = results.count { |r| r[:success] }
  total_count = results.size

  puts "Completed: #{success_count}/#{total_count} entries successfully created"

  results.each_with_index do |result, index|
    if result[:success]
      puts "✓ Entry #{index + 1}: #{result[:url]}"
    else
      puts "✗ Entry #{index + 1}: #{result[:error]}"
    end
  end
rescue HatenaBlog::Error => e
  puts "Error: #{e.message}"
  exit 1
rescue StandardError => e
  puts "Unexpected error: #{e.message}"
  exit 1
end
