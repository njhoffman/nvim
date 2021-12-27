@*=
@includes
@global_variables


auto main(int argc, char* argv[]) -> int
{
  @init_sdl
  @init_graphics
  @init_grid

  @game_loop

  @deinit_graphics
  @quit_sdl

  return 0;
}


@includes=
#include <SDL.h>

@init_sdl=
SDL_Init(SDL_INIT_EVERYTHING);

@quit_sdl=
SDL_Quit();

@global_variables=
const int WIDTH=500, HEIGHT=500;
SDL_Window* window;
SDL_Renderer* renderer;

@includes+=
#include <iostream>

@init_graphics=
window = SDL_CreateWindow("Game of life",
  SDL_WINDOWPOS_UNDEFINED,
  SDL_WINDOWPOS_UNDEFINED,
  WIDTH, HEIGHT, SDL_WINDOW_ALLOW_HIGHDPI);

if(window == nullptr) {
  std::cerr << "ERROR(SDL_CreateWindow): " << SDL_GetError() << std::endl;
  return EXIT_FAILURE;
}

@deinit_graphics=
SDL_DestroyWindow(window);

@init_graphics+=
renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

if(renderer == nullptr) {
  std::cerr << "ERROR(SDL_CreateRenderer): " << SDL_GetError() << std::endl;
  return EXIT_FAILURE;
}

@deinit_graphics-=
SDL_DestroyRenderer(renderer);

@game_loop=
while(true) {
  @handle_events

  @handle_logic

  @clear_frame
  @draw_frame
  @flip_frame

  @idle_time
}

@handle_events=
SDL_Event event;
bool do_quit = false;
while(SDL_PollEvent(&event)) {
  switch(event.type) {
  case SDL_WINDOWEVENT:
    @handle_windowevent
    break;
  case SDL_MOUSEBUTTONDOWN:
    @handle_mousedown
    break;
  case SDL_MOUSEBUTTONUP:
    @handle_mouseup
    break;
  case SDL_MOUSEMOTION:
    @handle_mousemotion
    break;
  case SDL_KEYDOWN:
    @handle_keydown
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

@clear_frame=
SDL_SetRenderDrawColor(renderer, 0, 0, 0, SDL_ALPHA_OPAQUE);
SDL_RenderClear(renderer);

@flip_frame=
SDL_RenderPresent(renderer);

@includes+=
#include <vector>

@global_variables+=
const int GRID_SIZE = 25;
SDL_Texture* grid_texture = nullptr;

@init_graphics+=
grid_texture = SDL_CreateTexture(
    renderer, SDL_PIXELFORMAT_ARGB8888,
    SDL_TEXTUREACCESS_STREAMING,
    GRID_SIZE, GRID_SIZE);

@deinit_graphics-=
SDL_DestroyTexture(grid_texture);

@global_variables+=
std::vector<bool> cells;
std::vector<Uint32> pixels;

@includes+=
#include <algorithm>

@init_grid+=
cells.resize(GRID_SIZE*GRID_SIZE, false);
pixels.resize(GRID_SIZE*GRID_SIZE, 0);
std::fill(cells.begin(), cells.end(), false);
std::fill(pixels.begin(), pixels.end(), 0);

@global_variables+=
int mx, my;

@handle_mousemotion+=
mx = event.motion.x;
my = event.motion.y;

@handle_logic+=
Uint32 button = SDL_GetMouseState(NULL, NULL);
if(button & SDL_BUTTON(SDL_BUTTON_LEFT)) {
  @compute_cell_position
  @make_cell_alive
}

if(button & SDL_BUTTON(SDL_BUTTON_RIGHT)) {
  @compute_cell_position
  @make_cell_dead
}

@global_variables+=
int cur_width = WIDTH, cur_height = HEIGHT;

@handle_windowevent+=
if(event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED) {
  cur_width = event.window.data1;
  cur_height = event.window.data2;
  std::cout << "resize " << cur_width << " " << cur_height << std::endl;
}

@compute_cell_position+=
int cx = GRID_SIZE*mx/cur_width;
int cy = GRID_SIZE*my/cur_height;

@make_cell_alive+=
cells[cy*GRID_SIZE+cx] = true;

@make_cell_dead+=
cells[cy*GRID_SIZE+cx] = false;

@global_variables+=
SDL_PixelFormat* format = nullptr;

@init_graphics+=
format = SDL_AllocFormat(SDL_PIXELFORMAT_ARGB8888);

@handle_logic+=
Uint32 alive_color = SDL_MapRGBA(format, 255, 255, 255, SDL_ALPHA_OPAQUE);
Uint32 dead_color = SDL_MapRGBA(format, 0, 0, 0, SDL_ALPHA_OPAQUE);

for(int i=0; i<(int)cells.size(); ++i) {
  pixels[i] = cells[i] ? alive_color : dead_color;
}

SDL_UpdateTexture(grid_texture, NULL, pixels.data(), GRID_SIZE*sizeof(Uint32));

@draw_frame+=
SDL_RenderCopy(renderer, grid_texture, NULL, NULL);

@global_variables+=
int isFullscreen = false;

@handle_keydown+=
if(event.key.keysym.scancode == SDL_SCANCODE_F) {
  SDL_SetWindowFullscreen(window, isFullscreen ? 0 : SDL_WINDOW_FULLSCREEN_DESKTOP);
  isFullscreen = !isFullscreen;
}

@idle_time+=
SDL_Delay(1000/60);

@global_variables+=
bool simulation_running = false;

@handle_keydown+=
if(event.key.keysym.scancode == SDL_SCANCODE_SPACE) {
  simulation_running = !simulation_running;
}

@global_variables+=
int step_every = 10;
int cur_step = 0;

@handle_logic+=
if(simulation_running && cur_step++ >= step_every) {
  @step_simulation
  @copy_temporary_to_main_cells
  cur_step = 0;
}

@global_variables+=
std::vector<bool> tmp_cells;

@init_grid+=
tmp_cells.resize(GRID_SIZE*GRID_SIZE);

@step_simulation+=
for(int y=0; y<GRID_SIZE; ++y) {
  for(int x=0; x<GRID_SIZE; ++x) {
    @count_number_of_alive_neighbours
    @decide_fate_of_cell
  }
}

@count_number_of_alive_neighbours+=
int alive = 0;
for(int dy=-1; dy<=1; ++dy) {
  for(int dx=-1; dx<=1; ++dx) {
    @skip_center_cell
    int px = x+dx, py = y+dy;
    @wrap_around_if_out_of_bounds
    alive += (int)cells[py*GRID_SIZE+px];
  }
}

@skip_center_cell+=
if(dy == 0 && dx == 0) {
  continue;
}

@wrap_around_if_out_of_bounds+=
if(py == -1) { py = GRID_SIZE-1; }
if(py == GRID_SIZE) { py = 0; }
if(px == -1) { px = GRID_SIZE-1; }
if(px == GRID_SIZE) { px = 0; }

@decide_fate_of_cell+=
if(alive == 3) {
  tmp_cells[y*GRID_SIZE+x] = true;
}

else if(alive == 2) {
  tmp_cells[y*GRID_SIZE+x] = cells[y*GRID_SIZE+x];
}

else { // alive < 2 || alive > 3
  tmp_cells[y*GRID_SIZE+x] = false;
}

@copy_temporary_to_main_cells+=
std::copy(tmp_cells.begin(), tmp_cells.end(), cells.begin());

@handle_keydown+=
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
