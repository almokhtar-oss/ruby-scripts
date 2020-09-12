#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'github/markdown'

set :port, 3000

get '/' do
  <<~EOT
    <!DOCTYPE html>
    <html>
      <head>
      <title>Page Title</title>
      </head>
        <body>
          <textarea id="markdown" 
          style="width:100%;height:100%">
          </textarea>
            <div id="preview"></div>
              <script src="http://code.jquery.com/jquery-1.12.4.min.js" 
               integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ=" crossorigin="anonymous"></script>
                <script type="text/javascript">
                  $('#markdown').keyup(function(){
                    $.post('/preview', { md: $('#markdown').val()}, function(response){
                      $('#preview').html(response); })});
                </script>
        </body>
    </html>
  EOT
end

post '/preview' do
  GitHub::Markdown.render_gfm params[:md]
end
