autoload :Pd_VERSION, "pd/version"

module Kernel
private

	# print for debug
	#
	# @overlaod pd(obj, ...)
  #
  # @example
  #
  #  pd("a", 2, :foo) ->  "a" 2 :foo
  #
	def pd(*args)
		puts args.map{|v|v.inspect}.join(" ")
	end

	# print hr. puts '='*14 + " #{name}"
	#
	# sometime, we just need a horizonal line to separate message for debug.
	# @param [String] name
	def phr(name=nil)
		puts "="*14 + " #{name}"
	end
end

require "pp"
