#Battery sublet

configure :battery do |s|
  s.interval = 2
  s.foreground = "#ff00cc"
  s.icons = {
     #:full => Subtlext::Icon.new("bat_full.xbm")
     #:low => Subtlext::Icon.new("bat_low.xbm")
     #:empty => Subtlext::Icon.new("bat_empty.xbm") 
     :ac => Subtlext::Icon.new("ac14.xbm") 
  }
end

on :run do |s|
 adapter = File.open("/proc/acpi/ac_adapter/ADP1/state").read.to_s.split(':')[1].strip
 if adapter.eql? "on-line"
   s.data = s.icons[:ac].to_s
  end
#TO DO - BATTERY LEVEL /PROC/ACPI/...
end

