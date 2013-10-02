Formtastic::Helpers::FormHelper.builder = FormtasticBootstrap::FormBuilder

# This monkey patch adds the control-group class to control wrappers, which 
# cause the error messages/fields to be depicted in red
module FormtasticBootstrap::Inputs::Base::Wrapping

  def wrapper_html_options_with_control_group
    opts = wrapper_html_options_without_control_group
    opts[:class] << ' control-group'
    opts
  end                                                                  

  alias_method_chain :wrapper_html_options, :control_group
end
