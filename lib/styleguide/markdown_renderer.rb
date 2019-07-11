module Styleguide
  class MarkdownRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def block_code(code, language)
      case language
      when "example"
        options, code = parse_code(code)
        example(code, options)
      when "color"
        options, code = parse_options(code)
        color(code, options)
      when "color-palette"
        options, code = parse_options(code)
        color_pallete(code, options)
      else
        super
      end
    end

    def example(code, options)
      block_code = block_code(code.strip, 'erb')
      ApplicationController.render 'code_blocks/example', assigns: { code: render_code(code), options: options, block_code:  block_code}, layout: false
    end

    def color(code, options)
      block_code = block_code(options[:name], 'erb')

      ApplicationController.render 'code_blocks/color', assigns: { code: code, options: options, block_code:  block_code}, layout: false
    end

    def color_pallete(code, options)
      ApplicationController.render 'code_blocks/color_palette', assigns: { options: options }, layout: false
    end

    private

    def render_code(code)
      ApplicationController.renderer.render inline: code, layout: false
    end

    def parse_code(code)
      pieces = code.split("---")

      if pieces.length > 1
        options = YAML::load(pieces[0])
        options.deep_symbolize_keys!

        [options, pieces[1]]
      else
        [{}, pieces[0]]
      end
    end

    def parse_options(code)
      pieces = code.split("---")

      options = YAML::load(pieces[0])

      if options.present?
        options.deep_symbolize_keys!
      else
        options = {}
      end

      if pieces.length > 1
        [options, pieces[1]]
      else
        [options, ""]
      end
    end
  end
end
