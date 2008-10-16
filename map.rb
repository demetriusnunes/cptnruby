module Tiles
  Grass = 0
  Earth = 1
end

# Map class holds and draws tiles and gems.
class Map
  attr_reader :width, :height, :gems
  
  def initialize(window, filename)
    # Load 60x60 tiles, 5px overlap in all four directions.
    @tileset = Image.load_tiles(window, "media/CptnRuby Tileset.png", 60, 60, true)
    @sky = Image.new(window, "media/Space.png", true)

    gem_img = Image.new(window, "media/CptnRuby Gem.png", false)
    @gems = []

    lines = File.readlines(filename).map { |line| line.chop }
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x, 1]
        when '"'
          Tiles::Grass
        when '#'
          Tiles::Earth
        when 'x'
          @gems.push(CollectibleGem.new(gem_img, x * 50 + 25, y * 50 + 25))
          nil
        else
          nil
        end
      end
    end
  end
  
  def draw(screen_x, screen_y)
    # Sigh, stars!
    @sky.draw(0, 0, 0)

    # Very primitive drawing function:
    # Draws all the tiles, some off-screen, some on-screen.
    @height.times do |y|
      @width.times do |x|
        tile = @tiles[x][y]
        if tile
          # Draw the tile with an offset (tile images have some overlap)
          # Scrolling is implemented here just as in the game objects.
          @tileset[tile].draw(x * 50 - screen_x - 5, y * 50 - screen_y - 5, 0)
        end
      end
    end
    @gems.each { |c| c.draw(screen_x, screen_y) }
  end
  
  def draw_minimap(screen_x, screen_y, factor = 0.1)

    # Very primitive drawing function:
    # Draws all the tiles, some off-screen, some on-screen.
    @height.times do |y|
      @width.times do |x|
        tile = @tiles[x][y]
        if tile
          # Draw the tile with an offset (tile images have some overlap)
          # Scrolling is implemented here just as in the game objects.
          @tileset[tile].draw((x * 50 - 5) * factor - screen_x, (y * 50 - 5) * factor - screen_y, 1000, factor, factor)
        end
      end
    end
    @gems.each { |c| c.draw(screen_x, screen_y, 0, factor, factor) }
  end
  
  # Solid at a given pixel position?
  def solid?(x, y)
    y < 0 || @tiles[x / 50][y / 50]
  end
end