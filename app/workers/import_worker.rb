require 'tempfile'
require 'open-uri'
class ImportWorker
  include Sidekiq::Worker

  def perform(doc_id)
    @doc = Document.find(doc_id)
    file = write_to_tmp_file
    MenuImporter.new(file.path).run
    @doc.destroy
  end

  private

  def write_to_tmp_file
    tmp_file = Tempfile.new(['chunky_import', ".#{@doc.file.format}"])
    tmp_file.binmode
    open(@doc.file.url) do |f|
      tmp_file.write f.read
    end
    tmp_file.rewind
    tmp_file
  end
end
