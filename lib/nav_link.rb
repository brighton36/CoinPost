class NavLink
  attr_accessor :label, :url

  def initialize(label, url, classes = nil)
    @label, @url, @classes, @active = label, url, [classes].flatten.compact, false
  end

  def active=(value)
    @active = value
  end
  
  def is_active?
    @active
  end

  def classes
    (@classes.length > 0) ? @classes : nil
  end

  def i18_label
    I18n.t 'layout.header.%s' % label.to_s
  end
end
