##
# ybbauth.rb <October 1st, 2006>
#
# Ruby wrapper around Yahoo!'s Browser-Based Authentication (BBAuth)
# More information on BBAuth is available here:
#   http://developer.yahoo.com/auth/
#
# (C) 2006 Premshree Pillai
#   <http://premshree.livejournal.com>
#   <premshree at gmail dot com>
#
# Use this library under the BSD license
##

require 'net/https'
require 'md5'
require 'rubygems'
require 'xmlsimple'

class YahooBbAuth
   
   @@login_prefix = 'https://api.login.yahoo.com/WSLogin/V1/'

   @@appid = "這裡寫APPID"
   @@secret = "這裡寫SECRET"

   def initialize(appid=@@appid, secret=@@secret)
      @appid = appid
      @secret = secret
      @cookie = nil
      @wssid = nil
      @token = nil
   end

   def verify_sig(url)
     tmp = url.match(/^(.+)&sig=(\w{32})$/)
     return nil if tmp == nil
     url_without_sig = tmp[1]
     sig = tmp[2]

     parts = _parse_url(url_without_sig)
     rel_uri = "#{parts['path']}?#{parts['query']}"
     verifySig = MD5.md5("#{rel_uri}#{@secret}")
     return verifySig == sig
   end

   def get_auth_url(appdata, hash=false)
      appdata = "&appdata=#{URI.encode(appdata)}"
      hashdata = '&send_userhash=1' if hash
      #return _create_auth_url("#{@@login_prefix}wslogin?appid=#{@appid}#{appdata}#{hashdata}")
      return _create_auth_url("#{@@login_prefix}wslogin?.intl=tw&appid=#{@appid}#{appdata}#{hashdata}")
   end

   def _create_auth_url(url)
      parts = _parse_url(url)      
      ts = Time.now.to_i
      rel_uri = "#{parts['path']}?#{parts['query']}&ts=#{ts}"
      sig = MD5.md5("#{rel_uri}#{@secret}")
      signed_url = "#{parts['scheme']}://#{parts['host']}#{rel_uri}&sig=#{sig}"
      return signed_url
   end

   def _parse_url(url)
      arr = URI.split(url)
      parts = {
         'path' => arr[5],
         'query' => arr[7],
         'scheme' => arr[0],
         'host' => arr[2]
      }
      return parts
   end

   def get_access_url(token)
      return _create_auth_url("#{@@login_prefix}wspwtoken_login?token=#{token}&appid=#{@appid}")
   end

   def get_access_credentials(token)
      url = get_access_url(token)
      url_parts = _parse_url(url)
      http = Net::HTTP.new(url_parts['host'], 443)
      http.use_ssl = true
      http.start do |http|
         req = Net::HTTP::Get.new("#{url_parts['path']}?#{url_parts['query']}")
         resp, xml_data = http.request(req)
         data = XmlSimple.xml_in(xml_data)
         cookie = data['Success'][0]['Cookie'][0].gsub(/\s/, '')
     wssid = data['Success'][0]['WSSID'][0]
         @cookie, @wssid = cookie, wssid
         return {
            'Cookie' => cookie,
            'WSSID' => wssid
         }
      end
   end

   def ws_auth_get_request(url)
      url = _authify_ws_url(url)
      url_parts = _parse_url(url)
      h = Net::HTTP.new(url_parts['host'], 80)
      resp, data = h.get("#{url_parts['path']}?#{url_parts['query']}", {'Cookie' => @cookie})
      p data
   end

   def ws_auth_post_request(url)
      url = _authify_ws_url(url)
      url_parts = _parse_url(url)
      h = Net::HTTP.new(url_parts['host'], 80)
      resp, data = h.post(url_parts['path'], url_parts['query'], {'Cookie' => @cookie})
      p data
   end



   def _authify_ws_url(url)
      url = url+"?" if !(url =~ /\?/)
      return "#{url}&WSSID=#{@wssid}&appid=#{@appid}"      
   end

end

