-- Pakoskyfrog 2013/02/05 12:50:19

-----------------------------------------------------------
----    CHexaTile definition
-----------------------------------------------------------

------------------------
-- Description
--[[
    Element of CHexaGrid, represents a single hexagon and contains all needed informations.
]]

-----------------------------------------------------------
------------------------
--  Init
CHexaTile = {}
CHexaTile.__index = CHexaTile

------------------------
--  Properties
CHexaTile.type = "CHexaTile"
CHexaTile.content = 'void' -- con be 'bomb' or whaterver is needed for gamemodes
-- CHexaTile.hexaCoords = {}
CHexaTile.radius = 10
CHexaTile.discovered = false

------------------------
--  Constructor
function CHexaTile:create(proto)
    local HexaTile = {}
    setmetatable(HexaTile, CHexaTile)
    
    if not proto then proto = {} end
    if not proto.pos then HexaTile.pos = {x=0,y=0} end
    if not proto.Vpos then HexaTile.Vpos = {u=0,v=0} end
    
    if proto.content then HexaTile.content = proto.content end
    if proto.sender or proto.parent then HexaTile.parent = proto.sender or proto.parent end
    if proto.pos then HexaTile.pos = {x=proto.pos.x or 0, y=proto.pos.y or 0} end
    if proto.x or proto.y then HexaTile.pos = {x=proto.x or 0, y=proto.y or 0} end
    if proto.Vpos then HexaTile.Vpos = {u=proto.pos.u or 0, v=proto.pos.v or 0} end
    if proto.u or proto.v then HexaTile.Vpos = {v=proto.v or 0, u=proto.u or 0} end
    
    HexaTile.ID = Apps:getNextID()
    
    return HexaTile
end


------------------------
--  Callbacks

function CHexaTile:load()
    
end

function CHexaTile:draw()
    local z = self.parent.zoomFactor or 1
    local lg = love.graphics
    
    --===========================
    --  == dev temp code lines ==
    
    -- just draw a circle
    lg.setColor(Apps.colors.gray)
    if self.content == 'bomb' then lg.setColor(Apps.colors.red) end -- discovered ?
    lg.circle('fill', self.pos.x, self.pos.y, 2*self.radius * z, 6)
    lg.setColor(Apps.colors.white)
    lg.circle('line', self.pos.x, self.pos.y, 2*self.radius * z, 6)
    
    --===========================
end

function CHexaTile:update(dt)
    
end

function CHexaTile:mousepressed(x, y, btn)
    
end

function CHexaTile:keypressed(key)
    
end

function CHexaTile:mousereleased(x, y, btn)
    
end

function CHexaTile:keyreleased(key)
    
end

------------------------
--  Static functions
-- function CHexaTile.updateHexaCoords(zoom)
    -- --------------------
    -- --  This function will recalculate the reference coordinates of the hexagons
    -- -- CHexaTile.hexaCoords
    
    -- local pi = math.pi
    -- local piOver3 = pi / 3
    -- local r = CHexaTile.radius
    -- local a = 0 -- alpha
    
    -- for i = 1, 6 do
        -- local x = r * math.cos(a)
        -- local y = r * math.sin(a)
        -- CHexaTile.hexaCoords[i] = {x,y}
        -- a = a + piOver3
    -- end

-- end

function CHexaTile.setRadius(r)
    --------------------
    --  this will set the static radius of a tile
    if r <= 0 then return end
    CHexaTile.radius = r
end


------------------------
--  Member functions
function CHexaTile:getType()
    return self.type
end

------------------------
--  DEBUG funcs
if Apps.debug then
    
    function CHexaTile:toString()
        --------------------
        --  command line displays
        return self.ID .. '=' .. self.Vpos.u..':'..self.Vpos.v .. ' ' .. self.content
    end
    
    
end

------------------------
--  Execs
-- CHexaTile.updateHexaCoords(1)


print "CHexaTile loaded"