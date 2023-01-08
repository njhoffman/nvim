local my_image = require('hologram.image'):new({
  source = '/Users/..../Documents/my-image.png',
  row = 11,
  col = 0,
})

my_image:transmit() -- send image data to terminal

-- Move image 5 rows down after 1 second
vim.defer_fn(function()
  my_image:move(15, 0)
  my_image:adjust() -- must adjust to update image
end, 1000)

-- Crop image to 100x100 pixels after 2 seconds
vim.defer_fn(function()
  my_image:adjust({
    crop = { 100, 100 },
  })
end, 2000)

-- Resize image to 75x50 pixels after 3 seconds
vim.defer_fn(function()
  my_image:adjust({
    area = { 75, 50 },
  })
end, 3000)
-- Image:new(opts)
-- Image:new({
--     source  = -- specifies path of image data
--     buf     = -- buf to display in, default: current buffer
--     row     = -- row to display at, default: cursor row
--     col     = -- col to display at, default: cursor col
-- })
-- Image:transmit(opts)
-- Image:transmit({
--     medium = 'direct' | 'file' | 'temp_file' | 'shared' -- default: 'direct'
--     format = 24 | 32 | 100 -- default: 32
--     height = -- specify pixel height of image. (optional)
--     width  = -- specify pixel width of image. (optional)
--     hide   = -- do not display image immediately after transmission, default: false
-- })
-- Image:adjust(opts)
-- Every image can be displayed an arbitrary number of times on the screen, with different adjustments applied. These operations do not require the re-transmission of image data and are as a result very fast and lightweight. There should be no flicker or delay after an adjustment is made.

-- Image:adjust({
--     z_index = -- vert. stacking order of the image, a negative z_index will draw below text. (default: 0).
--     crop    = {x_px, y_px} -- pixel region to crop image to, with top left anchored. (optional)
--     area    = {cols, rows} -- cell region to display image over, will stretch/squash if necessary. (optional)
--     edge    = {left_px, top_px} -- pixel coords to treat as top left of image. will cause crash if edge > img size. (optional)
--     offset  = {xoff_px, yoff_px} -- pixel coords within first cell to begin displaying image, must be smaller than cell size. (optional)
-- })
-- Image:delete(id, opts)
-- Deletes the image and all that satisfy requirements in opts. Images deleted via 'opts' will not have their extmarks removed.

-- Image:delete(id, {
--     free    = true | false -- when deleting image, free stored image data and also extmark of image. (default: false)
--     all     = true | false -- del. all images. (default: false)
--     z_index = -- del. images that have the specified z-index.
--     col     = -- del. images that intersect the specified column.
--     row     = -- del. images that intersect the specified row.
--     cell    = {col, row} -- del. images that intersect the specified cell
-- })
-- Image:identify()
-- Run an ImageMagick job to find info about image, e.g: height, width

-- Image:move(row, col)
-- Sets location by moving the extmark associated with the image.

-- Image:pos()
-- Returns position of image (via its extmark).

-- Image:buf()
-- Returns buf. number of image.

-- Image:ext()
-- Returns extmark id of image.
