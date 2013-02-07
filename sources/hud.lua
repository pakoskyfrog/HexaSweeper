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
    end
    
    Hud.time = 0
    
    Hud.menuBtn = CButton:create(Hud, 'Menu', 10, 10)
    Hud.menuBtn.hasBG = true
    Hud.menuBtn.onClick = function() 
        Apps.state.state = CPauseMenu:create()
    end
    Hud.menuBtn.colors.text = {200,200,200}
    Hud.menuBtn.colors.over = Apps.colors.white
    Hud.menuBtn.colors.bg   = {  0,  0,  0,200}
    
    return Hud
end


------------------------
--  Callbacks

function CHud:load()
    
end

function CHud:draw()
    lg = love.graphics

    -- timer
    do
        local m = math.floor(self.time/60)
        local s = math.floor(self.time -m*60)
        if s < 10 then s = '0'..s end
        local t = m .. ':' .. s
        
        lg.setFont(Apps.fonts.big)
        lg.setColor(Apps.colors.msgZone_Bg)
        local w,h = Apps.fonts.big:getWidth(t),Apps.fonts.big:getHeight(t)
        lg.rectangle('fill', 790-w,590-h, w,h)
        lg.setColor(Apps.colors.hud_front)
        lg.print(t, 790-w,590-h)
    end
    
    
    -- mines left
    do
        local s = tostring(self.minesLeft) .. ' / ' .. self.parent.grid.NMines
        lg.setFont(Apps.fonts.big)
        lg.setColor(Apps.colors.msgZone_Bg)
        local w,h = Apps.fonts.big:getWidth(s),Apps.fonts.big:getHeight(s)
        lg.rectangle('fill', 780-w,10, w,h)
        lg.setColor(Apps.colors.hud_front)
        lg.print(s, 780-w, 10)
    end
    
    -- buttons
    self.menuBtn:draw()
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




print "CHud loaded"