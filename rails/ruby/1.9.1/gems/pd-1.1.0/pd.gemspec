Kernel.load File.expand_path("../lib/pd/version.rb", __FILE__)

Gem::Specification.new do |s|
	s.name = "pd"
	s.version = Pd_VERSION
	s.summary = "some helper methods to help debuging"
	s.description = <<-EOF
a print helper method for debug to Kernel
	EOF

	s.author = "Guten"
	s.email = "ywzhaifei@gmail.com"
	s.homepage = "http://github.com/GutenYe/pd"
	s.rubyforge_project = "xx"

	s.files = `git ls-files`.split("\n")
end
