describe("tmux.layout.parse", function()
  local parse = require("tmux.layout.parse")

  it("returns nil for empty string", function()
    assert.is_nil(parse.parse(""))
  end)

  it("returns nil for nil input", function()
    assert.is_nil(parse.parse(nil))
  end)

  it("parses single pane layout", function()
    -- Format: checksum,WxH,0,0{pane_layout}
    -- Pane layout: WxH,x,y,id
    local layout_str = "d5e0,200x50,0,0,0"
    local result = parse.parse(layout_str)

    assert.is_not_nil(result)
    assert.are.equal(200, result.width)
    assert.are.equal(50, result.height)
    assert.are.equal(1, #result.panes)
    assert.are.same({
      id = 0,
      x = 0,
      y = 0,
      width = 200,
      height = 50,
    }, result.panes[1])
  end)

  it("parses two vertical panes", function()
    -- Two panes side by side: left (100x50 at 0,0 id=0) and right (99x50 at 101,0 id=1)
    local layout_str = "d5e0,200x50,0,0{100x50,0,0,0,99x50,101,0,1}"
    local result = parse.parse(layout_str)

    assert.is_not_nil(result)
    assert.are.equal(200, result.width)
    assert.are.equal(50, result.height)
    assert.are.equal(2, #result.panes)

    assert.are.equal(0, result.panes[1].id)
    assert.are.equal(0, result.panes[1].x)
    assert.are.equal(100, result.panes[1].width)

    assert.are.equal(1, result.panes[2].id)
    assert.are.equal(101, result.panes[2].x)
    assert.are.equal(99, result.panes[2].width)
  end)

  it("parses two horizontal panes", function()
    -- Two panes stacked: top (200x24 at 0,0 id=0) and bottom (200x25 at 0,25 id=1)
    local layout_str = "d5e0,200x50,0,0[200x24,0,0,0,200x25,0,25,1]"
    local result = parse.parse(layout_str)

    assert.is_not_nil(result)
    assert.are.equal(2, #result.panes)

    assert.are.equal(0, result.panes[1].id)
    assert.are.equal(0, result.panes[1].y)
    assert.are.equal(24, result.panes[1].height)

    assert.are.equal(1, result.panes[2].id)
    assert.are.equal(25, result.panes[2].y)
    assert.are.equal(25, result.panes[2].height)
  end)

  it("parses three panes in complex layout", function()
    -- Left pane, then right side split top/bottom
    local layout_str = "d5e0,200x50,0,0{100x50,0,0,0,99x50,101,0[99x24,101,0,1,99x25,101,25,2]}"
    local result = parse.parse(layout_str)

    assert.is_not_nil(result)
    assert.are.equal(3, #result.panes)
    assert.are.equal(0, result.panes[1].id)
    assert.are.equal(1, result.panes[2].id)
    assert.are.equal(2, result.panes[3].id)
  end)
end)
