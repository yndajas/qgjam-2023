# To do

- add player score indicator
- on enemy/player bullet collision:
  - if enemy is sprite 0 or 1
    - play hit sound effect
  - if they are now sprite 2
    - if there are any flags not in the player's collection (solidarity meter),
      add one of the ones they don't have to their collection
- on player/enemy bullet collision:
  - if they have any flags in their collection:
    - remove one random flag
  - else:
    - trigger game over state
  - play sound effect
- game over state
  - display count of new baby queers successfully converted
  - display prompt to play again (square/R)
  - display prompt to return to main menu (circle/escape)
- music
- menu
- change player sprite to Sprite2D?
- change collision shape to collision polygon?

## Stretch goals

- show controls in HUD
- add count up timer
- display survival time in game over state
- add option to start the game with a few flags in your solidarity meter
- increase enemy spawn rate and/or bullet rate and/or speed over time
- randomise whether enemy is sprite 0 or 1 on instantiation, favouring 0
- make player invulnerable for N seconds after being hit
- make enemy invulnerable for N seconds after being hit
- add pause state (options/P) with resume, restart, and return to main prompts
- make the bullets queer iconography - either changing as you power up, or
  customisable in a menu
- power up player bullets as flag collection grows
- online leaderboard

## Done

- player/ship sprite
- 'bullet' sprite - colour cubes
- enemy 'bullet' sprite - white cube
- enemy sprite including three saturation/gayness versions (0: black and white
  wings; 1: one white black and white wing, one rainbow; 2: rainbow wings)
- rainbow explosion particle effect
- project settings
- spawn player in middle bottom of screen
- allow player to move left and right
- prevent player going off screen
- add bullet scene and script and randomise sprite
- free/remove bullet instance when off screen
- on button press:
  - instantiate bullet on/near player
  - move bullet up screen
  - play sound effect
- move enemy right every physics process
- free/remove enemy instance when off screen right
- instantiate enemy as sprite 0 off screen left
- spawn an enemy every N seconds
- randomise time between enemy spawns within a range
- randomise height of enemy spawn within a range
- instantiate enemy bullet on/near enemy instance
- move enemy bullet instance down the screen
- free/remove enemy bullet instance when off screen bottom
- instantiate new enemy bullet every random N seconds within a range
- on enemy/player bullet collision:
  - if enemy is sprite 0 or 1
    - move to next sprite up
  - if they are now sprite 2
    - stop their bullet fire
    - stop their movement
    - play rainbow explosion and free/remove the instance when the explosion
      ends
    - play queerified sound effect
    - queue free when explosion and sound effect ended
    - add to player score
- on player/enemy bullet collision:
  - derender enemy bullet
- play sound effect on enemy bullet instantiation
- spawn enemies from both sides? How to manage overlap?
- add player score variable
