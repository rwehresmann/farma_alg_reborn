class Array
  def avg
    reduce(:+).to_f / size
  end

  # Given two arrays, return the common values of both.
  def common_values(array)
    not_common = []
    not_common += self - array
    not_common += array - self
    (self + array - not_common).uniq
  end

  def common_arrays_values
    values = self.shift
    self.each { |array| values = values.common_values(array) }
    values
  end
end
