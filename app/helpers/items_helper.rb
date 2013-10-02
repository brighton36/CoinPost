module ItemsHelper
  def active_header; (action_name == 'show') ? :buy : :sell; end

  def render_title
    (action_name != 'show')
  end

  def title_params
    {:title => @item.title } if @item && action_name == 'show'
  end

  def block_params_right
    [ 
      [:cell, :item, :show, :item => @item, :current_user => current_user] 
    ] if action_name == 'show'
  end

  def block_params_left
    left_partial_on = %w(new create preview add_images edit_images update_images
      edit update relist).join('|')
    [ 
      [:cell, :dashboard, :show, :user => current_user] 
    ] if /\A(?:#{left_partial_on})\Z/.match action_name 
  end

  def resource_assets
    resources = []

    resources << tinymce_assets if %w(
      new create edit update add_images preview relist
    ).include? action_name

    # This is for the ask a question modal
    resources << tinymce_assets if current_user && action_name == 'show'

    # jquery fileupload:
    resources += [
      stylesheet_link_tag('/stylesheets/jquery.fileupload-ui'),
      %w(
        jquery.ui.widget tmpl.min canvas-to-blob.min jquery.iframe-transport 
        jquery.fileupload jquery.fileupload-fp jquery.fileupload-ui 
      ).collect{|j| javascript_include_tag( '/javascripts/%s' % j, :defer => (!Rails.env.test?) ) },
      '<!--[if gte IE 8]>%s<![endif]-->' % 
        javascript_include_tag("/javascripts/jquery.xdr-transport", :defer => (!Rails.env.test?) )
    ] if /\A(?:new|preview|add_images|edit_images|create)\Z/.match action_name
 
    # Bootstrap Image Gallery prereqs: 
    resources += [
      stylesheet_link_tag('/stylesheets/bootstrap-image-gallery.min'),
      javascript_include_tag('/javascripts/load-image.min', :defer => (!Rails.env.test?) ),
      javascript_include_tag('/javascripts/bootstrap-image-gallery.min', :defer => (!Rails.env.test?) )
    ] if /\A(?:new|preview|add_images|edit_images|create|show)\Z/.match action_name

    resources
  end

  def user_tz_select
    select_tag :user_tz, 
      options_for_select(
        TZInfo::Timezone.all.collect{ |tz| [ 
          '%s (%s)' % [
            tz.identifier.tr('_',' '), 
            tz.current_period.abbreviation.to_s
          ], 
          tz.identifier 
        ] },
        Time.zone.tzinfo.identifier
    ), :include_blank => false, :class => 'span4'
  end

  def serialize_to_hidden(record_name, klass = nil)
    klass ||= Kernel.const_get record_name.to_s.classify 
    record = instance_variable_get('@%s' % record_name)
    raw klass.attr_accessible[:default].reject(&:empty?).collect{ |parm|
      if record.respond_to? parm
        value = record.send(parm)
        if value.kind_of? Array
          value.collect{|v| hidden_field_tag( '%s[%s][]' % [record_name,parm], v )}
        else
          hidden_field record_name, parm
        end
      end
    }.compact.join
  end

  # This is a bit of a hack, since haml loves it's whitespace, and the input append
  # feature of twitter bootstrap requires we don't use spaces.
  def append_input(left = nil, right = nil)
    surround(
      (left) ? raw('<span class="add-on">%s</span>' % left) : nil,
      (right) ? raw('<span class="add-on">%s</span>' % right) : nil
    ){ yield }
  end

  # We had to unroll the semantic_form_for's a bit, since they were running SLOW
  def bootstrap_text_field(obj_name, method, options = Hash.new)
    default_opts = { :maxlength => 255 } 
    begin
      default_opts[:placeholder] = t('formtastic.placeholders.%s.%s' % [obj_name, method])
    rescue I18n::MissingTranslationData
    end
    
    bootstrap_control_group obj_name, method, options.delete(:required), %w(string stringish),
      text_field( obj_name, method, default_opts.merge(options) )
  end

  def bootstrap_text_area_field(obj_name, method, options = Hash.new)
    bootstrap_control_group obj_name, method, options.delete(:required), %w(string stringish),
      text_area( obj_name, method, {:rows => 20}.merge(options) )
  end

  def bootstrap_number_field(obj_name, method, options = Hash.new)
    default_opts = { :min => 1, :type => 'number', :step => 'any' } 
    
    bootstrap_control_group obj_name, method, options.delete(:required), %w(number string stringish),
      text_field( obj_name, method, default_opts.merge(options) )
  end

  def bootstrap_select_field(obj_name, method, choices, options = Hash.new, html_options = Hash.new)
    association = instance_variable_get(("@" + obj_name.to_s).to_sym).class.reflect_on_association(method)
    assigns_multiple = (/\Ahas_many|has_and_belongs_to_many\Z/.match association.macro.to_s)

    assoc_meth = [association.name.to_s.singularize, (assigns_multiple) ? 'ids' : 'id'].join('_')

    bootstrap_control_group obj_name, method, options.delete(:required), %w(select),
      select( obj_name, assoc_meth, choices, options, html_options ), 
      ['items',assoc_meth].join('_')
  end

  def bootstrap_datetime_field(obj_name, method, options = Hash.new)
    record = instance_variable_get(("@" + obj_name.to_s).to_sym)
    value = record.send(method)
    
    bootstrap_control_group obj_name, method, options.delete(:required), 
      %w(datetime string stringish), '<div class="inline-inputs">%s</div>' % [
        text_field_tag( 
          '%s[%s_date]' % [obj_name, method], value.strftime('%m/%d/%Y'), 
          :class => 'input-small date_picker' ),
        text_field_tag( 
          '%s[%s_time]' % [obj_name, method], value.strftime('%I:%M %p'), 
          :class => 'input-small time_picker' ) ].join(' ')
  end

  def bootstrap_fieldgroup(legend, &block)
    raw '<fieldset class="inputs"><legend>%s</legend>%s</fieldset>' % [
      t('formtastic.titles.%s' % legend.to_s), capture(&block) ]
  end

  def bootstrap_control_group( obj_name, method, is_required, classes, control, attr_id = nil )
    attr_id ||= [obj_name, method].collect(&:to_s).join('_')
    attr_lbl = t('formtastic.labels.%s.%s' % [obj_name,method] )
    record = instance_variable_get(("@" + obj_name.to_s).to_sym)
    errors = (record.errors.include? method) ? record.errors[method] : nil
   
    classes += %w(clearfix control-group) 
    classes << (is_required) ? 'required' : 'optional' 
    classes << 'error' if errors

    raw(
      '<div class="%s" id="%s_input">
        <label for="%s">%s%s</label>
        <div class="input">%s%s</div>
      </div>' % [
      classes.join(' '), attr_id, attr_id, attr_lbl, 
      (is_required) ? '<abbr title="required">*</abbr>' : '', 
      control,
      (errors) ? 
        ('<span class="help-inline">%s</span>' % errors.join(' and ')) : ''
    ] )
  end
end
