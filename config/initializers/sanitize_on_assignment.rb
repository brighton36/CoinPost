ActiveRecord::Base.class_eval do
  def self.sanitize_on_assignment(attr, opts = Sanitize::Config::RESTRICTED)
    define_method('%s=' % attr) do |html|
      write_attribute attr, Sanitize.clean(html, opts)
    end
  end
end
