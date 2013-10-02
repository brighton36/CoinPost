module FormtasticBootstrap
  module Inputs
    class DatetimeInput < Formtastic::Inputs::DatetimeInput
      include Base
      include Base::Stringish
      include Base::Timeish

      # This was largely taken from
      # formtastic-bootstrap-1.1.1/lib/formtastic-bootstrap/inputs/base/timeish.rb
      def my_datetime_input_html(fragment,strfformat)
        template.send(
          :text_field_tag,
          '%s[%s_%s]' % [object_name, method, fragment.to_s],
          (value.respond_to? :strftime) ? value.strftime(strfformat) : value,
          input_html_options.merge(
            :id => fragment_id(fragment), 
            :class => ["input-small", "%s_picker" % fragment.to_s].join(' '))
        )
      end

      def to_html
        generic_input_wrapping do
          inline_inputs_div_wrapping do
            # This newline matters.
            my_datetime_input_html( :date,'%m/%d/%Y' ) <<
            "\n".html_safe <<
            my_datetime_input_html( :time,'%I:%M %p' )
          end
        end
      end

    end
  end
end
