class ItemSaver
  def initialize(params)
    @menu = Menu.new(params)
    @menu_params = params
  end

  def save!
    set_published
    @menu.save
  end

  def save(commit_params)
    set_published(commit_params)
    @menu.save
  end

  def update(id, commit_params = nil)
    set_published(commit_params)
    menu = Menu.find(id)
    menu.update(new_menu_params)
    @menu = menu
  end

  def published?
    @menu.published?
  end

  def errors
    @menu.errors
  end

  def method_missing(name, *args, &block)
    if @menu.respond_to?(name)
      @menu.send(name, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(name, *args, &block)
    @menu.respond_to?(:name) || super
  end

  private

    attr_reader :menu, :menu_params

    def new_menu_params
      menu_params.merge!(published: menu.published)
      menu_params.merge!(published_at: menu.published_at)
      menu_params
    end

    def set_published(commit_params = nil)
      if commit_params == 'Save as Draft'
        menu.published = false
        menu.published_at = nil
      else
        menu.published = true
        menu.published_at = Time.now.utc
      end
    end
end