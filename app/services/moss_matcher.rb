class MossMatcher
  def initialize(language: "pascal", source_codes:)
    @moss = Moss.new(000000000)
    @moss.options[:language] = language
    source_codes.each { |sc| @moss.add_content(sc) }
  end

  # Currently returning the similarity between the two first source codes provided.
  def call
    raise ArgumentError,
      "You need to provide two source codes to be compared." if source_codes_provided?
    url = @moss.check
    results = @moss.extract_results(url)

    return 0 if results.empty?
    results.first.first[:pct]
  end

  private

  def source_codes_provided?
    @moss.to_check[:contents].empty?
  end
end
