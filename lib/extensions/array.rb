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
end
