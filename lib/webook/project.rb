# encoding: utf-8


class String
  def ~
    margin = scan(/^ +/).map(&:size).min
    gsub(/^ {#{margin}}/, '')
  end
end


module Webook
  DEFAULT_PROJECT_FILE = ~<<-EOS unless defined? DEFAULT_PROJECT_FILE 
  {
    "version"    : "0.1",
    "title"      : "Webook sample",
    "summary"    : "Sample book",
    "stylesheet" : "src/stylesheet.css",
    "source"     : [
      "src/pre.md",
      "src/main.md",
      "src/pos.md"
    ],
    "option" : [
      "-g",
      "--page-size A4",
      "--page-offset 0",
      "--margin-left 20mm",
      "--margin-right 20mm",
      "--margin-bottom 25mm",
      "--margin-top 25mm",
      "--outline",
      "--encoding UTF-8"
    ],
    "template" : "template/default.erb",
    "header"   : "template/header.html",
    "footer"   : "template/footer.html",
    "out_dir"  : "output",
    "tmp_dir"  : "tmp"
  }
  EOS

  DEFAULT_PAGE_TEMPLATE = ~<<-EOS unless defined? DEFAULT_PAGE_TEMPLATE
  <!DOCTYPE html>
  <html>
    <head>
      <!-- For web browser -->
      <link rel="stylesheet" type="text/css" href="../src/stylesheet.css">
      <!-- For web browser -->

      <meta charset="UTF-8" />
      <script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
    </head>
    <body class="main">
      <%= content %>
    </body>
  </html>
  EOS

  DEFAULT_PAGE_HEADER = ~<<-EOS unless defined? DEFAULT_PAGE_HEADER
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8" />
      <script>
      function subst() {
        var vars = {};
        var x = document.location.search.substring(1).split('&');
        for (var i in x) {
          var z = x[i].split('=',2);
          vars[z[0]] = decodeURI(z[1]);
        }
        var x = [
          'section','subsection','subsubsection'
        ];
        for (var i in x) {
          var y = document.getElementsByClassName(x[i]);
          for (var j = 0; j < y.length; ++j) {
            y[j].textContent = vars[x[i]];
          }
        }
      }
      </script>
      <style>
        body { width: 100%; padding:0; margin:0; border:0; }
        div { padding-bottom: 5mm; }
        table { border-bottom: 1px dashed black; width: 100% }
        td { padding-bottom: 2mm; }
        td.section-cell {}
        td.subsection-cell { text-align: right; }
      </style>
    </head>
    <body onload="subst()">
      <div>
        <table>
          <tr>
            <td class="section-cell">
              <span class="section"></span>
            </td>
            <td class="subsection-cell">
              <span class="subsection"></span>
            </td>
          </tr>
        </table>
      </div>  
    </body>
  </html>
  EOS

  DEFAULT_PAGE_FOOTER = ~<<-EOS unless defined? DEFAULT_PAGE_FOOTER
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8" />
      <script>
      function subst() {
        var vars = {};
        var x = document.location.search.substring(1).split('&');
        for (var i in x) {
          var z = x[i].split('=',2);
          vars[z[0]] = decodeURI(z[1]);
        }
        var x = [
          'topage',
          'page',
        ];
        for (var i in x) {
          var y = document.getElementsByClassName(x[i]);
          for (var j = 0; j < y.length; ++j) {
            y[j].textContent = vars[x[i]];
          }
        }
      }
      </script>
      <style>
        body { width: 100%; border:0; }
        div { padding-top: 5mm; }
        table { border-top: 1px dashed black; width: 100% }
        td { text-align: right; padding-top: 2mm; }
      </style>
    </head>
    <body onload="subst();">
      <div>
        <table>
          <tr>
            <td> Page <span class="page"></span> of <span class="topage"></span></td>
          </tr>
        </table>
      </div>
    </body>
  </html>
  EOS

  DEFAULT_PROJECT_STYLESHEET = ~<<-EOS unless defined? DEFAULT_PROJECT_STYLESHEET
  * {
    vertical-align: bottom;
    line-height: 200%;
    font-family: 'Lucida Grande', 'Hiragino Kaku Gothic ProN', 'ヒラギノ角ゴ ProN W3', Meiryo, メイリオ, sans-serif;
  }

  body.main   { width: 100%; }
  body.main * { page-break-inside: avoid !important; }

  body.main p.pagebreak {
    page-break-after: always;
  }

  body.main br {
    line-height: 100%;
    page-break-before: always;
  }

  body.main h1 {
    page-break-before: left;
    border-bottom: 0.5mm solid #0000ff;
  }

  body.main h2 {
    border-left : 10pt solid #0000ee;
    padding-left : 10pt;
  }

  body.main img {
    max-width: 100%;
  }

  body.main table {
    width: 100%;
    border-collapse: collapse;
    border: 1px solid #000000;
  }

  body.main table td {
    padding: 2mm;
    border: 1px solid #000000;
    vertical-align: top;
  }

  body.main table th {
    text-align: center;
    padding: 2mm;
    border: 1px solid #000000;
  }

  body.main pre {
    font-size: 10pt;
    background-color: #EFEFEF;
    border: 1px solid #888888;
    -webkit-border-radius: 5mm;
    padding: 5mm;
    overflow-wrap: normal;
  }

  body.main pre > code {
    padding 
    overflow-wrap: normal;
    font-family: 'Courier', sans-serif;
    font-weight: 900;
  }


  body.main p > code {
    font-family: 'Courier', sans-serif;
    font-weight: 900;
    -webkit-border-radius: 2mm;
    border: 1px solid #888888;
    padding: 1mm;
    padding-left: 2mm;
    padding-right: 2mm;
  }
  EOS

  DEFAULT_PROJECT_SOURCE_PRE = ~<<-EOS unless defined? DEFAULT_PROJECT_SOURCE_PRE
  Preface
  ======

  Preface of the book.
  EOS

  DEFAULT_PROJECT_SOURCE_MAIN = ~<<-EOS unless defined? DEFAULT_PROJECT_SOURCE_MAIN
  1st section
  ======

  Content of section.
  EOS

  DEFAULT_PROJECT_SOURCE_POS = ~<<-EOS unless defined? DEFAULT_PROJECT_SOURCE_POS
  Postscript
  ======

  Postscript of the book.
  EOS
end


module Webook
  class Project
    def initialize()
    end

    def generate(name)
      _mkdir(name)
      _touch(name)
    end

    private 
    def _mkdir(root)
      dirs = [
        "#{root}/src",
        "#{root}/template",
        "#{root}/output",
        "#{root}/tmp"
      ]
      dirs.each do |path|
        FileUtils.mkdir_p path
      end
    end

    def _touch(root)
      teplates = [{ 
          'path' => "#{root}/Webookfile",
          'content' => Webook::DEFAULT_PROJECT_FILE 
        },{
          'path' => "#{root}/src/stylesheet.css",
          'content' => Webook::DEFAULT_PROJECT_STYLESHEET 
        },{
          'path' => "#{root}/src/pre.md",
          'content' => Webook::DEFAULT_PROJECT_SOURCE_PRE 
        },{
          'path' => "#{root}/src/main.md",
          'content' => Webook::DEFAULT_PROJECT_SOURCE_MAIN 
        },{
          'path' => "#{root}/src/pos.md",
          'content' => Webook::DEFAULT_PROJECT_SOURCE_POS 
        },{
          'path' => "#{root}/template/default.erb",
          'content' => Webook::DEFAULT_PAGE_TEMPLATE 
        },{
          'path' => "#{root}/template/header.html",
          'content' => Webook::DEFAULT_PAGE_HEADER 
        },{
          'path' => "#{root}/template/footer.html",
          'content' => Webook::DEFAULT_PAGE_FOOTER 
        }
      ]
      teplates.each do |template|
        File.open(template['path'], 'w') do |file|
          file.write template['content']
        end
      end
    end
  end
end
