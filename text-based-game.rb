system "clear"

# Core System
stats = { health: 10, strength: 10, faith: 0.1 }
power = stats[:strength] * stats[:faith]
rng = rand(0..4)

# Locations & Enemies
locations = ["graveyard", "ending"]

graveyard = [{ name: "Mini Skeleton", health: 5, dmg: rand(0..1), loot: ["Coins", "Bone Sword", "Bone Necklace", "Bone Dust", "Nothing"], guaranteed: "Bones" }, { name: "Skeleton", health: 7, dmg: rand(0..2), loot: ["Coins", "Bone Sword", "Bone Necklace", "Bone Dust", "Nothing"], guaranteed: "Bones" }, { name: "Skeleton", health: 7, dmg: rand(0..2), loot: ["Coins", "Bone Sword", "Bone Necklace", "Bone Dust", "Nothing"], guaranteed: "Bones" }, { name: "Skeleton Brute", health: 10, dmg: rand(1..2), loot: ["Coins", "Bone Sword", "Bone Necklace", "Bone Dust", "Nothing"], guaranteed: "Bones" }, { name: "Skeleton Brute", health: 10, dmg: rand(1..2), loot: ["Coins", "Bone Sword", "Bone Necklace", "Bone Dust", "Nothing"], guaranteed: "Bones" }, { name: "Skeletal Mage", health: 20, dmg: rand(1..4), loot: ["Coins", "Bone Sword", "Bone Necklace", "Bone Dust", "Nothing"], guaranteed: "tincture" }]

#Inventory System
backpack = [{ "coin_purse" => 0 }]

#Faith System
bones_quantity = backpack.count("Bones")

story_intro = "You stand at the castle gates, ready to explore the unknown world outside. Excitement and apprehension mix inside you as you step into the wild. Your determination to prove yourself as a worthy adventurer and protector of the realm drives you forward. With your sword at your side and a heart full of determination, you step into the unknown, eager to discover what the world has in store for you."

story_graveyard = "As you wander through the wild, you come across a graveyard filled with the bones of long-dead creatures. The sun is setting, casting an eerie orange glow over the bones. You pause for a moment to take in the sight, your heart pounding in your chest. As you make your way through the graveyard, you hear a rustling in the bones. Suddenly, a group of skeletons rises up from the ground, their bones clacking together in a macabre symphony. With a steady hand on your sword, you prepare to defend yourself against the undead creatures. They come at you with surprising speed, their bony fingers reaching out to grab you."

game = true
is_alive = true

# Game Start
puts "Welcome to TEXTRPG"
puts "What is your name adventurer?"
name = gets.chomp

system "clear"

puts "Welcome #{name}!"
puts " "

pp story_intro

#Encounter System
actions = { "Attack or A" => "Attack the current enemy", "Rest or R" => "Rest to restore health", "Tincture or T" => "Use a tincture to boost your strength temporarily", "Flee or F" => "Chance to flee based on your faith.", "Backpack or B" => "Use to check your inventory", "Stats or S" => "check your current stats", "Exit" => "Exit game at anytime" }

while true
  if game == false
    puts "you've exited the game"
    break
  end
  i = 0
  while i < locations.length
    if locations[i] == "ending"
      puts "You Win!"
      break
    end
    current_location = locations[i]
    if locations[i] == "graveyard"
      puts ""
      puts story_graveyard
      puts ""
      i2 = 0
      current_player_strength = stats[:strength]
      current_player_health = stats[:health]
      while i2 < graveyard.length
        current_enemy = graveyard[i2]
        puts "You've run into a #{current_enemy[:name]}!"
        current_enemy_health = current_enemy[:health]
        while true
          puts " "
          puts "CHOOSE AN ACTION! ('actions' for a list of actions)"
          action = gets.chomp
          puts " "
          if action == "b" || action == "backpack"
            pp backpack
          elsif action == "actions"
            pp actions
          elsif action.downcase == "a" || action.downcase == "attack"
            puts "You've swung your sword at the enemy!"
            current_enemy_health -= power
            puts "#{current_enemy[:name]} has #{current_enemy_health} remaining!"
            current_player_health -= current_enemy[:dmg]
            if current_player_health <= 0
            elsif current_enemy[:dmg] > 0
              puts "you've been hit! your health is now #{current_player_health}"
            else
              puts "the enemy missed!"
            end
          elsif action.downcase == "r" || action.downcase == "rest"
            current_player_health += 10
            current_player_health -= current_enemy[:dmg]
            puts "you've been hit! your health is now #{current_player_health}"
          elsif action.downcase == "t" || action.downcase == "tincture"
            if backpack.include?("tincture")
              puts "you used a strength tincture!"
              current_player_strength += 5
              pp current_player_strength
            else
              puts "you currently dont have a tincture to use."
            end
            current_player_health -= current_enemy[:dmg]
            puts "you've been hit! your health is now #{current_player_health}"
          elsif action.downcase == "p" || action.downcase == "pray"
            puts "you've used all #{bones_quantity} of your bones!"
            k = 1
            while k < backpack.length
              if backpack[k] == "Bones"
                stats[:faith] += 0.1
              end
              backpack.delete("Bones")
              k += 1
            end
            if backpack.any?("Bones") == false
              puts "You leveled up your faith to #{stats[:faith]}"
            end
          elsif action.downcase == "f" || action.downcase == "flee"
            chance = current_enemy_health * stats[:faith] / 100
            if chance >= 0.5
              break
            else
              puts "you can't flee!"
              current_player_health -= current_enemy[:dmg]
              puts "you've been hit! your health is now #{current_player_health}"
            end
          elsif action.downcase == "s" || action.downcase == "stats"
            pp stats
          elsif action.downcase == "exit"
            i = 10
            i2 = 10
            game = false
            break
          else
            puts "enter valid action"
          end
          if current_player_health <= 0
            is_alive = false
            i = 10
            i2 = 10
            break
          end
          if current_enemy_health == 0
            puts "#{current_enemy[:name]} is dead!"
            stats[:health] += 2
            stats[:strength] += 2
            drop = current_enemy[:loot].sample
            if drop == "Nothing"
              puts "nothing to loot"
            elsif drop == "Coins"
              if locations[i] == "graveyard"
                coins = rand(0..200)
                backpack[0]["coin_purse"] += coins
              end
              puts "you received #{coins} coins"
            else
              backpack << current_enemy[:guaranteed]
              backpack << drop
            end
            if backpack.empty?
              puts "your backpack is empty"
            else
              puts " "
              pp backpack
            end
            break
          end
        end
        i2 += 1
      end
    end
    i += 1
  end
  if is_alive == false
    puts "oh dear! you died!"
    if resurect_available == true
      puts "you're back alive!"
    else
      break
    end
  end
end
