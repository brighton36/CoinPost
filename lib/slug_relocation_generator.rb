class SlugRelocationGenerator < FriendlyId::SlugGenerator
  # This is where we differ from the default FriendlyId. Largely what we do here
  # is determine if there's an eligible record whose slug can be 'relocated', in
  # order to assign this record the requested slug.
  def generate
    if conflicting_and_relocateable_slug? 
      friendly_id_config.model_class.base_class.update_all( 
        ['slug = ?', self.next], ['id = ?', conflicts.last.id ] )
    elsif conflict?  
      return self.next
    end

    normalized
  end

  private 

  def conflicting_and_relocateable_slug?
    last_conflict = conflicts.last if conflict?
    last_conflict && last_conflict.slug == normalized && 
      ( last_conflict.respond_to?(:is_slug_relocateable?) ? 
        last_conflict.is_slug_relocateable? : true)
  end

end
