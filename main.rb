# frozen_string_literal: true

require "jot_pdf/tokyork12"
require "chunky_png"

icon_image = ChunkyPNG::Image.from_file("coord_e_small.png")
hello_pdf_screenshot_image = ChunkyPNG::Image.from_file("hello_pdf_screenshot.png")
page_pdf_screenshot_image = ChunkyPNG::Image.from_file("page_pdf_screenshot.png")
ruby_image = ChunkyPNG::Image.from_file("ruby.png")

minimal_pdf = <<~PDF
  %PDF-1.3
  1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj
  2 0 obj << /Type /Pages /Kids [ 3 0 R ] /Count 1 >> endobj
  3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [ 0 0 720 405 ]
    /Resources 4 0 R /Contents 5 0 R >> endobj
  4 0 obj << /Font << /F1 << /Type /Font /Subtype /Type1
    /BaseFont /Helvetica >> >> >> endobj
  5 0 obj << /Length 46 >>
  stream
  BT /F1 60 Tf 190 180 Td (Hello, World!) Tj ET
  endstream
  endobj
  xref
  0 6
  0000000000 65535 f
  0000000009 00000 n
  0000000058 00000 n
  0000000115 00000 n
  0000000227 00000 n
  0000000319 00000 n
  trailer << /Size 6 /Root 1 0 R >>
  startxref 414
PDF

JotPDF::Tokyork12.write($stdout) do
  load_png "Icon", icon_image
  load_png "HelloPDFScreenshot", hello_pdf_screenshot_image
  load_png "PagePDFScreenshot", page_pdf_screenshot_image
  load_png "Ruby", ruby_image

  title do
    title "Writing PDFs in Ruby DSL"
    author "Hiromi Ogawa (@coord_e)"
  end

  content do
    title "Hiromi Ogawa (coord_e)"
    list do
      item "Software Engineer (Site Reliability) @ Cookpad"
      item "仕事で書くのは .tf, .yaml, .rb, .rs"
      item "Ruby 歴 === 社歴 === 3年~"
      itembreak
      item do
        show "最近の Ruby 暮らし: "
        linebreak factor: 0.9
        color 0x00b894; show "https://hondana.coord-e.dev/"
      end
    end
    raw do
      image "Icon", x: 500, y: 80, width: icon_image.width * 0.3, height: icon_image.height * 0.3
    end
  end

  section_header do
    title "$ cat hello.pdf", font: "OverpassMono-Regular"
  end

  code do
    content minimal_pdf, style: JotPDF::Tokyork12::Highlighter::Plain, size: 17, line_height: 16.5, x: 25, y: 370
  end

  empty do
    raw do
      image "HelloPDFScreenshot",
            x: 160,
            y: 60,
            width: hello_pdf_screenshot_image.width * 0.5,
            height: hello_pdf_screenshot_image.height * 0.5
    end
  end

  content do
    title "オブジェクトの構文"
    list do
      item { show "名前:  "; font "OverpassMono-Regular"; show "/Name" }
      item { show "辞書:  "; font "OverpassMono-Regular"; show "<< /Key /Value >>" }
      item { show "定義:  "; font "OverpassMono-Regular"; show "1 0 obj \#{object}" }
      item { show "参照:  "; font "OverpassMono-Regular"; show "1 0 R" }
    end
  end

  content do
    title "ドキュメントの構造"
    code_block <<~PDF, style: JotPDF::Tokyork12::Highlighter::PDF, size: 16, line_height: 18
      1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj
      2 0 obj << /Type /Pages /Kids [ 3 0 R ] /Count 1 >> endobj
      3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [ 0 0 720 405 ]
        /Resources 4 0 R /Contents 5 0 R >> endobj
      4 0 obj << /Font << /F1 << /Type /Font /Subtype /Type1
        /BaseFont /Helvetica >> >> >> endobj
    PDF
    raw do
      color 0xffffff
      rect x: 64, y: 50, width: 100, height: 60
      fill
      stroke_color 0x000000
      stroke_width 3
      rect x: 64, y: 50, width: 100, height: 60
      stroke
      color 0x000000
      text "Catalog", x: 75, y: 75, size: 20

      path [164, 82], [228, 82]
      stroke
      path [228, 82], [218, 74], [218, 90]
      fill

      color 0xffffff
      rect x: 228, y: 50, width: 100, height: 60
      fill
      stroke_color 0x000000
      stroke_width 3
      rect x: 228, y: 50, width: 100, height: 60
      stroke
      color 0x000000
      text "Pages", x: 250, y: 75, size: 20

      color 0x000000
      path [328, 92], [392, 92]
      stroke
      path [392, 92], [382, 84], [382, 100]
      fill

      color 0x000000
      path [328, 72, 392, 72]
      stroke
      path [328, 72], [338, 64], [338, 80]
      fill

      color 0xffffff
      rect x: 392, y: 50, width: 100, height: 60
      fill
      stroke_color 0x000000
      stroke_width 3
      rect x: 392, y: 50, width: 100, height: 60
      stroke
      color 0x000000
      text "Page", x: 420, y: 75, size: 20

      color 0x000000
      path [492, 82], [556, 82]
      stroke
      path [556, 82], [546, 74], [546, 90]
      fill

      color 0xffffff
      rect x: 556, y: 50, width: 100, height: 60
      fill
      stroke_color 0x000000
      stroke_width 3
      rect x: 556, y: 50, width: 100, height: 60
      stroke
      color 0x000000
      text "コンテンツ\nストリーム", x: 567, y: 82, size: 16
    end
  end

  content do
    title "コンテンツストリーム"
    code_block <<~PDF, style: JotPDF::Tokyork12::Highlighter::PDF, size: 20
      5 0 obj << /Length 196 >>
      stream
      BT                  % Begin text object
      /F1 60 Tf           % Set text font and size
      190 180 Td          % Move text position
      (Hello, World!) Tj  % Show text
      ET                  % End text object
      endstream
      endobj
    PDF
  end

  code do
    content minimal_pdf, style: JotPDF::Tokyork12::Highlighter::PDF, size: 17, line_height: 16.5, x: 25, y: 370
  end

  section_header do
    title "PDF は読める", font: "NotoSansJP-Bold"
  end

  code do
    content minimal_pdf, style: JotPDF::Tokyork12::Highlighter::PDF, size: 17, line_height: 16.5, x: 25, y: 370
    raw do
      stroke_color 0xe06666
      stroke_width 3
      rect x: 20, y: 50, width: 200, height: 120
      stroke
      color 0xe06666
      text "？", x: 250, y: 110, size: 50, font: "NotoSansJP-Bold"
    end
  end

  code do
    content minimal_pdf, size: 17, line_height: 16.5, x: 25, y: 370, style: JotPDF::Tokyork12::Highlighter.adhoc({
      /(1 0 obj|0000000009 00000 n)/ => 0xdef3bc,
      /(2 0 obj|0000000058 00000 n)/ => 0x81ecec,
      /(3 0 obj|0000000115 00000 n)/ => 0x74b9ff,
      /(4 0 obj|0000000227 00000 n)/ => 0xa29bfe,
      /(5 0 obj|0000000319 00000 n)/ => 0xf185c5,
      /(xref|startxref 414)/ => 0xe06666,
    })
    raw do
      color 0xffffff
      text "Cross-Reference Table", x: 270, y: 100, size: 30, font: "NotoSansJP-Bold"
    end
  end

  section_header do
    title "PDF を書くのは難しい", font: "NotoSansJP-Bold"
  end

  section_header do
    title "人間が PDF を書くのは難しい", font: "NotoSansJP-Bold"
  end

  section_header do
    title "が PDF を書くのは？", x_adjust: 40, font: "NotoSansJP-Bold"
    list x: 200, y: 100, size: 15, line_height: 20 do
      itemheader "ゲーム性を出すためのレギュレーション:"
      item "出力した PDF が Adobe Acrobat Reader で開ける"
      item "消費メモリが書くドキュメントの大きさに依存しない\n（ストリーミング）"
    end
    raw do
      image "Ruby", x: 120, y: 180, width: ruby_image.width * 0.07, height: ruby_image.height * 0.07
    end
  end

  code do
    content <<~RUBY, style: JotPDF::Tokyork12::Highlighter::Ruby, line_height: 23
      class OffsetIO
        attr_reader :offset
        def initialize(io)
          @io = io
          @offset = 0
        end
        def <<(b)
          @io << b
          @offset += b.bytesize
        end
      end

      io = OffsetIO.new($stdout)
      io << "obj << /Type /Catalog >> endobj"
    RUBY
  end

  code do
    content <<~RUBY, style: JotPDF::Tokyork12::Highlighter::Ruby
      io << "obj "
      io << "<< "
      io << "/Type "
      io << "/Catalog"
      io << " >>"
      io << " endobj"
    RUBY
  end

  code do
    content <<~'RUBY', style: JotPDF::Tokyork12::Highlighter::Ruby
      def obj
        @io << "obj "
        … # ??
        @io << " endobj"
      end
    RUBY
  end

  code do
    content <<~'RUBY', style: JotPDF::Tokyork12::Highlighter::Ruby
      def obj
        @io << "obj "
        yield
        @io << " endobj"
      end
    RUBY
  end

  code do
    content <<~'RUBY', style: JotPDF::Tokyork12::Highlighter::Ruby
      def dict
        @io << "<< "
        yield
        @io << " >>"
      end

      def entry(key)
        @io << "/#{key} "
        yield
      end

      def name(n)
        @io << "/#{n}"
      end
    RUBY
  end

  code do
    content <<~'RUBY', style: JotPDF::Tokyork12::Highlighter::Ruby
      obj do
        dict do
          entry("Type") { name "Catalog" }
        end
      end
    RUBY
  end

  code do
    content <<~'RUBY', size: 18, style: JotPDF::Tokyork12::Highlighter::Ruby.and(/instance_exec\(&block\)/ => { color: 0xe06666, bold: true })
      class PDFWriter
        def initialize(io)
          @io = OffsetIO.new(io)
        end
        def obj(&block)
          @io << "obj "
          instance_exec(&block)
          @io << " endobj"
        end
      end

      def PDF(io, &block)
        PDFWriter.new(io).instance_exec(&block)
      end
    RUBY
  end

  code do
    content <<~'RUBY', size: 16.5, line_height: 16, style: JotPDF::Tokyork12::Highlighter::Ruby
      class PDFWriter
        def initialize(io)
          @io = OffsetIO.new(io)
          @xref = [ nil ]
        end
        def obj(&block)
          @xref << @io.offset
          @io << "#{@xref.size - 1} 0 obj "
          instance_exec(&block)
          @io << " endobj"
          @xref.size - 1
        end
        def xref
          @io << "xref\n" << "0 #{@xref.size}\n"
          @xref.each do |offset|
            @io << "#{offset.to_s.rjust(10, "0")} 0 n\n"
          end
        end
      end
    RUBY
  end

  code do
    content <<~'PDF', style: JotPDF::Tokyork12::Highlighter::PDF
      5 0 obj << /Length 46 >>
      stream
      BT
      /F1 60 Tf
      190 180 Td
      (Hello, World!) Tj
      ET
      endstream
      endobj
    PDF
    raw do
      stroke_color 0xe06666
      stroke_width 3
      rect x: 180, y: 340, width: 135, height: 35
      stroke
      color 0xe06666
      text "？", x: 250, y: 290, size: 50, font: "NotoSansJP-Bold"
    end
  end

  code do
    content <<~'PDF', style: JotPDF::Tokyork12::Highlighter::PDF.and(/(6 0 R|6 0 obj 46)/ => { color: 0xe06666, bold: true })
      5 0 obj << /Length 6 0 R >>
      stream
      BT
      /F1 60 Tf
      190 180 Td
      (Hello, World!) Tj
      ET
      endstream
      endobj
      6 0 obj 46
    PDF
  end

  code do
    content <<~'RUBY', style: JotPDF::Tokyork12::Highlighter::Ruby.and(/(dict|name|ref)/ => { color: 0xe06666, bold: true })
      obj do
        dict do
          entry("Type") { name "Catalog" }
          entry("Pages") { ref :pages }
        end
      end
    RUBY
  end

  code do
    content <<~'RUBY', style: JotPDF::Tokyork12::Highlighter::Ruby.and(/(of_dict|of_name|of_ref)/ => { color: 0xe06666, bold: true })
      obj.of_dict do
        entry("Type").of_name "Catalog"
        entry("Pages").of_ref :pages
      end
    RUBY
  end

  code do
    content <<~'RUBY', style: JotPDF::Tokyork12::Highlighter::Ruby, size: 12, line_height: 11, x: 25, y: 380
      PDFWrite::Core.write($stdout) do
        header
        alloc_obj => pages_obj; alloc_obj => contents_obj
        obj.of_dict { entry("Type").of_name "Catalog"; entry("Pages").of_ref pages_obj }
          => catalog_obj
        obj.of_dict { entry("Font").of_dict { entry("F1").of_dict {
          entry("Type").of_name "Font"; entry("Subtype").of_name "Type1"
          entry("BaseFont").of_name "Helvetica"
        } } } => resources_obj
        obj.of_dict do
          entry("Type").of_name "Page"; entry("Parent").of_ref pages_obj
          entry("MediaBox").of_array { int 0; int 0; int 612; int 792 }
          entry("Resources").of_ref resources_obj; entry("Contents").of_ref contents_obj
        end => page_obj
        obj(pages_obj).of_dict do
          entry("Type").of_name "Pages"; entry("Kids").of_array { ref page_obj }
          entry("Count").of_int 1
        end

        alloc_obj => length_obj
        stream_size = nil
        obj(contents_obj) do
          dict { entry("Length").of_ref length_obj }
          content_stream do
            op("BT"); op("Tf") { name "F1"; int 24 }
            op("Td") { int 100; int 100 }; op("Tj") { str "Hello, World" }; op("ET")
          end => stream_size
        end
        obj(length_obj).of_int stream_size

        xref
        trailer { entry("Size").of_int objects.size; entry("Root").of_ref catalog_obj }
        startxref
      end
    RUBY
  end

  content do
    title "この API のよいところ"
    list do
      item "疎結合な拡張性"
      item "ゼロフットプリント"
    end
  end

  code do
    content <<~'RUBY', size: 16.5, style: JotPDF::Tokyork12::Highlighter::Ruby
      class PageContext
        def initialize(ctxt) = @ctxt = ctxt
        def text(x:, y:, size:, text:)
          @ctxt.instance_exec do
            op("BT"); op("Tf") { name "F1"; int size }
            op("Td") { int x; int y }
            op("Tj") { str text }; op("ET")
          end
        end
      end

      # use place
      content_stream do
        PageContext.new(self).instance_exec(&block)
      end
    RUBY
  end

  code do
    content <<~'RUBY', style: JotPDF::Tokyork12::Highlighter::Ruby
      PDFWrite::Document.write($stdout) do
        10.times do |i|
          page width: 720, height: 405 do
            text x: 190, y: 180, size: 60, "#{i}th page"
          end
        end
      end
    RUBY
  end

  empty do
    raw do
      image "PagePDFScreenshot",
            x: 160,
            y: 60,
            width: page_pdf_screenshot_image.width * 0.35,
            height: page_pdf_screenshot_image.height * 0.35
    end
  end

  empty do
    raw do
      text x: 100, y: 200, size: 30 do
        color 0x00b894; show "https://tokyork12.coord-e.dev/slide.rb"
      end

      text x: 150, y: 100, size: 17 do
        color 0x000000
        show "今日のライブラリ: "
        color 0x00b894; show "https://github.com/coord-e/pdfwrite"
      end

      text x: 330, y: 50, size: 15 do
        color 0x000000
        show "me@coord-e.com"
        linebreak
        show "@coord_e"
      end

      image "Icon", x: 270, y: 20, width: icon_image.width * 0.1, height: icon_image.height * 0.1
    end
  end
end
