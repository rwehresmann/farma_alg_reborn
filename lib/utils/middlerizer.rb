=begin
  Middlerizer receives an array and a target object (wich must be inside the
  array), and "middlerize" this array according the target object. Optionally,
  a :upper and :lower limit can be specified.

  Consider the following arguments:

  array = [5,4,3,2,1]
  target_object = 3

  Without specify limits:

  Middlerized hash = { middle: 3, lower_half: [5,4], upper_half: [2,1] }

  Specifying limits:

  limits = { upper: 1, lower: 1 }

  Middlerized hash = { middle: 3, lower_half: [4], upper_half: [2] }
=end

class Middlerizer
  attr_reader :middle
  attr_reader :lower_half
  attr_reader :upper_half

  def initialize(middle:, array:, limits: {})
    @array = array
    @limits = limits
    @middle = middle
    @middle_index = set_middle_index
    @lower_half = set_lower_half
    @upper_half = set_upper_half
  end

  def to_hash
    self.class.middlerized_hash(
      upper_half: @upper_half,
      middle: @middle,
      lower_half: @lower_half
    )
  end

  def to_array
    @array
  end

  def size
    @array.size
  end

  def self.middlerized_hash(middle: nil, upper_half: [], lower_half: [])
    { middle: middle, upper_half: upper_half, lower_half: lower_half }
  end

  private

  def set_middle_index
    index = @array.index(@middle)
    raise ArgumentError, "Middle object not found." unless index
    index
  end

  def number_of_objects_to_get(direction)
    direction == :upper ?
      @array.index(@array.last) - @middle_index :
      @middle_index
  end

  def set_lower_half
    direction = :lower
    objects_number = number_of_objects_to_get(direction)
    half = @array.first(objects_number)
    apply_limit(half, direction)
  end

  def set_upper_half
    direction = :upper
    objects_number = number_of_objects_to_get(direction)
    half = @array.last(objects_number)
    apply_limit(half, direction)
  end

  def apply_limit(half, direction)
    get_method = direction == :upper ? :first : :last
    return half.send(get_method, @limits[direction]) if @limits[direction]
    half
  end
end
