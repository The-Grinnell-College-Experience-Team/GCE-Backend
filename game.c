// libraries being used for this project
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <SDL.h>
#include <SDL_image.h> // make sure to include the SDL_image library for sprites
#include <SDL2/SDL_mixer.h> // includes the SDL audio mixer
#include <pthread.h>
#include <sys/stat.h> // for mkdir

// macros for commonly used values to make easier readability
#define TILE_WIDTH 16
#define TILE_HEIGHT 16
#define X_OFFSET 8
#define MAP_ROWS 9
#define MAP_COLS 10
#define FPS 60
#define X_RESOLUTION 160
#define Y_RESOLUTION 144
#define MOVEMENT_DELAY 150
#define RES_SCALE 8
#define MENU_ITEM_COUNT 3
#define SPRITE_FRAMES 2 // the frames per direction
#define ANIMATION_DELAY 125 // the millisecond delay between frames
#define FRAME_DELAY 1000 / FPS // frame delay for 60 fps and making sure CPU does not run 100%
#define NUM_TEXTURES 12 // the number of textures that we will be using

// I didn't want to include math.h because I was purely dealing with integers
// instead I decided to use these trivial macros for min and maxing
#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))

// global variable that will allow our threads to sync properly
int musicSelector = 0; // initial music selection

// Variables for sprite animation
int currentFrame = 0;
Uint32 lastAnimationFrame = 0;
int animationRowHeight = TILE_HEIGHT; // assumes that each animation is in a different row

// this will set up for our start menu
typedef enum { MENU, GAME } GameState;
GameState currentGameState = GAME;

// This will set up our menu options
typedef enum { SAVE, LOAD, EXIT } MenuState;
MenuState currentMenuState = SAVE;

// Variables for tracking character direction and state
typedef enum { RIGHT, LEFT, UP, DOWN, IDLE_RIGHT, IDLE_LEFT, IDLE_UP, IDLE_DOWN } Direction;

// Structs for managing game data
typedef struct 
{
    int x, y;
    Direction direction;
    SDL_Texture *sprite;
} Player;

typedef struct 
{
    SDL_Texture *textures[NUM_TEXTURES]; // Define NUM_TEXTURES as needed
    int map[MAP_ROWS][MAP_COLS];
} GameMap;


void initSDL () 
{
  // error checking for SDL and SDL_image
  if (SDL_Init(SDL_INIT_VIDEO) < 0) 
  {
    fprintf(stderr, "SDL could not initialize! SDL_Error: %s\n", SDL_GetError());
    return;
  }

  if (!(IMG_Init(IMG_INIT_PNG) & IMG_INIT_PNG)) 
  {
    fprintf(stderr, "SDL_image could not initialize! SDL_image Error: %s\n", IMG_GetError());
    SDL_Quit();
    return;
  }
}

void setupWindow (SDL_Window** window, SDL_Renderer** renderer) 
{
  // resolution is scaled 8x higher than what will be rendered (1280x1152 screen for 160x144 game)
  *window = SDL_CreateWindow("Perkemerrrrrrnnnnnnn", 
                            SDL_WINDOWPOS_CENTERED, 
                            SDL_WINDOWPOS_CENTERED, 
                            X_RESOLUTION * RES_SCALE, 
                            Y_RESOLUTION * RES_SCALE, 
                            SDL_WINDOW_SHOWN);
  // make sure window runs successfully
  if (!(*window)) 
  {
    fprintf(stderr, "Window could not be created! SDL_Error: %s\n", SDL_GetError());
    IMG_Quit();
    SDL_Quit();
    return;
  }

  *renderer = SDL_CreateRenderer(*window, -1, SDL_RENDERER_ACCELERATED);

  // make sure renderer runs successfully
  if (!(*renderer)) 
  {
    fprintf(stderr, "Renderer could not be created! SDL_Error: %s\n", SDL_GetError());
    SDL_DestroyWindow(*window);
    IMG_Quit();
    SDL_Quit();
    return;
  }

  // set up the render to match our desired resolution
  SDL_RenderSetLogicalSize(*renderer, X_RESOLUTION, Y_RESOLUTION); // resolution is 160x144
}



/**
 * This function will save the game state to a file
 * 
 * @param x the x position of the player
 * @param y the y position of the player
 * @param currentMap the current map that the player is on
 * @param musicSelector the current music that is playing
 * 
 * @return void
 */
void saveGame (int x, int y, char* currentMap, int musicSelector) 
{
  // Try to create a directory for the save file (if it doesn't exist)
  // this works because mkdir doesn't do anything if the directory already exists
  mkdir("save_data", 0777); // 0777 permissions mean everyone can read/write/execute

  // open file from the directory
  // this will create the file if it doesn't exist
  FILE *saveFile = fopen("save_data/save.txt", "w");
  if (saveFile == NULL) 
  {
      fprintf(stderr, "Error opening or creating save file!\n");
      return;
  }

  // save the current map
  fprintf(saveFile, "map: %s\n", currentMap);

  // save the music state
  fprintf(saveFile, "music: %d\n", musicSelector);

  // convert the player's position to grid coordinates and save
  int gridX = (x - X_OFFSET) / TILE_WIDTH;
  int gridY = y / TILE_HEIGHT;
  fprintf(saveFile, "xpos: %d\n", gridX);
  fprintf(saveFile, "ypos: %d\n", gridY);

  fclose(saveFile);
}

/**
 * This function will calculate the source rectangle for the sprite animation
 * 
 * @param srcRect the source rectangle for the sprite
 * @param direction the direction that the sprite is facing
 * @param currentFrame the current frame of the sprite animation
 * 
 * @return void
 */
void calculateSrcRect(SDL_Rect *srcRect, Direction direction, int currentFrame) 
{
    srcRect->w = TILE_WIDTH;
    srcRect->h = TILE_HEIGHT;

    // Idle frames are all in the first row, walking frames are in subsequent rows
    switch (direction) 
    {
        case IDLE_RIGHT:
            srcRect->x = 0 * TILE_WIDTH;
            srcRect->y = 0;
            break;
        case IDLE_LEFT:
            srcRect->x = 1 * TILE_WIDTH;
            srcRect->y = 0;
            break;
        case IDLE_UP:
            srcRect->x = 2 * TILE_WIDTH;
            srcRect->y = 0;
            break;
        case IDLE_DOWN:
            srcRect->x = 3 * TILE_WIDTH;
            srcRect->y = 0;
            break;
        case RIGHT:
            srcRect->x = currentFrame * TILE_WIDTH;
            srcRect->y = 1 * TILE_HEIGHT;
            break;
        case LEFT:
            srcRect->x = currentFrame * TILE_WIDTH;
            srcRect->y = 2 * TILE_HEIGHT;
            break;
        case UP:
            srcRect->x = currentFrame * TILE_WIDTH;
            srcRect->y = 3 * TILE_HEIGHT;
            break;
        case DOWN:
            srcRect->x = currentFrame * TILE_WIDTH;
            srcRect->y = 4 * TILE_HEIGHT;
            break;
    }
}

// CITATION: ChatGPT helped me with learning SDL and SDL_image
// prompt given: can you teach me about using the sdl library in c
/**
 * This thread function will run the game
 * 
 * @return void
 */
void* game () 
{
  // Initialize SDL
  initSDL();

  // declare the window and renderer
  SDL_Window *window;
  SDL_Renderer *renderer;
  SDL_Event event;
  
  // set up the window and renderer
  setupWindow(&window, &renderer);

  int isRunning = 1; // control variable for the main loop
  Player mainCharacter = {(X_RESOLUTION - TILE_WIDTH) / 2, // default x position
                          (Y_RESOLUTION - TILE_HEIGHT) / 2, // default y position
                          IDLE_DOWN, // default direction
                          IMG_LoadTexture(renderer, "assets/textures/characters/mc.png")}; // default texture



  /******* Part 2: Initialize the framerate, load the textures, and set up the maps *******/
  Uint32 frameStart; // Time at the start of the frame
  Uint32 lastMoveTime = 0; // Time of the last movement

  // Load the menu textures
  SDL_Texture *menuSave = IMG_LoadTexture(renderer, "assets/textures/menu/menu_save.png");
  SDL_Texture *menuLoad = IMG_LoadTexture(renderer, "assets/textures/menu/menu_load.png");
  SDL_Texture *menuLoadError = IMG_LoadTexture(renderer, "assets/textures/menu/menu_load_error.png");
  SDL_Texture *menuExit = IMG_LoadTexture(renderer, "assets/textures/menu/menu_exit.png");
  
  // Load ALL the scene textures
  SDL_Texture *wallTexture, *floorTexture, *perllertRightExitTexture, *pkrmrnLeftExitTexture, 
              *ctrTopRight, *ctrTopLeft, *ctrBottomRight, *ctrBottomLeft, *ctrWall1, *ctrWall2, 
              *ctrWall3, *ctrWall4; 

  wallTexture = IMG_LoadTexture(renderer, "assets/textures/world/wall_grey.png");
  floorTexture = IMG_LoadTexture(renderer, "assets/textures/world/grass_grey.png");
  perllertRightExitTexture = IMG_LoadTexture(renderer, "assets/textures/world/enter_pkrmrn_ctr.png");
    
  pkrmrnLeftExitTexture = IMG_LoadTexture(renderer, "assets/textures/world/enter_perllert_town.png");
  ctrTopRight = IMG_LoadTexture(renderer, "assets/textures/world/ctr_tile_top_right.png");
  ctrTopLeft = IMG_LoadTexture(renderer, "assets/textures/world/ctr_tile_top_left.png");
  ctrBottomRight = IMG_LoadTexture(renderer, "assets/textures/world/ctr_tile_bottom_right.png");
  ctrBottomLeft = IMG_LoadTexture(renderer, "assets/textures/world/ctr_tile_bottom_left.png");
    
  ctrWall1 = IMG_LoadTexture(renderer, "assets/textures/world/ctr_wall1.png");
  ctrWall2 = IMG_LoadTexture(renderer, "assets/textures/world/ctr_wall2.png");
  ctrWall3 = IMG_LoadTexture(renderer, "assets/textures/world/ctr_wall3.png");
  ctrWall4 = IMG_LoadTexture(renderer, "assets/textures/world/ctr_wall4.png");

  // set up the perllert town map
  int perllert_town_map[MAP_ROWS][MAP_COLS] = 
  {
    {1, 1, 1, 1, 1, 1, 1, 1, 0, 1}, // 1 represents a wall
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 1}, // 0 represents a walkable tile
    {1, 0, 0, 0, 0, 1, 1, 0, 0, 1}, 
    {1, 0, 0, 0, 0, 0, 1, 0, 0, 1}, 
    {1, 0, 0, 0, 0, 0, 1, 0, 0, 1}, 
    {1, 0, 1, 0, 0, 0, 1, 0, 0, 1}, 
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 2}, // 2 represents an exit point
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 2}, 
    {1, 0, 0, 1, 1, 1, 1, 1, 1, 1}, 
  };

  // set up the perkemern center map
  int pkrmrn_ctr_map[MAP_ROWS][MAP_COLS] = 
  {
    {9, 11, 11, 11, 9, 9, 11, 11, 11, 9}, 
    {9, 5,  4,  5,  9, 9, 4,  5,  4,  9}, 
    {8, 10, 10, 10, 8, 8, 10, 10, 10, 8}, 
    {4, 5,  4,  5,  4, 5, 4,  5,  4,  5}, 
    {6, 7,  6,  7,  6, 7, 6,  7,  6,  7}, 
    {4, 5,  4,  5,  4, 5, 4,  5,  4,  5}, 
    {3, 7,  6,  7,  6, 7, 6,  7,  6,  7}, // 3 represents exit point
    {3, 5,  4,  5,  4, 5, 4,  5,  4,  5}, 
    {6, 7,  6,  7,  6, 7, 6,  7,  6,  7}, 
  };

  // set up the map variable and its naming convention
  int map[MAP_ROWS][MAP_COLS];
  char* currentMapName = "perllert_town_map";

  // set up the load error variable for save handling
  bool loadError = false;

  // Copy the map from the array to the map variable
  for (int i = 0; i < MAP_ROWS; ++i)
  {
    for (int j = 0; j < MAP_COLS; ++j)
    {
      map[i][j] = perllert_town_map[i][j];
    }
  }

  musicSelector = 1; // start with perllert town music
  int chooseMap = 1; // determine which map to load, start with perllert town map
  
  /******* Part 3: Setup the game loop and main logic *******/
  while (isRunning) 
  {
    /***** Part 3a: initialize the loop, determine which screen to render *****/
    frameStart = SDL_GetTicks();
    
    // event handling
    while (SDL_PollEvent(&event)) 
    {
      switch(event.type)
      {
        // handle quit event
        case SDL_QUIT:
          isRunning = 0;
          break;
        // handle key press from user
        case SDL_KEYDOWN:
          switch(event.key.keysym.sym)
          {
            // handle 'enter' input for switching between game and menu
            case SDLK_RETURN:
              switch(currentGameState)
              {
                // consider when we are dealing with the menu
                case MENU:
                  /***** Part 3b: handle the save system *****/
                  switch (currentMenuState)
                  {
                    // handle save case
                    case SAVE:
                      // save the game by calling our saveGame function
                      saveGame(mainCharacter.x, mainCharacter.y, currentMapName, musicSelector);
                      break;
                    // handle exit menu case
                    case EXIT:
                      // simply change the game state to exit the game
                      currentGameState = GAME;
                      break;
                    // handle load case
                    case LOAD:
                      // check to see whether we are in the load error state or not
                      if (loadError) 
                      {
                        currentMenuState = LOAD;
                        loadError = false;
                        break;
                      }

                      // load the game
                      FILE* saveFile = fopen("save_data/save.txt", "r");
                      char line[100]; // Array to hold each line of the file

                      // Check if the file exists
                      if (saveFile == NULL) 
                      {
                        loadError = true;
                        break;
                      }

                      // Read the file line by line
                      while (fgets(line, sizeof(line), saveFile) != NULL) 
                      {
                        // set up our checks in the save file
                        char mapPrefix[] = "map: ";
                        char musicPrefix[] = "music: ";
                        char xposPrefix[] = "xpos: ";
                        char yposPrefix[] = "ypos: ";

                        // check to see if the line is a map line
                        if(strncmp(mapPrefix, line, strlen(mapPrefix)) == 0)
                        {
                          // ensure that the line has a value
                          if(strlen(line) <= strlen(mapPrefix))
                          {
                            loadError = true;
                            printf("map prefix has no value\n");
                            break;
                          }

                          // we will select the map based on the string after the prefix
                          char* mapChoice = line + strlen(mapPrefix);
                          
                          // now we have the map choice, we can change the map variable
                          // 18 is the number of characters in "perllert_town_map", not magic number
                          for (int i = 0; i < MAP_ROWS; ++i)
                          {
                            for (int j = 0; j < MAP_COLS; ++j)
                            {
                              // we will select the map based on the value after the prefix
                              if (strncmp("perllert_town_map", mapChoice, strlen("perllert_town_map")) == 0)
                              {
                                map[i][j] = perllert_town_map[i][j];
                                chooseMap = 1;
                              }
                              else if (strncmp("pkrmrn_ctr_map", mapChoice, strlen("pkrmrn_ctr_map")) == 0)
                              {
                                map[i][j] = pkrmrn_ctr_map[i][j];
                                chooseMap = 2;
                              }
                            }
                          }
                        }
                        // check to see if the line is a music line
                        else if(strncmp(musicPrefix, line, strlen(musicPrefix)) == 0)
                        {
                          // ensure that the line has a value
                          if(strlen(line) <= strlen(musicPrefix))
                          {
                            loadError = true;
                            printf("music prefix has no value\n");
                            break;
                          }

                          char musicChoice[100];
                          for (int i = (int) strlen(musicPrefix); i < (int) strlen(line) - 1; ++i)
                          {                    
                            // we will select the music based on the value after the prefix
                            musicChoice[i - strlen(musicPrefix)] = line[i];
                          }

                          musicSelector = atoi(musicChoice);
                        }
                        // check to see if the line is an xpos line
                        else if(strncmp(xposPrefix, line, strlen(xposPrefix)) == 0)
                        {
                          // ensure that the line has a value
                          if(strlen(line) <= strlen(xposPrefix))
                          {
                            loadError = true;
                            printf("xpos prefix has no value\n");
                            break;
                          }

                          char xChoice[100];
                          for (int i = (int) strlen(xposPrefix); i < (int) strlen(line) - 1; ++i)
                          {
                            // we will select the x pos based on the value after the prefix
                            xChoice[i - strlen(xposPrefix)] = line[i];
                          }
                          // reading in xpos
                          mainCharacter.x = atoi(xChoice) * TILE_WIDTH + X_OFFSET;

                        }
                        // check to see if the line is a ypos line
                        else if(strncmp(yposPrefix, line, strlen(yposPrefix)) == 0)
                        {
                          // ensure that the line has a value
                          if(strlen(line) <= strlen(yposPrefix))
                          {
                            loadError = true;
                            printf("ypos prefix has no value\n");
                            break;
                          }

                          char yChoice[100];
                          for (int i = (int) strlen(yposPrefix); i < (int) strlen(line) - 1; ++i)
                          {
                            // we will select the x pos based on the value after the prefix
                            yChoice[i - strlen(yposPrefix)] = line[i];
                          }
                          // reading in ypos
                          mainCharacter.y = atoi(yChoice) * TILE_HEIGHT;
                        }
                      }
                      // close the file for safety
                      fclose(saveFile);
                      break;
                    default:
                      break;
                  }
                  break;
                // consider when we are dealing with the game
                case GAME:
                  // simply change to the menu state
                  currentGameState = MENU;
                  currentMenuState = SAVE;
                  break;
                default:
                  break;
              }
              break;
            // handle 'up' input for switching between menu options
            case SDLK_w:
              if (currentMenuState > 0 && !loadError) 
              {
                --currentMenuState;
              }
              break;
            // handle 'down' input for switching between menu options
            case SDLK_s:
              if (currentMenuState < MENU_ITEM_COUNT - 1 && !loadError) 
              {
                ++currentMenuState;
              }
              break;
          }
          break;
      }
    }
    
    // Clear the renderer
    SDL_RenderClear(renderer);

    // Render the scene based on the current state
    switch(currentGameState) 
    {
      // render the menu case
      case MENU:
        // simply show the appropriate menu
        switch(currentMenuState)
        {
          case SAVE:
            SDL_RenderCopy(renderer, menuSave, NULL, NULL);
            break;
          case LOAD:
            if(loadError) SDL_RenderCopy(renderer, menuLoadError, NULL, NULL);
            else SDL_RenderCopy(renderer, menuLoad, NULL, NULL);
            break;
          case EXIT:
            SDL_RenderCopy(renderer, menuExit, NULL, NULL);
            break;
          default:
            break;
        }
        break;
      // render the game case
      case GAME:
        /***** Part 3c: setup the map using the textures *****/
        // this loop will render the map based on the map array
        for (int row = 0; row < MAP_ROWS; ++row) 
        {
          for (int col = 0; col < MAP_COLS; ++col) 
          {
            SDL_Rect srcRect = {0, 0, TILE_WIDTH, TILE_HEIGHT}; // Source rectangle for the texture
            SDL_Rect destRect = {col * TILE_WIDTH, row * TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT}; // Destination rectangle on screen

            // Render the texture based on the map value
            switch(map[row][col])
            {
              case 0:
                // Draw floor
                SDL_RenderCopy(renderer, floorTexture, &srcRect, &destRect);
                break;
              case 1:
                // Draw wall
                SDL_RenderCopy(renderer, wallTexture, &srcRect, &destRect);
                break;
              case 2:
                // Draw right perllert town exit
                SDL_RenderCopy(renderer, perllertRightExitTexture, &srcRect, &destRect);
                break;
              case 3:
                // Draw left pkrmrn ctr exit
                SDL_RenderCopy(renderer, pkrmrnLeftExitTexture, &srcRect, &destRect);
                break;
              case 4:
                SDL_RenderCopy(renderer, ctrTopRight, &srcRect, &destRect);
                break;
              case 5:
                SDL_RenderCopy(renderer, ctrTopLeft, &srcRect, &destRect);
                break;
              case 6:
                SDL_RenderCopy(renderer, ctrBottomRight, &srcRect, &destRect);
                break;
              case 7:
                SDL_RenderCopy(renderer, ctrBottomLeft, &srcRect, &destRect);
                break;
              case 8:
                SDL_RenderCopy(renderer, ctrWall1, &srcRect, &destRect);
                break;
              case 9:
                SDL_RenderCopy(renderer, ctrWall2, &srcRect, &destRect);
                break;
              case 10:
                SDL_RenderCopy(renderer, ctrWall3, &srcRect, &destRect);
                break;
              case 11:
                SDL_RenderCopy(renderer, ctrWall4, &srcRect, &destRect);
                break;
              default:
                break;
            }
          }
        }

        /***** Part 3d: handle user input and acceptable time window for input *****/
        Uint32 currentTime = SDL_GetTicks();

        // Check if enough time has passed since the last move
        if (currentTime - lastMoveTime >= MOVEMENT_DELAY) 
        {
          // Handle keyboard input
          const Uint8 *state = SDL_GetKeyboardState(NULL);
          int moved = 0;

          // track our new coordinates
          int newX = mainCharacter.x;
          int newY = mainCharacter.y;

          // track our grid position
          int gridX = mainCharacter.x / TILE_WIDTH;
          int gridY = mainCharacter.y / TILE_HEIGHT;

          // track whether we need to switch maps or not
          bool switchMap = false;

          // animation setup
          Uint32 currentTime = SDL_GetTicks();

          // determine which direction we are moving
          if (state[SDL_SCANCODE_W]) 
          {
            // update animation variables
            mainCharacter.direction = UP;

            // case we are moving up
            newY -= TILE_HEIGHT; 
            moved = 1;
          }
          else if (state[SDL_SCANCODE_A]) 
          {
            // update animation variables
            mainCharacter.direction = LEFT;

            // case we are moving left
            newX -= TILE_WIDTH;
            moved = 1;

            // determine if we are at an exit point
            switch (map[gridY][gridX])
            {
              case 3:
                // setup changing map
                switchMap = true;
                chooseMap = 1;

                // setup starting coordinates
                newX = MAP_COLS * TILE_WIDTH;
                newY = mainCharacter.y;
                moved = 0;

                // setup music
                musicSelector = 1;
                break;
              default:
                break;
            }
          }
          else if (state[SDL_SCANCODE_S]) 
          {
            // update animation variables
            mainCharacter.direction = DOWN;

            // case we are moving down
            newY += TILE_HEIGHT;
            moved = 1;
          }
          else if (state[SDL_SCANCODE_D]) 
          {
            // update animation variables
            mainCharacter.direction = RIGHT;

            // case we are moving right
            newX += TILE_WIDTH; 
            moved = 1;

            // determine if we are at an exit point
            switch (map[gridY][gridX])
            {
              case 2:
                // setup changing map
                switchMap = true;
                chooseMap = 2;

                // setup starting coordinates
                newX = -TILE_WIDTH;
                newY = mainCharacter.y;
                moved = 0;

                // setup music
                musicSelector = 2;
                break;
            }
          }

          // Reset to idle state if no movement keys are pressed
          if (!(state[SDL_SCANCODE_W] || state[SDL_SCANCODE_A] || state[SDL_SCANCODE_S] || state[SDL_SCANCODE_D]))
          {
              currentFrame = 0; // reset animation frame for idle
              switch(mainCharacter.direction)
              {
                case UP:
                  mainCharacter.direction = IDLE_UP;
                  break;
                case LEFT:
                  mainCharacter.direction = IDLE_LEFT;
                  break;
                case DOWN:
                  mainCharacter.direction = IDLE_DOWN;
                  break;
                case RIGHT:
                  mainCharacter.direction = IDLE_RIGHT;
                  break;
                default:
                  break;
              }
          }

          // determine which map we are on, and change the currentMapName variable appropriately
          switch(chooseMap)
          {
            case 1:
              currentMapName = "perllert_town_map";
              break;
            case 2:
              currentMapName = "pkrmrn_ctr_map";
              break;
            default:
              break;
          } 

          // determine if we need to switch maps
          if(switchMap)
          {
            // loop through our map variable and change it to the new map
            for (int i = 0; i < MAP_ROWS; ++i)
            {
              for (int j = 0; j < MAP_COLS; ++j)
              {
                switch(chooseMap)
                {
                  case 1:
                    map[i][j] = perllert_town_map[i][j];
                    break;
                  case 2:
                    map[i][j] = pkrmrn_ctr_map[i][j];
                    break;
                  default:
                    break;
                }
              }
            }

            // apply our changed coordinates to the new map
            mainCharacter.x = newX + X_OFFSET;
            mainCharacter.y = newY;  

            // reset the switch map variable
            switchMap = false;
          }
          // otherwise, we are just moving around the map
          else if (newX >= 0 && 
              // we do not subtract TILE_WIDTH because we already account for x position
              newX <= (MAP_COLS * TILE_WIDTH) && //- TILE_WIDTH + TILE_WIDTH &&
              newY >= 0 && 
              newY <= ((MAP_ROWS * TILE_HEIGHT) - TILE_HEIGHT))
          {
            // determine the grid position of the new coordinates
            int newGridX = newX / TILE_WIDTH;
            int newGridY = newY / TILE_HEIGHT;

            // determine if the new position is a wall or not
            switch(map[newGridY][newGridX])
            {
              case 0:
              case 2:
              case 3:
              case 4:
              case 5:
              case 6:
              case 7:
                // ensure the character is within map bounds
                mainCharacter.x = newX;
                mainCharacter.y = newY;
                break;
              default: // default is that the texture is a wall
                break;
            }
          }

          // determine if we have moved or not
          if (moved != 0)
          {
            // Update the last move time if we have moved for the delay
            lastMoveTime = currentTime;
          }
        }

        /***** Part 3e: Finalize changes to frame *****/
        if (mainCharacter.direction != IDLE_RIGHT && mainCharacter.direction != IDLE_LEFT && 
            mainCharacter.direction != IDLE_UP && mainCharacter.direction != IDLE_DOWN) 
        {
          // Update the frame if the character is not idle
          if (currentTime - lastAnimationFrame >= ANIMATION_DELAY) 
          {
            currentFrame = (currentFrame + 1) % SPRITE_FRAMES;
            lastAnimationFrame = currentTime;
          }
        } 
        else 
        {
          // Reset to the first frame when idle
          currentFrame = 0;
        }
        
        SDL_Rect srcRect;
        calculateSrcRect(&srcRect, mainCharacter.direction, currentFrame);

        // Render the sprite
        SDL_Rect destRect = {mainCharacter.x - X_OFFSET, // for whatever reason, the sprite has an off by 8 issue, so I just fix it here
                             mainCharacter.y, 
                             TILE_WIDTH, 
                             TILE_HEIGHT};
        SDL_RenderCopy(renderer, mainCharacter.sprite, &srcRect, &destRect);
        break;
    }

    // present the renderer
    SDL_RenderPresent(renderer);

    // Framerate control
    int frameTime = SDL_GetTicks() - frameStart;
    if (FRAME_DELAY > frameTime) 
    {
      SDL_Delay(FRAME_DELAY - frameTime);
    }
  }

  /******* Part 4: Cleanup *******/
  SDL_DestroyTexture(mainCharacter.sprite);

  SDL_DestroyTexture(menuSave);
  SDL_DestroyTexture(menuLoad);
  SDL_DestroyTexture(menuLoadError);
  SDL_DestroyTexture(menuExit);

  SDL_DestroyTexture(wallTexture);
  SDL_DestroyTexture(floorTexture);
  SDL_DestroyTexture(perllertRightExitTexture);
  SDL_DestroyTexture(pkrmrnLeftExitTexture);

  SDL_DestroyTexture(ctrTopRight);
  SDL_DestroyTexture(ctrTopLeft);
  SDL_DestroyTexture(ctrBottomRight);
  SDL_DestroyTexture(ctrBottomLeft);

  SDL_DestroyTexture(ctrWall1);
  SDL_DestroyTexture(ctrWall2);
  SDL_DestroyTexture(ctrWall3);
  SDL_DestroyTexture(ctrWall4);

  SDL_DestroyRenderer(renderer); 
  SDL_DestroyWindow(window);
  IMG_Quit(); 
  
  // set the music selector to -1 to signal the music thread to close
  musicSelector = -1;
  return NULL;
}

// CITATION: ChatGPT helped me with learning SDL2/SDL_mixer
// prompt given: Can you teach me how to play music using SDL
/**
 * This thread function will run the music
 * 
 * @return void
 */
void* music()
{
  // Initialize SDL
  SDL_Init(SDL_INIT_AUDIO);

  // Initialize SDL_mixer
  Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048);

  // Load music tracks
  Mix_Music *music1 = Mix_LoadMUS("assets/audio/perllert_town_music.wav");
  Mix_Music *music2 = Mix_LoadMUS("assets/audio/perkemern_center.wav");
  
  bool running = true; // control variable for the main loop

  // set up a loop to keep the music playing
  while (running) 
  {
    // check for events or conditions that might change musicSelector
    static int currentPlaying = 0; // Keep track of what is currently playing

    // see if there's been a change in music selection
    if (currentPlaying != musicSelector) 
    {
      // stop current music
      Mix_HaltMusic();

      // delay briefly to prevent the music from starting too fast
      SDL_Delay(20);

      // Play new music based on musicSelector
      switch (musicSelector) 
      {
        // in -1 case, we get the signal that game thread has closed
        // now we would want to close the music thread, so we set running to false to break loop
        case -1:
          // end the looping to close the thread
          running = false;
          break;
        case 0:
          break;
        // perllert town music case
        case 1:
          Mix_PlayMusic(music1, -1);
          break;
        // perkemern center case
        case 2:
          Mix_PlayMusic(music2, -1);
          break;
      }

      // update the currentPlaying variable to match the musicSelector
      currentPlaying = musicSelector;
    }

    SDL_Delay(100); // Delay to prevent this loop from running too fast
  }

  // Cleanup
  Mix_FreeMusic(music1);
  Mix_FreeMusic(music2);
  Mix_CloseAudio();

  return NULL;
}

/**
 * This is the main function that will run the game by creating two threads
 * 
 * @return 0
 */
int main () //(int argc, char* argv[])
{
  // create two threads to run in parallel
  pthread_t threads[2];

  // game thread for handling the game and user input
  pthread_create(&threads[0], NULL, game, NULL);
  // music thread for handling the music
  pthread_create(&threads[1], NULL, music, NULL);

  // join the threads to prevent the program from closing before the threads are done
  pthread_join(threads[0], NULL);
  pthread_join(threads[1], NULL);
  
  // SDL_Quit is called here to prevent a forced shutdown of the other thread
  // that could potentially cause concurrency issues if we quit before thread closing
  SDL_Quit();

  return 0;
}
