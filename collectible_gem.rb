class CollectibleGem
  attr_reader :x, :y

  def initialize(image, x, y)
    @image = image
    @x, @y = x, y
  end
  
  def draw(screen_x, screen_y, z = 0, factor_x = 1, factor_y = 1)
    # Draw, slowly rotating
    @image.draw_rot(@x * factor_x - screen_x, @y * factor_y - screen_y, z,
      25 * Math.sin(milliseconds / 133.7), 0.5, 0.5, factor_x, factor_y)
  end
end
