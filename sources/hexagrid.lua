-- Pakoskyfrog 2013/02/05 13:09:13

-----------------------------------------------------------
----    CHexaGrid definition
-----------------------------------------------------------

------------------------
-- Description
--[[
    Hexagonal grid with a vector refenrential as (u,v) = pi/3
    contains a CHexaTile collection
]]

-----------------------------------------------------------
------------------------
--  Init
CHexaGrid = {}
CHexaGrid.__index = CHexaGrid

------------------------
--  Properties
CHexaGrid.type = "CHexaGrid"
CHexaGrid.zoomFactor = 1
CHexaGrid.camera = {}
CHexaGrid.camera.orig = {0,0} -- screen center


------------------------
--  Constructor
function CHexaGrid:create(proto)
    local HexaGrid = {}
    setmetatable(HexaGrid, CHexaGrid)
    
    if not proto then proto = {} end
    
    if proto.sender or proto.parent then HexaGrid.parent = proto.sender or proto.parent end
    
    proto.size = proto.size or 'Small'
    if proto.size == 'Small' then HexaGrid.width = 10
    elseif proto.size == 'Normal' then HexaGrid.width = 20
    elseif proto.size == 'Big' then HexaGrid.width = 30
    end
    
    proto.diff = proto.diff or 'Normal'
    
    HexaGrid.ID = Apps:getNextID()
    
    
    CHexaGrid.generateGrid(HexaGrid)
    CHexaGrid.fillGrid(HexaGrid, proto.diff)
    CHexaGrid.annalyseGrid(HexaGrid)
    
    return HexaGrid
end


------------------------
--  Callbacks

function CHexaGrid:load()
    
end

function CHexaGrid:draw()
    for coords, tile in pairs(self.tileCollection) do
        tile:draw()
    end
end

function CHexaGrid:update(dt)
    -- for coords, tile in pairs(self.tileCollection) do
        -- tile:update(dt)
    -- end
    
    -- camera sliding
    local h = (1+self.width*2) * CHexaTile.radius * self.zoomFactor
    local w = 4/3 * h
    
    if h > 600 then
        local x = love.mouse.getX()
        local y = love.mouse.getY()
        
        self.camera.orig[1] = -(w-800)*(x-400)/400
        self.camera.orig[2] = -(h-600)*(y-300)/300
        
        self:updateTilePositions()
    end
    
end

function CHexaGrid:mousepressed(u, v, btn)
    local tile = self.tileCollection[u..":"..v]
    if tile == nil then return end
    
    if btn == 'l' then
        -- left click on the tile at (u,v)
        -- activate the tile
        if not (tile.guess == 'none') then return end
        if not tile:activate() then
            -- BOOM
            print('you died (l)')
            self.parent:lost()
        end
        
    elseif btn == 'm' then
        -- middle click on the tile at (u,v)
        -- activate the tile and all the others around which are not flagged
        if not (tile.guess == 'none') then return end
        if not tile:activate() then
            -- BOOM
            print('you died (m)')
            self.parent:lost()
        end
        local vois = tile:getVois()
        for i = 1, 6 do
            local vtile = self.tileCollection[vois[i][1]..":"..vois[i][2]]
            if vtile and vtile.guess == 'none' then
                if not vtile:activate() then
                    -- BOOM
                    print('you died (vm)')
                    self.parent:lost()
                end
            end
        end
        
    elseif btn == 'r' then
        -- right click on the tile at (u,v)
        -- flag dropping cycle : (nothing, bomb, interrogation)
        
        tile:nextGuess()
        print('tile at '..u..":"..v..' guess = '..tile.guess)
    end
end

function CHexaGrid:keypressed(key)
    
end

function CHexaGrid:mousereleased(u, v, btn)
    
end

function CHexaGrid:keyreleased(key)
    
end

------------------------
--  Static functions
function CHexaGrid.setZoomFactor(z)
    if z <= 0 then return end
    CHexaGrid.zoomFactor = z
end

function CHexaGrid.shiftCamera(dx,dy)
    CHexaGrid.camera.orig[1] = CHexaGrid.camera.orig[1] + dx
    CHexaGrid.camera.orig[2] = CHexaGrid.camera.orig[2] + dy
end

------------------------
--  Member functions
function CHexaGrid:getType()
    return self.type
end

function CHexaGrid:generateGrid()
    --------------------
    --  will generate the hexagonal game arena
    
    local dir = {{-1,1},{-1,0},{0,-1},{1,-1},{1,0},{0,1}}
    local center = CHexaTile:create({sender=self,u=0,v=0})
    local collection = {}
    collection['0:0'] = center
    
    for i = 1, self.width/2 do
        -- adds a corrona around
        -- print('corrona n='..i)
        local u,v = i,0
        for j = 1, 6 do
            -- for each hex direction
            -- print('    dir '..j..' ='..dir[j][1]..':'..dir[j][2])
            for k = 1, i do
                -- print('        pop at '..u..':'..v)
                collection[u..':'..v] = CHexaTile:create({sender=self,u=u,v=v})
                u = u + dir[j][1]
                v = v + dir[j][2]
            end
            
        end
        
    end
    
    self.tileCollection = collection
    self:updateTilePositions()
end

function CHexaGrid:fillGrid(diff)
    --------------------
    --  This will fill the field with bombs !
    
    local prob -- percentage of field covered by mines
    if diff == 'Trivial' then
        prob = 5
    elseif diff == 'Easy' then
        prob = 10
    elseif diff == 'Tricky' then
        prob = 25
    elseif diff == 'Impossible' then
        prob = 40
    else -- 'Normal'
        prob = 18
    end
    
    local n=self.width/2
    local nt = (1+6*(n*(n+1)/2))
    local nbr = math.floor(prob/100 * nt) -- number of mines = prob * Ntotal
    self.NMines = nbr
    self.NTiles = nt
    
    for m = 1, nbr do
        local tile
        repeat
            local u,v
            repeat
                u = math.random(2*n)-n
                v = math.random(2*n)-n
            until math.abs(u+v) <= n
            if Apps.debug then print('bomb placed at '..u..':'..v) end
            tile = self.tileCollection[u..':'..v]
        until tile.content == 'void'
        tile.content = 'bomb'
    end
    
end

function CHexaGrid:updateTilePositions()
    --------------------
    --  this will calculate tile screen position according to (u,v,z)
    
    -- optimisation can be achieve using values of cos(pi/6)=sqrt(3)/2 and sin(pi/6)=1/2
    
    local z = self.zoomFactor      -- zoom
    local r = CHexaTile.radius * z -- radius
    local a2 = r * math.sqrt(3) -- appex *2
    local b = math.pi / 3
    
    -- norm verctors in x,y coords
    -- local u = {a2, 0}
    -- local v = {a2*math.cos(b), a2*math.sin(b)}
    local u = {a2*math.cos(b/2), -a2*math.sin(b/2)}
    local v = {a2*math.cos(b/2),  a2*math.sin(b/2)}
    
    local ox = CHexaGrid.camera.orig[1] + 400
    local oy = CHexaGrid.camera.orig[2] + 300
    
    for coords, tile in pairs(self.tileCollection) do
        tile.pos.x = ox + tile.Vpos.u * u[1] + tile.Vpos.v * v[1]
        tile.pos.y = oy + tile.Vpos.u * u[2] + tile.Vpos.v * v[2]
    end
end

function CHexaGrid:getVois(u,v)
    --------------------
    --  returns the list of the 6 neighboors (2D array)
    return {
                { 1+u,-1+v},
                { 1+u, 0+v},
                { 0+u, 1+v},
                {-1+u, 1+v},
                {-1+u, 0+v},
                { 0+u,-1+v},
           }
end

function CHexaGrid:trapedVois(u,v)
    --------------------
    --  returns the count of trapped neighboors in the 6 arround
    local vois = self:getVois(u,v)
    local count = 0
    for i = 1, 6 do
        local tile = self.tileCollection[vois[i][1]..":"..vois[i][2]]
        if tile then
            if tile.content == 'bomb' then count = count + 1 end
        end
    end
    
    return count
end

function CHexaGrid:annalyseGrid()
    --------------------
    --  this function will calculate the repartition of the bombs and associates the counts to each tile
    
    for coords, tile in pairs(self.tileCollection) do
        tile.bombCount = self:trapedVois(tile.Vpos.u, tile.Vpos.v)
    end
end

function CHexaGrid:zoomIn()
    CHexaGrid.setZoomFactor(self.zoomFactor * 1.1)
    self:updateTilePositions()
end
function CHexaGrid:zoomOut()
    CHexaGrid.setZoomFactor(self.zoomFactor * 0.9)
    self:updateTilePositions()
end


------------------------
--  DEBUG funcs
if Apps.debug then
    
    function CHexaGrid:dumpCollection()
        --------------------
        --  command line displays
        for coords, tile in pairs(self.tileCollection) do
            print(tile:toString())
        end
    end
    
    
end



print "CHexaGrid loaded"