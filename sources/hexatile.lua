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
CHexaTile.type    = "CHexaTile"
CHexaTile.content = 'void' -- can be 'bomb' or whaterver is needed for gamemodes
CHexaTile.guess   = 'none' -- it's what the user supposes the tile is, cycled by right click
CHexaTile.guesses = {'none','bomb','interro'}
CHexaTile.radius  = 20
CHexaTile.discovered = false
CHexaTile.font    = love.graphics.newFont("gfx/menu3.ttf", 26)
CHexaTile.goodCount = 0

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
    
    -- a tile can be : 
        -- content = void,  no trapped neighboor
        -- content = void,  trapped neighboors
        -- content = any, undiscovered
        -- content = any, trapped discovered
        -- content = any, interrogation
    
    love.graphics.setLineWidth(2)
    
    if self.discovered or (Apps.state.hasLost or Apps.state.hasWon) then
        lg.setColor(Apps.colors.gray)
        if self.content == 'bomb' then lg.setColor(Apps.colors.red) end
        lg.circle('fill', self.pos.x, self.pos.y, self.radius * z, 6)
        lg.setColor(Apps.colors.white)
        lg.circle('line', self.pos.x, self.pos.y, self.radius * z, 6)
        
        self:draw_count()
    else
        lg.setColor({ 50, 50, 50})
        lg.circle('fill', self.pos.x, self.pos.y, self.radius * z, 6)
    end
    
    -- guesses :
    if not (self.guess == 'none') then
        self:draw_guess(z)
    end
    
    lg.setColor(Apps.colors.white)
    lg.circle('line', self.pos.x, self.pos.y, self.radius * z, 6)
end

function CHexaTile:draw_count_classic()
    --------------------
    --  this will display the number of bombs around
    local b = self.bombCount or 0
    if self.content == 'void' and b>0 then
        lg.setFont(self.font)
        lg.setColor(Apps.dangerColors[b])
        local shx = 0
        if b == 1 then shx = 5 end
        lg.print(tostring(b), self.pos.x -8 +shx, self.pos.y -13)
    end
end
function CHexaTile:draw_count_alchem()
    --------------------
    --  this will display the number of good/bad plants around
    local b = self.bombCount or 0
    local g = self.goodCount or 0
    if self.content == 'void' and (b>0 or g>0) then
        lg.setFont(self.font)
        
        local col
        if b>0 and g>0 then
            lg.setColor(Apps.colors.yellow)
        elseif b>0 then
            lg.setColor(Apps.colors.red)
        else
            lg.setColor(Apps.colors.green)
        end
        
        local shx = 0
        if (b+g) == 1 then shx = 5 end
        lg.print(tostring(b+g), self.pos.x -8 +shx, self.pos.y -13)
    end
end

function CHexaTile:draw_guess_classic(z)
    --------------------
    --  this will display the guesses of the player
    local pic = self.parent.parent.imgs[self.guess]
    if pic then
        lg.setColor(Apps.colors.white)
        love.graphics.draw(pic, self.pos.x -12*z, self.pos.y -14*z, 0, 0.25*z, 0.25*z)
    end
end
function CHexaTile:draw_guess_alchem(z)
    --------------------
    --  this will display the guesses of the player
    local pic = self.parent.parent.imgs[self.guess]
    if self.guess == 'bomb' then
        pic = self.parent.parent.imgs['bad']
    end
    
    if pic then
        lg.setColor(Apps.colors.white)
        love.graphics.draw(pic, self.pos.x -11*z, self.pos.y -14*z, 0, 0.26*z, 0.26*z)
    end
end


function CHexaTile:update(dt)
    
end

function CHexaTile:mousepressed(u, v, btn)
    
end

function CHexaTile:keypressed(key)
    
end

function CHexaTile:mousereleased(u, v, btn)
    
end

function CHexaTile:keyreleased(key)
    
end

------------------------
--  Static functions


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

function CHexaTile:getVois()
    --------------------
    --  Returns the list of its neighboors
    
    return self.parent:getVois(self.Vpos.u, self.Vpos.v)
end

function CHexaTile:nextGuess()
    --------------------
    --  This function will cycle through the guesses possibilities
    if self.discovered then return false end
    
    for index, value in ipairs(self.guesses) do
        if self.guess == value then
            local hud = Apps.state.hud
            
            if self.guess == 'bomb' then
                hud.minesLeft = hud.minesLeft +1
            end
            
            local ind = math.mod(index, #self.guesses)+1 -- 1..max
            self.guess = self.guesses[ind]
            
            if self.guess == 'bomb' then
                hud.minesLeft = hud.minesLeft -1
            end
            
            return true
        end
    end
    
    return true
end

function CHexaTile:activate() -- = click
    --------------------
    --  Activation of the tile, determined by its status
    if self.guess ~= 'none' then return true, 'flagged' end
    if self.discovered then return true, 'done' end
    if self.content == 'bomb' then
        -- BOOM you died
        self.discovered = true
        print('BOOM')
        return false, 'boom'
    elseif self.content == 'good' then
        -- find one ! >Alchemist mode<
        Apps.state.hud.goodsFound = Apps.state.hud.goodsFound + 1
        
        -- update self and neighbors
        self.content = 'void'
        self.discovered = true
        
        local vois = self:getVois()
        for i = 1, 6 do
            local tile = self.parent.tileCollection[vois[i][1]..":"..vois[i][2]]
            if tile then
                tile.goodCount = tile.goodCount - 1
            end
        end
        for i = 1, 6 do
            local tile = self.parent.tileCollection[vois[i][1]..":"..vois[i][2]]
            if tile then
                -- empty tile : has to done after actualizing the count
                if (tile.goodCount + tile.bombCount == 0) and (tile.content == 'void') and (tile.discovered) then
                    -- print(vois[i][1]..":"..vois[i][2]..' activate from VOID empty tile gC=' .. tile.goodCount .. ' bC='..tile.bombCount)
                    tile.discovered = false
                    tile:activate()
                end
                if (self.goodCount + self.bombCount == 0) then
                    -- print(vois[i][1]..":"..vois[i][2] ..' activate from SELF empty tile gC=' .. self.goodCount .. ' bC='..self.bombCount)
                    tile.discovered = false
                    tile:activate()
                end
            end
        end
        
        -- triger animation
        Apps.state:addAnimGood({pos={x=self.pos.x, y=self.pos.y}})
        
        return true, 'good'
    elseif self.content == 'void' then
        self.discovered = true
        
        -- has neighbors ?
        if (self.bombCount + self.goodCount == 0) then
            -- chain reaction, nothing arround, you can click arround
            local vois = self:getVois()
            for i = 1, 6 do
                local tile = self.parent.tileCollection[vois[i][1]..":"..vois[i][2]]
                if tile then
                    -- print(vois[i][1]..":"..vois[i][2] .. ' activate from VOID gC=' .. self.goodCount .. ' bC='..self.bombCount)
                    -- tile.discovered = false
                    tile:activate()
                end
            end
            
        end
        
        return true, 'void'
    end
    
    return true, 'error'
end


------------------------
--  DEBUG funcs
if Apps.debug then
    
    function CHexaTile:__tostring()
        --------------------
        --  command line displays
        return self.ID .. ']=' .. self.Vpos.u..':'..self.Vpos.v .. ' /' .. self.content .. '/ d='..tostring(self.discovered)
    end
    
    
end

------------------------
--  Execs



print "CHexaTile loaded"