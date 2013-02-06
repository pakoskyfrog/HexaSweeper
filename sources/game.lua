-- Pakoskyfrog 2013

-----------------------------------------------------------
----    CGame definition
-----------------------------------------------------------

------------------------
-- Description
--[[
    The game, as a state of application.
]]

-----------------------------------------------------------
------------------------
--  Init
CGame = {}
CGame.__index = CGame

CGame.Images = {}
-- CGame.Images.fde = love.graphics.newImage("gfx/fde.png")


------------------------
--  Properties
CGame.type = "CGame"


------------------------
--  Constructor
function CGame:create(proto)
    local Game = {}
    setmetatable(Game, CGame)
    
    if not proto then proto = {} end
    
    -- options
    
    -- HUD
    
    -- grid
    Game.grid = CHexaGrid:create({sender=Game, diff=proto.diff, size=proto.size})
    
    -- timer
    -- bg
    
    CGame.load(Game)
    return Game
end


------------------------
--  Callbacks

function CGame:load()
    -- Ressources : Pictures
    self.imgs = {}
    self.imgs.interro = love.graphics.newImage("gfx/interro.png")
    self.imgs.bomb    = love.graphics.newImage("gfx/bomb.png")
    
    
    print('Game loaded')
end

function CGame:draw()
    if self.Images.fde then
        love.graphics.setColor({255,255,255})
        love.graphics.draw(self.Images.fde, 0, 0)
    end
    
    -- if self.state then self.state:draw() end -- done in Apps:draw()
    
    
    self.grid:draw()
    
    -- TEST : the big scan
    if love.keyboard.isDown('v') then
        local d = 5
        love.graphics.setPointSize( d )
        for x = 5, 795, d do
            for y = 5, 595, d do
                local u,v = self:screenTouv(x,y)
                love.graphics.setColor((u+16)*40,(v+16)*40,0)
                love.graphics.point(x,y)
            end
        end
        
    end
end

function CGame:update(dt)
    self.grid:update(dt)
end

function CGame:mousepressed(x, y, btn)
    local u,v = self:screenTouv(x,y)
    print(btn,' : x,y =',x,y,' : u,v =',u,v)
    self.grid:mousepressed(u, v, btn)
end

function CGame:keypressed(key)
    if key == 'escape' then
        if self.state then
            self.state = nil
        else
            -- generic code : Pause menu
            -- self.state = CGPause:create()
            
            -- tmp
            Actions.activateMainMenu()
        end
    end
    
    -- tmp / should call a set func
    if key == 'kp-' then
        self.grid.zoomFactor = self.grid.zoomFactor * 0.5
        self.grid:updateTilePositions()
    end
    if key == 'kp+' then
        self.grid.zoomFactor = self.grid.zoomFactor * 2
        self.grid:updateTilePositions()
    end
    
    
end

function CGame:mousereleased(x, y, btn)
    
end

function CGame:keyreleased(key)
    
end

------------------------
--  Static functions

------------------------
--  Gets / Sets
function CGame:getType() return self.type end

------------------------
--  Member functions

function CGame:screenTouv(sx,sy)
    --------------------
    --  convert a screen coord into the grid coords system : x,y -> u,v
    --  it is not a change of base since u,v generate a vectorial space by parallelograms
    local round = function(num, idp)
        local mult = 10^(idp or 0)
        if num >= 0 then
            return math.floor(num * mult + 0.5) / mult
        else
            return math.ceil(num * mult - 0.5) / mult
        end
    end
    
    local s3  = math.sqrt(3)
    local z   = self.grid.zoomFactor      -- zoom
    local r   = CHexaTile.radius         -- radius
    local a   = 0.5 * r * s3            -- appex = 1/2 length of base vectors
    --local b   = math.pi / 3
    
    -- shifts + orig(400,300)
    sx = sx - (self.grid.camera.orig[1]+400)
    sy = sy - (self.grid.camera.orig[2]+300)
    
    -- zoom
    sx = sx / z
    sy = sy / z
    
    -- xy -> uv
    local f = 3 * r * sy
    local g = 2 * a * sx
    local h = 6 * a * r
    local ua, va = (-f+g)/h, (f+g)/h -- floating u v
    local u,v = round(ua), round(va) -- integer u v
    
    -- hexa edges cutting :
    -- hexagonal lattice are a regular voronoi graph, you click in the hexagon witch its center is the closest to you
    -- to obtain our (u,v) in hexagonal grid instead of a parallelogram one
    -- we use the 1st approx and estimate the nearest hexaTile among the (u,v) + its 6 neighboors
    
    local vois  = self.grid:getVois(u,v)
    vois[7] = {u,v}
    
    local dist = {}
    local dmin = 999
    local dind = 0
    for i = 1, 7 do
        local uu, vv = vois[i][1], vois[i][2] -- tested coords
        
        -- distance
        local beta = -math.pi/6
        local zmu = {(ua-uu)*math.cos(beta), (ua-uu)*math.sin(beta)}
        
        local theta = math.pi/6
        local zmv = {(va-vv)*math.cos(theta), (va-vv)*math.sin(theta)}
        
        local zm = {zmu[1]+zmv[1], zmu[2]+zmv[2]}
        dist[i] = math.sqrt(zm[1]*zm[1] + zm[2]*zm[2])

        -- comparisons
        if dist[i] < dmin then
            dmin = dist[i]
            dind = i
        end
    end
    u = vois[dind][1]
    v = vois[dind][2]
    
    -- preventing -0 (negative integer zeros)
    if u > -1 then u = math.abs(u) end
    if v > -1 then v = math.abs(v) end
    
    return u,v
end




print "CGame loaded"