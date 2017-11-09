# HashParser
# Convert hash to an OpenStruct Object
# HashParser.new(hash).run
class HashParser
  def initialize(hash)
    @hash = hash
  end

  def run
    JSON.parse(convert_to_json, object_class: OpenStruct)
  end

  private

    attr_accessor :hash

    def convert_to_json
      hash.to_json
    end
end