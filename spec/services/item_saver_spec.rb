RSpec.describe ItemSaver do
  let(:menu_params) { build(:menu).attributes }
  subject(:item) do
    ItemSaver.new(menu_params)
  end

  context '.save!' do
    it 'publish the menu' do
      item.save!
      expected_menu = Menu.last
      expect(item.published?).to be_truthy
    end

    it 'shows errors if params are empty/falsy' do
      menu_params = build(:menu, name: nil).attributes
      item = ItemSaver.new(menu_params)
      item.save!
      expect(item.errors.full_messages).to include("Name can't be blank")
    end
  end

  context '.save(params)' do
    it 'saves as draft' do
      item.save('Save as Draft')
      expect(item.published?).to be_falsy
    end

    it 'publish the menu' do
      item.save('Publish')
      expect(item.published?).to be_truthy
    end

    it 'shows errors if params are empty/falsy' do
      menu_params = build(:menu, name: nil).attributes
      item = ItemSaver.new(menu_params)
      item.save('Publish')
      expect(item.errors.full_messages).to include("Name can't be blank")
    end
  end

  context '.update' do
    it 'with 2 argument' do
      item = ItemSaver.new(menu_params)
      expect(item).to respond_to(:update).with(2).arguments
    end

    it 'without arguments' do
      menu = create(:menu)
      item = ItemSaver.new(menu.attributes)
      item.update(menu.id)
      expect(Menu.last.updated_at).to_not eq(menu.updated_at)
    end

    it 'with Save as Draft argument' do
      menu = create(:menu)
      item = ItemSaver.new(menu.attributes)
      item.update(menu.id, 'Save as Draft')
      expect(item.id).to eq(menu.id)
      expect(item.published?).to be_falsy
    end

    it 'with Publish argument' do
      menu = create(:menu)
      item = ItemSaver.new(menu.attributes)
      item.update(menu.id, 'Publish')
      expect(item.id).to eq(menu.id)
      expect(item.published?).to be_truthy
    end
  end
end
