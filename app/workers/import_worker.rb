require "tempfile"
require "open-uri"

class ImportWorker
  include Sidekiq::Worker

  def perform(doc_id)
    @doc = Document.find_by_id(doc_id)
    if @doc
      file = write_to_tmp_file
      @menu_importer = MenuImporter.new(file.path)
      if @menu_importer.run
        @doc.destroy
      else
        raise @menu_importer.errors.full_messages.join(", ")
      end
    end
  end

  private

  def write_to_tmp_file
    tmp_file = Tempfile.new(["chunky_import", ".#{@doc.file.format}"])
    tmp_file.binmode
    open(@doc.file.url) do |f|
      tmp_file.write f.read
    end
    tmp_file.rewind
    tmp_file
  end
end
