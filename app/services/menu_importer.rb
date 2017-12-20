class MenuImporter
  include ActiveModel::Validations
  require 'roo'
  validates :file, presence: true
  REQUIRED_KEYS = %i[
    name
    price
    unit
    category
    quantity
  ].freeze

  UPDATABLE_KEYS = %i[
    description
    price
    unit_id
    unit_size
    item_number
    tax
    menu_category_id
    diet_category_id
  ].freeze

  def initialize(file)
    @file = file
    @diet_category = diet_category_hash
    valid?
  end

  def run
    menus = []
    image_urls = []
    quantities = []
    ActiveRecord::Base.transaction do
      (2..spreadsheet.last_row).each do |i|
        row = to_hash(i)
        validate_keys(row, i)
        image_urls << row[:image]
        quantities << row[:quantity]
        menus << create_menu_entry(row, i)
      end
      menus.first.save!
      persisted_menus = Menu.import menus, on_duplicate_key_update: {
        conflict_target: [:name], columns: UPDATABLE_KEYS
      }
      upload_images(persisted_menus.ids, image_urls)
      update_inventory(persisted_menus.ids, quantities)
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

  attr_accessor :file, :diet_category

  def diet_category_hash
    DietCategory.pluck(:name, :id).to_h
  end

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

  def create_menu_entry(row, _i)
    Menu.new(
      name: row[:name],
      unit_id: unit(row[:unit]).id,
      price: row[:price],
      menu_category_id: category(row[:category]).id,
      diet_category_id: diet_category[row[:diet_category]],
      published: true,
      published_at: Time.current,
      tax: row[:tax],
      item_number: row[:item_number],
      unit_size: row[:unit_size],
      description: row[:description]
    )
  end

  def category(name)
    MenuCategory.name_exists?(name.strip.downcase)
                .first_or_create!(name: name.strip)
  end

  def unit(name)
    Unit.name_exists?(name.strip.downcase)
        .first_or_create!(name: name.strip)
  end

  def spreadsheet
    Roo::Spreadsheet.open file
  end

  def header
    spreadsheet.row(1).map(&:downcase)
  end

  def update_inventory(menu_ids, quantities)
    InventoryQtyWorker.perform_async(menu_ids, quantities)
  end

  def upload_images(menu_ids, image_urls)
    FileWorker.perform_async(menu_ids, image_urls)
  end

  def menu_import(menus)
    Menu.import menus, on_duplicate_key_update: {
      conflict_target: [:name], columns: UPDATABLE_KEYS
    }
  end
end
