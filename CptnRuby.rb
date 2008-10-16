# Basically, the tutorial game taken to a jump'n'run perspective.

# Shows how to
#  * implement jumping/gravity
#  * implement scrolling
#  * implement a simple tile-based map
#  * load levels from primitive text files

# Some exercises, starting at the real basics:
#  0) understand the existing code!
# As shown in the tutorial:
#  1) change it use Gosu's Z-ordering
#  2) add gamepad support
# X3) add a score as in the tutorial game
#  4) similarly, add sound effects for various events
# Exploring this game's code and Gosu:
# X5) make the player wider, so he doesn't fall off edges as easily
# X6) add background music (check if playing in Window#update to implement 
#     looping)
#  7) implement parallax scrolling for the star background!
# Getting tricky:
#  8) optimize Map#draw so only tiles on screen are drawn (needs modulo, a pen
#     and paper to figure out)
#  9) add loading of next level when all gems are collected
# ...Enemies, a more sophisticated object system, weapons, title and credits
# screens...

begin
  # In case you use Gosu via rubygems.
  require 'rubygems'
rescue LoadError
  # In case you don't.
end

require 'gosu'
include Gosu

require 'map'
require 'player'
require 'collectible_gem'

class Game < Window
  attr_reader :map

  def initialize
    super(640, 480, false)
    self.caption = "Cptn. Ruby"
    @map = Map.new(self, "media/CptnRuby Map.txt")
    @cptn = Player.new(self, 400, 100)
    # Scrolling is stored as the position of the top left corner of the screen.
    @screen_x = @screen_y = 0
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @song = Gosu::Song.new(self, "media/music.mp3")
    @the_end = Gosu::Sample.new(self, "media/Applause.wav")
    @start_time = Time.now
  end
  def update
    move_x = 0
    move_x -= 5 if button_down? Button::KbLeft
    move_x += 5 if button_down? Button::KbRight
    @cptn.update(move_x)
    @cptn.collect_gems(@map.gems)
    # Scrolling follows player
    @screen_x = [[@cptn.x - 320, 0].max, @map.width * 50 - 640].min
    @screen_y = [[@cptn.y - 240, 0].max, @map.height * 50 - 480].min
    if @map.gems.empty?
      @the_end_instance = @the_end.play unless (@the_end_instance and @the_end_instance.playing?)
    else
      @song.play unless @song.playing?
    end
  end
  def draw
    @map.draw @screen_x, @screen_y
    @map.draw_minimap @map.width - 560, @map.height - 24, 0.05
    
    @cptn.draw @screen_x, @screen_y
    @font.draw("Gems: #{@map.gems.size}", 10, 10, 100, 1.0, 1.0, 0xffffff00)
    @font.draw("#{elapsed}", 10, 30, 100, 1.0, 1.0, 0xffffff00)
    @font.draw("YOU WON!!!", 60, 100, 100, 4.0, 4.0, 0xffffff00) if @map.gems.empty?
  end
  def button_down(id)
    if id == Button::KbUp then @cptn.try_to_jump end
    if id == Button::KbEscape then close end
  end
  def elapsed
    "%0.2d:%0.2d" % [(Time.now - @start_time) / 60, (Time.now - @start_time) % 60]
  end
end

Game.new.show