-- Pakoskyfrog 2013/02/06 22:44:36

-----------------------------------------------------------
----    CHud definition
-----------------------------------------------------------

------------------------
-- Description
--[[
    HUD of the game, displays every needed informations on screen
]]

-----------------------------------------------------------
------------------------
--  Init
CHud = {}
CHud.__index = CHud

------------------------
--  Properties
CHud.type = "CHud"
CHud.minesLeft = -1

------------------------
--  Constructor
function CHud:create(proto)
    local Hud = {}
    setmetatable(Hud, CHud)
    
    if not proto then proto = {} end
    
    Hud.ID = Apps:getNextID()
    Hud.parent = proto.sender or proto.parent or Apps.state or nil
    
    if Hud.parent then
        Hud.minesLeft = Hud.parent.grid.NMines
        Hud.goodsFound = 0
    end
    
    Hud.time = 0
    
    Hud.menuBtn = CButton:create(Hud, 'Menu', 20, 8)
    Hud.menuBtn.onClick = function() 
        Apps.state.state = CPauseMenu:create()
    end
    Hud.menuBtn.colors.text = {200,200,200}
    Hud.menuBtn.colors.over = Apps.colors.white
    Hud.menuBtn.selfFont    = love.graphics.newFont("gfx/menu3.ttf", 32)
    
    Hud.digitFont = love.graphics.newFont("gfx/menu3.ttf", 44)
    
    return Hud
end


------------------------
--  Callbacks

function CHud:load()
    self.imgs = {}
    self.imgs.btn1  = love.graphics.newImage("gfx/hudBtn1.png")
    self.imgs.bomb  = love.graphics.newImage("gfx/hudBomb.png")
    self.imgs.clock = love.graphics.newImage("gfx/hudClock.png")
    
    self.imgs.good  = self.parent.imgs.good
    self.imgs.bad   = self.parent.imgs.bad
    
    print("HUD loaded")
end

function CHud:draw()
    -- timer
    self:draw_timer()    
    
    -- mines left
    self:draw_mines()
    
    -- buttons
    love.graphics.setColor(Apps.colors.white)
    love.graphics.draw(self.imgs.btn1, 0, 0)
    self.menuBtn:draw()
end

local function formatCount(left, tot)
    return ' '..tostring(left) .. ' / ' .. tostring(tot) ..' '
end
function CHud:draw_mines_classic()
    lg = love.graphics
    lg.setFont(self.digitFont)
    
    local s = formatCount(self.minesLeft, self.parent.grid.NMines)
    local w,h = self.digitFont:getWidth(s), self.digitFont:getHeight(s)
    
    lg.setColor(Apps.colors.msgZone_Bg)
    lg.rectangle('fill', 780-w,10, w,h)
    
    lg.setColor(Apps.colors.hud_front)
    lg.print(s, 780-w, 10)
    
    lg.setColor(Apps.colors.white)
    lg.draw(self.imgs.bomb, 790-w-64, 0)
end
function CHud:draw_mines_alchem()
    lg = love.graphics
    lg.setFont(self.digitFont)
    
    -- bad plants
    do
        local s = formatCount(self.minesLeft, self.parent.grid.NMines)
        local w,h = self.digitFont:getWidth(s), self.digitFont:getHeight(s)
        local sx = 780-w
        lg.setColor(Apps.colors.msgZone_Bg)
        lg.rectangle('fill', sx,10, w,h)
        
        lg.setColor(Apps.colors.hud_front)
        lg.print(s, sx, 10)
        
        lg.setColor(Apps.colors.white)
        lg.draw(self.imgs.bad, sx-80, 0)
    end
    
    -- good plants
    do
        local s = formatCount(self.goodsFound, self.parent.grid.NGoods)
        local w,h = self.digitFont:getWidth(s), self.digitFont:getHeight(s)
        local sx = 530-w
        lg.setColor(Apps.colors.msgZone_Bg)
        lg.rectangle('fill', sx,10, w,h)
        
        lg.setColor(Apps.colors.hud_front)
        lg.print(s, sx, 10)
        
        lg.setColor(Apps.colors.white)
        lg.draw(self.imgs.good, sx-80, 0)
    end
end

function CHud:draw_timer()
    lg = love.graphics
    local m = math.floor(self.time/60)
    local s = math.floor(self.time -m*60)
    if s < 10 then s = '0'..s end
    local t = ' ' .. m .. ':' .. s .. ' '

    lg.setFont(self.digitFont)
    lg.setColor(Apps.colors.msgZone_Bg)
    local w,h = self.digitFont:getWidth(t),self.digitFont:getHeight(t)
    lg.rectangle('fill', 790-w,590-h, w,h)
    lg.setColor(Apps.colors.hud_front)
    lg.print(t, 790-w, 590-h)

    lg.setColor(Apps.colors.white)
    lg.draw(self.imgs.clock, 790-w-64, 595-64)
end


function CHud:update(dt)
    if not (self.parent.hasWon or self.parent.hasLost) then
        self.time = self.time + dt
    end
    self.menuBtn:update(dt)
end

function CHud:mousepressed(x, y, btn)
    return self.menuBtn:mousepressed(x, y, btn)
end

function CHud:keypressed(key)
    
end

function CHud:mousereleased(x, y, btn)
    
end

function CHud:keyreleased(key)
    
end

------------------------
--  Static functions


------------------------
--  Member functions
function CHud:getType()
    return self.type
end

function CHud.setModes(mode)
    --------------------
    --  this will reassign the functions to match the playing mode
    if mode ~= 'Alchemist' then mode = 'Classic' end
    
    if mode == 'Alchemist' then
        CHud.draw_mines = CHud.draw_mines_alchem
    end
    
    if mode == 'Classic' then
        CHud.draw_mines = CHud.draw_mines_classic
    end
end



print "CHud loaded"