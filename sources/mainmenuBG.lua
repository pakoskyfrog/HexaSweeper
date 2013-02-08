-- Pakoskyfrog 2013/02/04 16:44:43

-----------------------------------------------------------
----    CBackground definition
-----------------------------------------------------------

------------------------
-- Description
--[[
    Main Menu background, mine fields and trees.
]]

-----------------------------------------------------------
------------------------
--  Init
CBackground = {}
CBackground.__index = CBackground

------------------------
--  Properties
CBackground.type = "CBackground"


------------------------
--  Constructor
function CBackground:create()
    local Background = {}
    setmetatable(Background, CBackground)
    
    Background.ID = Apps:getNextID()
    
    Background.shift = 0
    Background.imgs = {}
    Background.clouds = {}
    
    return Background
end


------------------------
--  Callbacks

function CBackground:load()
    -- loads
    self.imgs.fde1 = love.graphics.newImage("gfx/fond1.png")
    self.imgs.fde2 = love.graphics.newImage("gfx/fond2.png")
    self.imgs.fde3 = love.graphics.newImage("gfx/fond3.png")
    
    self.imgs.clouds = {}
    self.imgs.clouds[1] = love.graphics.newImage("gfx/clouds1.png")
    self.imgs.clouds[2] = love.graphics.newImage("gfx/clouds2.png")
    self.imgs.clouds[3] = love.graphics.newImage("gfx/clouds3.png")
    self.imgs.clouds[4] = love.graphics.newImage("gfx/clouds4.png")
    self.imgs.clouds[5] = love.graphics.newImage("gfx/clouds5.png")
    
    -- inits
    self:newCloud(true)
    self:newCloud(true)
    self:newCloud(true)
    
    print('mmBG loaded')
end

function CBackground:draw()
    love.graphics.setColor(Apps.colors.yellow)
    love.graphics.setFont(Apps.fonts.default)
    love.graphics.print('BG', 50, 50)
    
    love.graphics.setColor({255,255,255})
    
    -- fde 3
    love.graphics.draw(self.imgs.fde3, -150, -10)
    
    
    -- clouds
    -- sort : must draw from farest to nearest
    local order = {}
    do
        local index = 0
        for name, cld in pairs(self.clouds) do
            index = index + 1
            if index == 1 then order[1] = cld
            elseif index == 2 then
                if cld.pos.y > order[1].pos.y then
                    table.insert(order, cld)
                else
                    table.insert(order, 1, cld)
                end
                
            elseif index == 3 then
                if cld.pos.y < order[1].pos.y then
                    table.insert(order, 1, cld)
                elseif cld.pos.y < order[2].pos.y then
                    table.insert(order, 2, cld)
                else
                    table.insert(order, cld)
                end
                
            end
        end
        
    end
    
    for i = 3, 1, -1 do
        local cld = order[i]
        local img = self.imgs.clouds[cld.type]
        
        love.graphics.draw(img, cld.pos.x, cld.pos.y-50, 0, cld.zoomFactor, cld.zoomFactor)
    end
    
    
    -- fde 2
    love.graphics.draw(self.imgs.fde2, -112-self.shift/2, 0)
    
    -- fde 1
    love.graphics.draw(self.imgs.fde1, 0-self.shift, 120)
    
end

function CBackground:update(dt)
    -- clouds (& birds ?)
    local sup = {}
    for name, cl in pairs(self.clouds) do
        -- update pos
        cl.pos.x = cl.pos.x + cl.speed * dt
        
        -- out of screen ?
        if cl.pos.x > 800 then
            table.insert(sup, cl.name)
        end
    end
    
    for i = 1, #sup do
        self.clouds[sup[i]] = nil
        self:newCloud()
    end
    
    
    -- camera : perspective fde 1/2/3 <=> mouse position
    -- background width = 1024, screen width = 800
    local mx = love.mouse.getX()
    self.shift = 7/25*mx
    
end

------------------------
--  Static functions


------------------------
--  Member functions
function CBackground:getType() return self.type end

function CBackground:newCloud(visible)
    --------------------
    --  Add a traveilling into the sky
    --  visible : true if the cloud is already visible, false if created outside the view
    
    local cl = {}
    
    local ypos = math.random(300) -- => deepness, speed & zoom factor
    
    cl.speed = 130 - ypos/3 -- pxl / sec
    local var = 50 + math.random(150) -- 50..200 %
    cl.speed = cl.speed * var/100
    
    cl.zoomFactor = 0.2 - ypos/1875 -- little since every cloud png width is 800 pxls
    var = 75 + math.random(50) -- 75..125 %
    cl.zoomFactor = cl.zoomFactor * var/100
    
    local xpos
    if visible then
        xpos = math.random(800)
    else
        xpos = -800*cl.zoomFactor
    end
    
    cl.pos = {x=xpos, y=ypos}
    
    cl.type = math.random(5)
    cl.name = 'cld'..tostring(Apps:getNextID())
    
    self.clouds[cl.name] = cl
end



print "CBackground loaded"