# Wifi sublet file
# Created with sur-0.1
require "socket"

# Copied from wireless.h
SIOCGIWESSID      = 0x8B1B
IW_ESSID_MAX_SIZE = 32

configure :wifi do |s| # {{{
  s.interval = 30
  s.icon     = Subtlext::Icon.new("wireless1.xbm")
  s.device   = s.config[:device] || "wlan0"
end # }}}

on :run do |s| # {{{
  # Get data
  wireless = IO.readlines("/proc/net/wireless", "r").join

  link, level, noise = wireless.scan(/#{s.device}:\s*\d*\s*([0-9-]+).\s+([0-9-]+).\s+([0-9-]+)/).flatten

  # FIXME: Try to get essid, some broken(?) drivers don't allow
  # ioctl calls of non-priv users.
  begin
    sock = Socket.new(Socket::AF_INET, Socket::SOCK_DGRAM, 0)

    template = "a16pI2"
    iwessid  = [ s.device, " " * IW_ESSID_MAX_SIZE, IW_ESSID_MAX_SIZE, 1 ].pack(template)

    sock.ioctl(SIOCGIWESSID, iwessid)

    interface, essid, len, flags = iwessid.unpack(template)
  rescue
    essid = "unknown"
  end

  if link.to_i > 50
    s.foreground = "#75B4FF"
  

 else
   s.data = "0"
   s.foreground = "#DC143C"
 end 
  s.data = "%s%s %d%" % [ s.icon, essid.strip, link.nil? ? 0 : link ]
end # }}}
