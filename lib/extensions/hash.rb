class Hash
  def key_of_biggest_value
    raise "Hash values include values that aren't a number." unless only_numeric_values?
    key(values.max)
  end

  private

  def only_numeric_values?
    values.each { |v| return false unless v.is_a? Numeric }
    true
  end
end
