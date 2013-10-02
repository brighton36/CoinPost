class CategoriesCell < Cell::Rails
  cache :show, :expires_in => 5.minutes do |cell, options|
    options.try(:[],:category).try(:id)
  end

  def show(opts = {})
    @category = opts[:category]
    @categories = Category.with_purchaseable_item_counts @category

    render
  end
end
