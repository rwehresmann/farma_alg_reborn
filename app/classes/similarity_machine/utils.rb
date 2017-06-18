module SimilarityMachine
  module Utils
    def compare_and_shift_each(array, groups)
      array_copy = array.dup
      array.count.times do
        return if array_copy.length <= 1
        object_1 = array_copy.shift
        array_copy.each { |object_2| yield(object_1, object_2) }
      end
    end
  end
end
