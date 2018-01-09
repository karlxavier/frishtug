class MenuImporter
  include ActiveModel::Validations
  require 'roo'
  validates :file, presence: true
  UNIQUE_KEY = :item_number
  REQUIRED_KEYS = %i[
    name
    price
    unit
    category
    quantity
    item_number
    tax
  ].freeze

  UPDATABLE_KEYS = %i[
    name
    description
    price
    unit_id
    unit_size
    tax
    menu_category_id
    diet_category_id
    asset_id
  ].freeze

  def initialize(file)
    @file = file
    @diet_category = DietCategory.pluck(:name, :id).to_h.freeze
    @units_hash = Unit.pluck(:name, :id).to_h.freeze
    @menu_categories_hash = MenuCategory.pluck(:name, :id).to_h.freeze
    @asset_hash = Asset.where.not(file_name: nil).pluck(:file_name, :id).to_h.freeze
    @menus = []
    @quantities = []
    @menu_ids = []
    @add_ons = []
    valid?
  end

  def run
    ActiveRecord::Base.transaction do
      (2..spreadsheet.last_row).each do |i|
        row = to_hash(i)
        validate_keys(row, i)
        @quantities << row[:quantity]
        @add_ons << row[:add_ons]
        @menus << create_menu_entry(row)
      end
      @menu_ids = menu_import.ids
      update_inventory
      update_add_ons
    end
    true
  rescue ActiveRecord::StatementInvalid => e
    errors.add(:base, e.message)
    false
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  def size
    spreadsheet.last_row - 1
  end

  private

  attr_accessor :file,
                :diet_category,
                :units_hash,
                :menu_categories_hash,
                :asset_hash,
                :menus,
                :quantities,
                :menu_ids,
                :add_ons

  def validate_keys(row, i)
    validates_required_keys(row, i)
    validates_price(row[:price], i)
  end

  def validates_price(price, i)
    unless is_numeric?(price)
      errors.add :base, "price not valid in row #{i}"
      raise ActiveRecord::RecordInvalid
    end
  end

  def is_numeric?(number)
    Float number
  rescue ArgumentError
    false
  end

  def to_hash(i)
    Hash[[header, spreadsheet.row(i)].transpose].with_indifferent_access
  end

  def validates_required_keys(row, i)
    invalid_keys = []

    REQUIRED_KEYS.each do |key|
      invalid_keys.push(key) unless row[key.to_sym].present?
    end
    return true if invalid_keys.empty?

    map_errors(invalid_keys, i)
    raise ActiveRecord::RecordInvalid
  end

  def map_errors(keys, i)
    keys.map do |k|
      errors.add(:base, "#{k} is blank at row number #{i}")
    end
  end

  def create_menu_entry(row)
    Menu.new(
      name: row[:name],
      unit_id: unit(row[:unit]),
      price: row[:price],
      menu_category_id: category(row[:category]),
      diet_category_id: diet_category[row[:diet_category]],
      published: true,
      published_at: Time.current,
      tax: row[:tax],
      item_number: row[:item_number],
      unit_size: row[:unit_size],
      description: row[:description],
      asset_id: asset_hash[row[:image]] || row[:asset_id]
    )
  end

  def category(name)
    menu_categories_hash[name].present? ?
      menu_categories_hash[name] : MenuCategory.create(name: name.strip).id
  end

  def unit(name)
    units_hash[name].present? ? units_hash[name] : Unit.create(name: name.strip).id
  end

  def spreadsheet
    Roo::Spreadsheet.open file
  end

  def header
    spreadsheet.row(1).map do |column|
      unless column.blank?
        column.downcase
      end
    end
  end

  def update_inventory
    InventoryQtyWorker.perform_async(menu_ids, quantities)
  end

  def update_add_ons
    AddOnsWorker.perform_async(menu_ids, add_ons)
  end

  def menu_import
    Menu.import menus, on_duplicate_key_update: {
      conflict_target: [UNIQUE_KEY], columns: UPDATABLE_KEYS
    }
  end
end
