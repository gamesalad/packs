require 'sinatra'
require 'sinatra/reloader' if development?
require 'RMagick'
require 'digest/md5'
require 'base64'

include Magick

class PackImg < Sinatra::Base

  enable :logging

  def leech_check
    if !request.referrer.nil? && !request.referrer.empty? && request.referrer !~ /gamesalad\.com|gsrca\.de/
      logger.info "We have a leach: '#{request.referrer}'"
    end
  end

  get '/thumb/:resize/:format/:source' do

    leech_check

    return "" unless params[:source]

    # Encoding the source makes sure this url reads it properly.
    source = Base64.decode64(params[:source]);

    etag Digest::MD5.hexdigest("#{source}:#{params[:resize]}:#{params[:flip]}:#{params[:rotate]}:#{params[:format]}:#{params[:quality]}:#{params[:version]}")
    img = Image.read(source).first

    ops = []
    ops << ->(image) { image }
    ops << ->(image) { image.resize_to_fit(*params[:resize].split('x'))} if params[:resize]
    ops << ->(image) { params[:flip] == 'vertical' ? image.flip : image.flop } if params[:flip]
    ops << ->(image) { image.rotate(params[:rotate].to_i) } if params[:rotate]

    res = ops.inject(img){|o,proc| proc.call(o)}

    res.format = params[:format] if params[:format]
    res.quality = params[:quality].to_i if params[:quality]

    content_type res.mime_type

    res.to_blob
  end

  get '/' do

    leech_check

    return "" unless params[:source]

    etag Digest::MD5.hexdigest("#{params[:source]}:#{params[:resize]}:#{params[:flip]}:#{params[:rotate]}:#{params[:format]}:#{params[:quality]}:#{params[:version]}")
    img = Image.read(params[:source]).first

    ops = []
    ops << ->(image) { image }
    ops << ->(image) { image.resize_to_fit(*params[:resize].split('x'))} if params[:resize]
    ops << ->(image) { params[:flip] == 'vertical' ? image.flip : image.flop } if params[:flip]
    ops << ->(image) { image.rotate(params[:rotate].to_i) } if params[:rotate]

    res = ops.inject(img){|o,proc| proc.call(o)}
    
    res.format = params[:format] if params[:format]
    res.quality = params[:quality].to_i if params[:quality]
    
    content_type res.mime_type

    res.to_blob
  end

  error do
    env['sinatra.error']
  end
end


