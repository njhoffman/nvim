// Generated using ntangle.nvim
#include <SDL.h>

#include <iostream>

#include <vector>

#include <algorithm>

const int WIDTH=500, HEIGHT=500;
SDL_Window* window;
SDL_Renderer* renderer;

const int GRID_SIZE = 25;
SDL_Texture* grid_texture = nullptr;

std::vector<bool> cells;
std::vector<Uint32> pixels;

int mx, my;

int cur_width = WIDTH, cur_height = HEIGHT;

SDL_PixelFormat* format = nullptr;

int isFullscreen = false;

bool simulation_running = false;

int step_every = 10;
int cur_step = 0;

std::vector<bool> tmp_cells;



auto main(int argc, char* argv[]) -> int
{
  SDL_Init(SDL_INIT_EVERYTHING);

  window = SDL_CreateWindow("Game of life",
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOWPOS_UNDEFINED,
    WIDTH, HEIGHT, SDL_WINDOW_ALLOW_HIGHDPI);

  if(window == nullptr) {
    std::cerr << "ERROR(SDL_CreateWindow): " << SDL_GetError() << std::endl;
    return EXIT_FAILURE;
  }

  renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

  if(renderer == nullptr) {
    std::cerr << "ERROR(SDL_CreateRenderer): " << SDL_GetError() << std::endl;
    return EXIT_FAILURE;
  }

  grid_texture = SDL_CreateTexture(
      renderer, SDL_PIXELFORMAT_ARGB8888,
      SDL_TEXTUREACCESS_STREAMING,
      GRID_SIZE, GRID_SIZE);

  format = SDL_AllocFormat(SDL_PIXELFORMAT_ARGB8888);

  cells.resize(GRID_SIZE*GRID_SIZE, false);
  pixels.resize(GRID_SIZE*GRID_SIZE, 0);
  std::fill(cells.begin(), cells.end(), false);
  std::fill(pixels.begin(), pixels.end(), 0);

  tmp_cells.resize(GRID_SIZE*GRID_SIZE);


  while(true) {
    SDL_Event event;
    bool do_quit = false;
    while(SDL_PollEvent(&event)) {
      switch(event.type) {
      case SDL_WINDOWEVENT:
        if(event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED) {
          cur_width = event.window.data1;
          cur_height = event.window.data2;
          std::cout << "resize " << cur_width << " " << cur_height << std::endl;
        }

        break;
      case SDL_MOUSEBUTTONDOWN:
        break;
      case SDL_MOUSEBUTTONUP:
        break;
      case SDL_MOUSEMOTION:
        mx = event.motion.x;
        my = event.motion.y;

        break;
      case SDL_KEYDOWN:
        if(event.key.keysym.scancode == SDL_SCANCODE_F) {
          SDL_SetWindowFullscreen(window, isFullscreen ? 0 : SDL_WINDOW_FULLSCREEN_DESKTOP);
          isFullscreen = !isFullscreen;
        }

        if(event.key.keysym.scancode == SDL_SCANCODE_SPACE) {
          simulation_running = !simulation_running;
        }

        if(event.key.keysym.scancode == SDL_SCANCODE_W) {
          step_every--;
          std::cout << "step every " << step_every << std::endl;
        }

        if(event.key.keysym.scancode == SDL_SCANCODE_S) {
          step_every++;
          std::cout << "step every " << step_every << std::endl;
        }

        if(event.key.keysym.scancode == SDL_SCANCODE_C) {
          std::fill(cells.begin(), cells.end(), false);
        }
        break;
      case SDL_QUIT:
        do_quit = true;
        break;
      default:
        break;
      }
    }

    if(do_quit) {
      break;
    }


    Uint32 button = SDL_GetMouseState(NULL, NULL);
    if(button & SDL_BUTTON(SDL_BUTTON_LEFT)) {
      int cx = GRID_SIZE*mx/cur_width;
      int cy = GRID_SIZE*my/cur_height;

      cells[cy*GRID_SIZE+cx] = true;

    }

    if(button & SDL_BUTTON(SDL_BUTTON_RIGHT)) {
      int cx = GRID_SIZE*mx/cur_width;
      int cy = GRID_SIZE*my/cur_height;

      cells[cy*GRID_SIZE+cx] = false;

    }

    Uint32 alive_color = SDL_MapRGBA(format, 255, 255, 255, SDL_ALPHA_OPAQUE);
    Uint32 dead_color = SDL_MapRGBA(format, 0, 0, 0, SDL_ALPHA_OPAQUE);

    for(int i=0; i<(int)cells.size(); ++i) {
      pixels[i] = cells[i] ? alive_color : dead_color;
    }

    SDL_UpdateTexture(grid_texture, NULL, pixels.data(), GRID_SIZE*sizeof(Uint32));

    if(simulation_running && cur_step++ >= step_every) {
      for(int y=0; y<GRID_SIZE; ++y) {
        for(int x=0; x<GRID_SIZE; ++x) {
          int alive = 0;
          for(int dy=-1; dy<=1; ++dy) {
            for(int dx=-1; dx<=1; ++dx) {
              if(dy == 0 && dx == 0) {
                continue;
              }

              int px = x+dx, py = y+dy;
              if(py == -1) { py = GRID_SIZE-1; }
              if(py == GRID_SIZE) { py = 0; }
              if(px == -1) { px = GRID_SIZE-1; }
              if(px == GRID_SIZE) { px = 0; }

              alive += (int)cells[py*GRID_SIZE+px];
            }
          }

          if(alive == 3) {
            tmp_cells[y*GRID_SIZE+x] = true;
          }

          else if(alive == 2) {
            tmp_cells[y*GRID_SIZE+x] = cells[y*GRID_SIZE+x];
          }

          else { // alive < 2 || alive > 3
            tmp_cells[y*GRID_SIZE+x] = false;
          }

        }
      }

      std::copy(tmp_cells.begin(), tmp_cells.end(), cells.begin());

      cur_step = 0;
    }


    SDL_SetRenderDrawColor(renderer, 0, 0, 0, SDL_ALPHA_OPAQUE);
    SDL_RenderClear(renderer);

    SDL_RenderCopy(renderer, grid_texture, NULL, NULL);

    SDL_RenderPresent(renderer);


    SDL_Delay(1000/60);

  }


  SDL_DestroyTexture(grid_texture);

  SDL_DestroyRenderer(renderer);

  SDL_DestroyWindow(window);

  SDL_Quit();


  return 0;
}


