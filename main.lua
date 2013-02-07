-----------------------------------------------------------
----    Hexa Sweeper TPE1 project
----    Pakoskyfrog 2013/02/04 15:03:59
-----------------------------------------------------------

math.randomseed(os.time())

------------------------
--  Dependencies
require "sources/apps"
require "sources/button"
require "sources/menu"
require "sources/actions"
require "sources/mainmenu"
require "sources/mainmenuBG"
require "sources/game"
require "sources/hud"
require "sources/gameBG"
require "sources/pausemenu"
require "sources/hexatile"
require "sources/hexagrid"

------------------------
--  INIT

------------------------
--  Löve callbacks
function love.load()
    Apps:load()
end

function love.keypressed(key)
    Apps:keypressed(key)
    
end

function love.mousepressed(x, y, button)
    Apps:mousepressed(x, y, button)
end

function love.keyreleased(key)
    Apps:keyreleased(key)
end

function love.mousereleased(x, y, button)
    Apps:mousereleased(x, y, button)
end

function love.draw()
    Apps:draw()
end

function love.update(dt)
    Apps:update(dt)
    
    -- framerate limiter
    if dt < 0.016 then  --60 FPS
        love.timer.sleep(0.016 - dt)
    end
end



