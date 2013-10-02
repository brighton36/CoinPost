class Category < ActiveRecord::Base
  has_and_belongs_to_many :items

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :parent_id

  attr_accessible :title, :parent_id, :parent

  scope :top_level, lambda { where(:parent_id => nil).order('lft ASC') }

  acts_as_nested_set

  include FriendlyId
  friendly_id :title_path, :use => [:slugged]

  def title_path
    (parent) ? [parent.title_path, title].join('/') : title
  end

  # This allows us to use /'s
  def normalize_friendly_id(string)
    [ [/[\. ]/, '-'],[/[-]{2,}/,'-'],[/[\-]+$/,''] ].inject(
      string.downcase.tr('^a-z0-9 \/\.\-','')
    ) { |ret,args| ret.gsub(*args) }
  end

  def purchaseable_items_including_descendants
    Item.purchaseable_in_categories([id]+descendant_ids)
  end

  def purchaseable_item_count
    purchaseable_items_including_descendants.count 
  end

  def descendant_ids
    descendants.collect(&:id)
  end

  def self.with_purchaseable_item_counts(parent = nil)
    categories = (parent) ? tree(parent.descendants.all) : tree

    counts = Hash[
      Item.purchaseable_in_categories(categories.collect{|c| c[1]}).
      select('categories_items.category_id, COUNT(items.id) AS item_count').
      group('categories_items.category_id').collect{|c| 
        [c.category_id.to_i, c.item_count.to_i] 
      } ]

    ret = []
    until categories.empty?
      level, category = categories.shift
      count = counts[category.id] || 0

      if 0 == level
        ret << [category,count]
      else
        ret.last[1] += count
      end
    end

    ret
  end

  # This was based off of awesome_nested_set-2.1.3/lib/awesome_nested_set/helper.rb
  # I needed to speed it up a bit, so I improved it here. Note that we only support
  # one level of recursion in this implementation. But adding support for more is
  # trivial.
  def self.tree_as_options
    tree.collect do |node|
      level, category = node

      [ ['- ' * level, category.title].join,category.id]
    end
  end

  # This isn't entirely meant to be called with parameters, the parameters are only
  # there so we can support recursivity. Also, this probably works for any depth,
  # but I've only tested it for one level of recursion. So YMMV.
  def self.tree(categories = order(quoted_left_column_name).all, level = 0, prior_parent_id = nil)
    ret = []
    branch_parent_id = categories.try(:first).try(:parent_id)

    until categories.empty?
      cur_parent_id = categories.first.parent_id

      if cur_parent_id == branch_parent_id
        # Add to our return and remove from the stack:
        ret << [level, categories.shift]
      elsif level > 0 && (prior_parent_id == cur_parent_id)
        # Back to prior recursion:
        return ret
      else
        # Append new level of recursion to return:
        ret += tree categories, level+1, branch_parent_id
      end 
    end

    ret
  end

end
