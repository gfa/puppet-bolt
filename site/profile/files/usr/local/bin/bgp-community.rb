#!/usr/bin/env ruby

# Generate bird filters to update BGP community values
# see: https://dn42.net/howto/Bird
# original author: Mic92
# TODO
# - other bgp daemons, contribution are welcome

require 'open3'
require 'optparse'

def which(cmd)
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each do |ext|
      exe = File.join(path, "#{cmd}#{ext}")
      if File.executable?(exe) && !File.directory?(exe)
        return exe
      end
    end
  end
  return nil
end

def ping(host, ipv6)
  print "Try to ping #{host}... (timeout 10s)"
  ping = if host =~ /:/ || ipv6
           if which("ping6")
             ["ping6"]
           else
             ["ping", "-6"]
           end
         else
           ["ping"]
         end
  cmd = ping + ["-W10", "-c5", host]
  out, status = Open3.capture2e(*cmd)
  print "\r"
  if status != 0
    abort "ping failed with: #{status}\n#{out}"
  end
  last_line = out.lines.last
  fields = last_line.split(/\//)
  average = fields[5]

  return average.to_i
end

def latency_class(latency)
  case latency
  when 0..2.7
    1
  when 2.7..7.3
    2
  when 7.3..20
    3
  else
    Math.log(latency).round
  end
end

def speed_class(speed)
  case speed.to_f
  when 0 # invalid number
    abort "invalid mbit_speed: #{speed}"
  when 0.1..0.99
    21
  when 1..9.99
    22
  when 10..99.9
    23
  when 100..999.9
    24
  when 1000..9999
    25
  else
    20 + Math.log10((speed.to_f) * 100).round
  end
end

def crypto_class(crypto)
  case crypto
  when "unencrypted"
    31
  when "unsafe"
    32
  when "encrypted"
    33
  when "pfs"
    34
  else
    abort "unknown type #{crypto}"
  end
end

def main(args)

  banner = "USAGE: #{$0} host mbit_speed unencrypted|unsafe|encrypted|pfs"
  options = {}
  OptionParser.new do |opts|
    opts.banner = banner

    opts.on("-6", "--ipv6", "Assume ipv6 for ping") do |v|
      options[:ipv6] = true
    end
  end.parse!

  if args.size < 3
    $stderr.puts(banner)
    exit(1)
  end

  host, mbit_speed, crypto_type = args

  speed_value  = speed_class(mbit_speed)
  crypto_value = crypto_class(crypto_type)
  latency = ping(host, options[:ipv6])
  latency_value = latency_class(latency)
  date = Time.now.strftime("%Y-%m-%d")

  puts "  # #{latency} ms, #{mbit_speed} mbit/s, #{crypto_type} tunnel (updated: #{date})"
  puts "  import where dn42_import_filter(#{latency_value},#{speed_value},#{crypto_value});"
  puts "  export where dn42_export_filter(#{latency_value},#{speed_value},#{crypto_value});"
end

main(ARGV)
