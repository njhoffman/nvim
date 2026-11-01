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

  it("tolerates the trailing newline from display-message", function()
    local result = parse.parse("d5e0,200x50,0,0,7\n")
    assert.is_not_nil(result)
    assert.are.equal(7, result.panes[1].id)
  end)

  describe("JSON layout (tmux next-3.9+)", function()
    it("parses two side-by-side panes using the %id as pane id", function()
      local layout_str = '{"V":2,"L":{"t":"h","w":365,"h":86,"x":0,"y":0,"c":['
        .. '{"t":"p","w":182,"h":86,"x":0,"y":0,"a":true,"i":1,"I":"%11"},'
        .. '{"t":"p","w":182,"h":86,"x":183,"y":0,"l":0,"i":2,"I":"%12"}]}}\n'
      local result = parse.parse(layout_str)

      assert.is_not_nil(result)
      assert.are.equal(365, result.width)
      assert.are.equal(86, result.height)
      assert.are.equal(2, #result.panes)
      assert.are.same({ id = 11, x = 0, y = 0, width = 182, height = 86 }, result.panes[1])
      assert.are.same({ id = 12, x = 183, y = 0, width = 182, height = 86 }, result.panes[2])
    end)

    it("parses a single pane window", function()
      local result = parse.parse('{"V":2,"L":{"t":"p","w":200,"h":50,"x":0,"y":0,"I":"%3"}}')
      assert.is_not_nil(result)
      assert.are.equal(1, #result.panes)
      assert.are.equal(3, result.panes[1].id)
      assert.are.equal(200, result.width)
    end)

    it("walks nested splits in order", function()
      local layout_str = '{"V":2,"L":{"t":"h","w":200,"h":50,"x":0,"y":0,"c":['
        .. '{"t":"p","w":100,"h":50,"x":0,"y":0,"I":"%1"},'
        .. '{"t":"v","w":99,"h":50,"x":101,"y":0,"c":['
        .. '{"t":"p","w":99,"h":24,"x":101,"y":0,"I":"%2"},'
        .. '{"t":"p","w":99,"h":25,"x":101,"y":25,"I":"%3"}]}]}}'
      local result = parse.parse(layout_str)

      assert.is_not_nil(result)
      assert.are.equal(3, #result.panes)
      assert.are.equal(3, result.panes[3].id)
      assert.are.equal(25, result.panes[3].y)
    end)

    it("returns nil for malformed JSON", function()
      assert.is_nil(parse.parse('{"V":2,"L":'))
    end)

    it("returns nil when the tree has no panes", function()
      assert.is_nil(parse.parse('{"V":2,"L":{"t":"h","w":10,"h":10,"x":0,"y":0,"c":[]}}'))
    end)
  end)
end)
