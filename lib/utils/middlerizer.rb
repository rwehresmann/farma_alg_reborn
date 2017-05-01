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
  def initialize(target_object:, array:, limits: {})
    @array = array
    @limits = limits
    @target_object = target_object
    @target_object_index = set_middle_object_index
    @lower_half = lower_half
    @upper_half = upper_half
  end

  def middlerized
    {
      middle: @target_object,
      upper_half: @upper_half,
      lower_half: @lower_half
    }
  end

  private

  def set_middle_object_index
    index = @array.index(@target_object)
    raise "Targert object not found." unless index
    index
  end

  def number_of_objects_to_get(direction)
    direction == :upper ?
      @array.index(@array.last) - @target_object_index :
      @target_object_index
  end

  def lower_half
    direction = :lower
    objects_number = number_of_objects_to_get(direction)
    half = @array.first(objects_number)
    apply_limit(half, direction)
  end

  def upper_half
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
