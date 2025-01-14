# frozen_string_literal: true

require "jot_pdf"
require_relative "highlighter"

module JotPDF
  module Tokyork12
    class ContextBase
      def initialize(ctx)
        @ctx = ctx
      end

      def raw(&block)
        @ctx.dsl(&block)
      end

      def dsl(&block)
        Docile.dsl_eval(self, &block)
      end

      # TODO: move these defaults to ContentContext
      def list(x: 66, y: 250, size: 20, line_height: nil, color: 0x000000, &block)
        line_height ||= size + 10
        @ctx.dsl do
          color color
          text x:, y:, size:, line_height: do
            ListContext.new(self).dsl(&block)
          end
        end
      end
    end

    class ListContext < ContextBase
      def itemheader(text = nil, &block)
        raw do
          move x: -16, y: 0
          font "NotoSansJP-Regular"
          show text if text
          dsl(&block) if block
          move x: 16, y: 0
          linebreak
        end
      end

      def item(text = nil, &block)
        y = @ctx.base_y + 5
        raw do
          stroke_color 0xb3bec3
          stroke_width 2
          path [@ctx.base_x - 16, y], [@ctx.base_x - 8, y]
          stroke
          font "NotoSansJP-Regular"
          show text if text
          dsl(&block) if block
          linebreak
        end
      end

      def itembreak
        raw do
          linebreak factor: 0.8
        end
      end
    end

    class CodeContext < ContextBase
      def content(code, style: Highlighter::Plain, size: 20, line_height: nil, x: nil, y: nil)
        line_height ||= size + 5
        x ||= 50
        y ||= 350
        raw do
          color 0xffffff
          text x:, y:, size:, line_height:, font: "OverpassMono-Regular" do
            code.each_line(chomp: true) do |line|
              style.each_token(line) do |type, token|
                if type
                  color type.color
                  font "OverpassMono-Bold" if type.bold
                else
                  color 0xffffff
                  font "OverpassMono-Regular"
                end
                show token
              end
              linebreak
            end
          end
        end
      end
    end

    class TitleContext < ContextBase
      def title(title)
        raw do
          color r: 0.0, g: 0.0, b: 0.0
          text title, x: 60, y: 250, size: 40, font: "NotoSansJP-Bold"
        end
      end

      def author(name)
        raw do
          color r: 0.4, g: 0.4, b: 0.4
          text name, x: 60, y: 200, size: 20
        end
      end
    end

    class SectionHeaderContext < ContextBase
      def title(title, x_adjust: nil, **kwargs)
        # とりあえずの雑センタリング
        x = 360 - title.chars.map { |c| c.ascii_only? ? 1 : 1.6 }.sum * 12
        x += x_adjust if x_adjust
        @ctx.dsl do
          color 0x000000
          text title, x:, y: 200, size: 40, **kwargs
        end
      end
    end

    class ContentContext < ContextBase
      def title(title)
        @ctx.dsl do
          color 0x000000
          text title, x: 50, y: 320, size: 30, font: "NotoSansJP-Bold"
        end
      end

      def code_block(code, style: Highlighter::Plain, size: 15, line_height: nil)
        line_height ||= size
        raw do
          block_height = code.lines.length * line_height + 30
          color 0x2d3436
          rect x: 50, y: 405 - block_height - 120, width: 620, height: block_height
          fill

          text x: 65, y: 405 - 150, size:, line_height:, font: "OverpassMono-Regular" do
            code.each_line(chomp: true) do |line|
              style.each_token(line) do |type, token|
                if type
                  color type.color
                  font "OverpassMono-Bold" if type.bold
                else
                  color 0xffffff
                  font "OverpassMono-Regular"
                end
                show token
              end
              linebreak
            end
          end
        end
      end
    end

    class SlideContext < ContextBase
      def load_png(name, png)
        raw do
          image name, width: png.width, height: png.height do
            alpha do |io|
              io << png.to_alpha_channel_stream
            end
            rgb do |io|
              io << png.to_rgb_stream
            end
          end
        end
      end

      def title(&block)
        light_slide(TitleContext, &block)
      end

      def content(&block)
        light_slide(ContentContext, &block)
      end

      def section_header(&block)
        light_slide(SectionHeaderContext, &block)
      end

      def code(&block)
        dark_slide(CodeContext, &block)
      end

      def empty(&block)
        light_slide(ContextBase, &block)
      end

      private

      def light_slide(klass, &block)
        raw do
          page width: 720, height: 405 do
            color r: 0.945, g: 0.945, b: 0.945
            rect x: 0, y: 0, width: 720, height: 405
            fill

            klass.new(self).dsl(&block)
          end
        end
      end

      def dark_slide(klass, &block)
        raw do
          page width: 720, height: 405 do
            color 0x2d3436
            rect x: 0, y: 0, width: 720, height: 405
            fill

            klass.new(self).dsl(&block)
          end
        end
      end
    end

    def self.write(io, &block)
      JotPDF::Document.write(io) do
        load_font "#{DATADIR}/NotoSansJP-Regular.ttf"
        load_font "#{DATADIR}/NotoSansJP-Bold.ttf"
        load_font "#{DATADIR}/OverpassMono-Regular.ttf"
        load_font "#{DATADIR}/OverpassMono-Bold.ttf"
        default_font "NotoSansJP-Regular"

        SlideContext.new(self).dsl(&block)
      end
    end
  end
end
