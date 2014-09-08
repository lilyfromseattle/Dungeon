class Dungeon
  attr_accessor :player

  def initialize(player_name)
    @player = Player.new(player_name)
    @rooms = []
  end

  def add_room(reference, name, description, connections)
    @rooms << Room.new(reference, name, description, connections)
  end

  def start(location)
    @player.location = location
    puts "\nYou are trapped in Hogwarts Castle!"
    puts "\nType 'exit' at any time to quit the game!"
    show_current_description
  end

  def show_current_description
    puts find_room_in_dungeon(@player.location).full_description
  end

  def find_room_in_dungeon(reference)
    @rooms.detect { |room| room.reference == reference }
  end

  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end

  def go(direction)
    puts "\nYou go #{direction.to_s}."
    @player.location = find_room_in_direction(direction)
    show_current_description
  end

  def win
    if @player.location == :exit
      puts "\nYou escaped the Dungeon! You win!"
      exit(0)
    end
  end


  class Player
    attr_accessor :name, :location
    def initialize(player_name)
      @name = player_name
    end
  end

  class Room
    attr_accessor :reference, :name, :description, :connections
    def initialize(reference, name, description, connections)
      @reference = reference
      @name = name
      @description = description
      @connections = connections
    end

    def full_description
      "\nWelcome to the #{@name}, #{@description}."
    end
  end
end



puts "Welcome to Hogwarts!"
puts "\nEnter your name:"
name = gets.chomp
puts "\nHello #{name}!"

my_dungeon = Dungeon.new(name)


my_dungeon.add_room(:darkcave, "Dark Cave", "a very dark cave", {:north =>:chamberofsecrets,:south => :greathall, :east => :trollroom, :west => :ghostroom})
my_dungeon.add_room(:chamberofsecrets, "Chamber of Secrets", "chamber of secrets", {:north => :greathall, :south => :darkcave, :east => :trollroom, :west => :potionsroom})
my_dungeon.add_room(:potionsroom,  "Potions Room", "Professor Snape's potions classroom", {:north => :chamberofsecrets, :south => :darkcave, :east => :trollroom, :west => :exit})
my_dungeon.add_room(:trollroom, "Troll Room", "a room containing a very large troll", {:north => :darkcave, :south => :greathall, :east => :ghostroom, :west => :potionsroom})
my_dungeon.add_room(:greathall, "Great Hall", "a large room", {:north => :trollroom, :south => :darkcave, :east => :potionsroom, :west => :exit})
my_dungeon.add_room(:ghostroom, "Ghost Room", "a room filled with ghosts", {:north => :potionsroom, :south => :darkcave, :east => :trollroom, :west => :chamberofsecrets})
my_dungeon.add_room(:exit, "Exit", "a room with a door to get out of the dungeon", {:south => :darkcave})


my_dungeon.start(:darkcave)

direct = ""

while direct.downcase != "exit"
  my_dungeon.win
  puts "\nWhat direction would you like to go?"
  direct = gets.chomp.to_sym
    if direct.to_s == "exit"
        puts "Thanks for playing!"
        break
    elsif direct != :north && direct != :south && direct != :east && direct != :west && direct != :exit
      puts "That's not a direction!"
    else
      my_dungeon.go(direct)
    end
end
