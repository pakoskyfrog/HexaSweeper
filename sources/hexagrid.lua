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
CHexaGrid.NMines = 0
CHexaGrid.NGoods = 0

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
    
    -- proto.diff = proto.diff or 'Normal'
    
    HexaGrid.ID = Apps:getNextID()
    HexaGrid.camera.orig = {0,0} -- screen center
    
    CHexaGrid.generateGrid(HexaGrid)
    CHexaGrid.initialized = false
    -- CHexaGrid.fillGrid(HexaGrid, proto.diff)
    -- CHexaGrid.annalyseGrid(HexaGrid)
    
    return HexaGrid
end


------------------------
--  Callbacks

function CHexaGrid:load()
    
    print "Grid loaded"
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
    if not self.initialized then
        self:initialize(u,v)
    end

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

function CHexaGrid:initialize(iu,iv)
    --------------------
    --  will init the grid with no bomb at init u,v
    self:fillGrid(self.parent.options.diff, iu,iv)
    self:annalyseGrid()
    self.parent.hud.minesLeft = self.NMines
    self.initialized = true
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

local function blanck(tile)
    --------------------
    --  will avoid the 1st click and die
    print('Blancking...')
    tile.content = 'void'
    tile.parent.NMines = tile.parent.NMines - 1
end
function CHexaGrid:fillGrid_classic(diff, iu,iv)
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
    
    local tile
    for m = 1, nbr do
        repeat
            local u,v
            repeat
                u = math.random(2*n)-n
                v = math.random(2*n)-n
            until math.abs(u+v) <= n
            tile = self.tileCollection[u..':'..v]
        until tile.content == 'void'
        
        tile.content = 'bomb'
    end
    
    tile = self.tileCollection[iu..':'..iv]
    if tile.content == 'bomb' then blanck(tile) end
end
function CHexaGrid:fillGrid_alchem(diff, iu,iv)
    --------------------
    --  This will fill the field with good and bad plants !
    
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
    local nbrb = math.floor(prob/100 * nt) -- number of bad plants  = prob * Ntotal
    local nbrg = math.floor(prob/200 * nt) -- number of good plants = prob/2 * Ntotal
    
    self.NMines = nbrb
    self.NGoods = nbrg
    self.NTiles = nt
    
    local tile
    for m = 1, nbrb do
        repeat
            local u,v
            repeat
                u = math.random(2*n)-n
                v = math.random(2*n)-n
            until math.abs(u+v) <= n
            tile = self.tileCollection[u..':'..v]
        until tile.content == 'void'
        
        tile.content = 'bomb' -- bad plant
    end
    
    tile = self.tileCollection[iu..':'..iv]
    if tile.content == 'bomb' then blanck(tile) end
    
    for m = 1, nbrg do
        local tile
        repeat
            local u,v
            repeat
                u = math.random(2*n)-n
                v = math.random(2*n)-n
            until math.abs(u+v) <= n
            tile = self.tileCollection[u..':'..v]
        until tile.content == 'void'
        
        tile.content = 'good' -- good plant
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
    return self:countVois('bomb',u,v)
end
function CHexaGrid:goodVois(u,v)
    return self:countVois('good',u,v)
end
function CHexaGrid:countVois(what,u,v)
    --------------------
    --  returns the count of trapped neighboors in the 6 arround
    local vois = self:getVois(u,v)
    local count = 0
    for i = 1, 6 do
        local tile = self.tileCollection[vois[i][1]..":"..vois[i][2]]
        if tile then
            if tile.content == what then count = count + 1 end
        end
    end
    
    return count
end


function CHexaGrid:annalyseGrid_classic()
    --------------------
    --  this function will calculate the repartition of the bombs and associates the counts to each tile
    
    for coords, tile in pairs(self.tileCollection) do
        tile.bombCount = self:trapedVois(tile.Vpos.u, tile.Vpos.v)
    end
end
function CHexaGrid:annalyseGrid_alchem()
    --------------------
    --  this function will calculate the repartition of the bombs and associates the counts to each tile
    
    for coords, tile in pairs(self.tileCollection) do
        tile.bombCount = self:trapedVois(tile.Vpos.u, tile.Vpos.v)
    end
    for coords, tile in pairs(self.tileCollection) do
        tile.goodCount = self:goodVois(tile.Vpos.u, tile.Vpos.v)
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

function CHexaGrid.setModes(mode)
    --------------------
    --  this will reassign the functions to match the playing mode
    if mode ~= 'Alchemist' then mode = 'Classic' end
    
    if mode == 'Alchemist' then
        CHexaTile.draw_count = CHexaTile.draw_count_alchem
        CHexaTile.draw_guess = CHexaTile.draw_guess_alchem
        
        CHexaGrid.annalyseGrid = CHexaGrid.annalyseGrid_alchem
        CHexaGrid.fillGrid     = CHexaGrid.fillGrid_alchem
    end
    
    if mode == 'Classic' then
        CHexaTile.draw_count = CHexaTile.draw_count_classic
        CHexaTile.draw_guess = CHexaTile.draw_guess_classic
        
        CHexaGrid.annalyseGrid = CHexaGrid.annalyseGrid_classic
        CHexaGrid.fillGrid     = CHexaGrid.fillGrid_classic
    end
end


------------------------
--  DEBUG funcs
if Apps.debug then
    
    function CHexaGrid:dumpCollection()
        --------------------
        --  command line displays
        for coords, tile in pairs(self.tileCollection) do
            print(tile)
        end
    end
    
    
end



print "CHexaGrid loaded"