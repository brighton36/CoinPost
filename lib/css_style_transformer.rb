# This is a css style whitelister. Seems to work well enough, though I did 
# make it very picky.
class CssStyleTransformer
  CSS_STYLE_PARTS = /[ \r\n]*([a-z0-9\-]+)[ \r\n]*\:[ \r\n]*([a-z0-9\#\-]+)[ \r\n]*(?:\;|\z)/mi

  STANDARD_MATCHERS = {
    :single_dim => /\A[0-9]{1,3}px\Z/,
    :color_rgb => /\A\#(?:[a-f0-9]{6}|[a-f0-9]{3})\Z/i,
    :left_center_right => /\A(?:left|center|right)\Z/,
    :left_right => /\A(?:left|right)\Z/
  }

  attr_reader :valid_styles

  def initialize( valid_styles = {} )
    @valid_styles = valid_styles
  end

  def call(env)
    node = env[:node]

    node['style'] = node['style'].scan(CSS_STYLE_PARTS).collect{ |parts|
      '%s:%s' % parts if valid_style?(*parts)
    }.compact.join(';') if node.element? && node['style'] 

    node.remove_attribute 'style' if node['style'].to_s.empty?
  end

  private

  def valid_style?(style, value)
    spec = @valid_styles[style]
    ( ( spec.kind_of?(Symbol) && STANDARD_MATCHERS.has_key?(spec) ) ?
      STANDARD_MATCHERS[spec] : spec
    ).try(:match, value)
  end
end
