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
    
    -- grid
    Game.grid = CHexaGrid:create()
    
    -- timer
    -- bg
    
    return Game
end


------------------------
--  Callbacks

function CGame:load() end

function CGame:draw()
    if self.Images.fde then
        love.graphics.setColor({255,255,255})
        love.graphics.draw(self.Images.fde, 0, 0)
    end
    
    -- if self.state then self.state:draw() end -- done in Apps:draw()
    
    self.grid:draw()
end

function CGame:update(dt)
    self.grid:update(dt)
end

function CGame:mousepressed(x, y, btn)
    self.grid:mousepressed(x, y, btn)
end

function CGame:keypressed(key)
    if key == 'escape' then
        if self.state then
            self.state = nil
        else
            -- generic code : Pause menu
            -- self.state = CGPause:create()
        end
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





print "CGame loaded"