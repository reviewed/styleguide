# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end


# coding: UTF-8
$:.unshift(File.expand_path('../../lib', __FILE__))
Encoding.default_internal = 'UTF-8'

require 'redcarpet'
require 'redcarpet/render_strip'
require 'redcarpet/render_man'

class Redcarpet::TestCase < ActiveSupport::TestCase
  def assert_renders(html, markdown)
    assert_equal html, render(markdown)
  end

  def render(markdown, options = {})
    default_options = {
      autolink: true,
      tables: true,
      fenced_code_blocks: true
    }
    options = options.fetch(:with, {})

    if options.kind_of?(Array)
      options = Hash[options.map {|o| [o, true]}]
    end

    render = begin
      renderer.new(options)
    rescue ArgumentError
      renderer.new
    end
    
    parser = Redcarpet::Markdown.new(render, default_options)

    parser.render(markdown).chomp
  end

  private

  def renderer
    @renderer ||= Styleguide::MarkdownRenderer
  end

  # Imported from Active Support
  class ::String
    def strip_heredoc
      indent = scan(/^ *(?=\S)/).min.size || 0
      gsub(/^[ \t]{#{indent}}/, '')
    end
  end
end
