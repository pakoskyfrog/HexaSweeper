-- Pakoskyfrog 2013/02/11 15:42:05

-----------------------------------------------------------
----    CHSName definition
-----------------------------------------------------------

------------------------
-- Description
--[[
    This is the definition of the Form where the player will enter his name if he gets a high score
]]

-----------------------------------------------------------
------------------------
--  Init
CHSName = {}
CHSName.__index = CHSName

------------------------
--  Properties
CHSName.type = "CHSName"
CHSName.title = 'New High Score !'
CHSName.title_font  = love.graphics.newFont("gfx/menu3.ttf", 24)
CHSName.title_color = Apps.colors.btn_Frame
CHSName.frame_color = Apps.colors.btn_Frame
CHSName.bg_color    = Apps.colors.black
CHSName.star_color  = Apps.colors.yellow

------------------------
--  Constructor
function CHSName:create(sender)
    local HSName = {}
    setmetatable(HSName, CHSName)
    
    HSName.ID = Apps:getNextID()
    HSName.parent = sender
    
    HSName.pos = {w=250, h=100, x=(love.graphics.getWidth()-250)/2, y=love.graphics.getHeight()-150}
    
    HSName.edit = CEdit.create(CEdit, HSName)
    HSName.edit:init({x=15, y=20, w=HSName.pos.w-30})
    HSName.edit:setFocus()
    
    -- TODO add container effect on buttons
    HSName.okBtn = CButton:create(HSName, '  Ok  ', 16+HSName.pos.x, 58+HSName.pos.y, 'default')
    HSName.okBtn.framed = true
    HSName.okBtn.colors.text  = {200,200,200}
    HSName.okBtn.colors.frame = {  0,150,  0}
    HSName.okBtn.onClick = Actions.addPlayerName
    
    HSName.starRotateRate = 0.1 -- rot * 2pi/sec
    HSName.theta = 0
    
    
    print('hsName created by '..sender:getType())
    return HSName
end


------------------------
--  Callbacks

function CHSName:load()
    
end

function CHSName:draw()
    -- stars
    love.graphics.setColor(self.star_color)
    love.graphics.setLineWidth(4)
    -- love.graphics.polygon('line', self:getStarRef())
    love.graphics.line(self:getStarRef())
    
    -- back
    love.graphics.setColor(self.bg_color)
    love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.pos.w, self.pos.h)
    
    -- title
    local tw = self.title_font:getWidth(self.title)
    local th = self.title_font:getHeight()
    love.graphics.setColor(self.title_color)
    love.graphics.setFont(self.title_font)
    love.graphics.print(self.title, (love.graphics.getWidth()-tw)*0.5, self.pos.y-th*0.5)
    
    -- frame
    local pts = {
        self.pos.x + (self.pos.w - tw)*0.5 -5, self.pos.y,
        self.pos.x, self.pos.y,
        self.pos.x, self.pos.y + self.pos.h,
        self.pos.x + self.pos.w, self.pos.y + self.pos.h,
        self.pos.x + self.pos.w, self.pos.y,
        self.pos.x + (self.pos.w + tw)*0.5 +5, self.pos.y,
    }
    love.graphics.setColor(self.frame_color)
    love.graphics.setLineWidth(2)
    love.graphics.line(pts)
    
    -- controls
    self.edit:draw()
    self.okBtn:draw()
end

function CHSName:update(dt)
    self.edit:update(dt)
    self.okBtn:update(dt)
    self.theta = self.theta + dt*2*math.pi*self.starRotateRate
end

function CHSName:mousepressed(x, y, btn)
    self.edit:mousepressed(x, y, btn)
    self.okBtn:mousepressed(x, y, btn)
end

function CHSName:keypressed(key)
    self.edit:keypressed(key)
end

function CHSName:mousereleased(x, y, btn)
    self.edit:mousereleased(x, y, btn)
end

function CHSName:keyreleased(key)
    self.edit:keyreleased(key)
end

------------------------
--  Static functions


------------------------
--  Member functions
function CHSName:getType()
    return self.type
end

function CHSName:getStarRef()
    --------------------
    --  This will generate the 10 points needed to draw a 5 piked star
    -- to be drawn with the polygon function
    
    local t = self.theta or 0

    local pts = {}
    local s = math.sin
    local c = math.cos
    local pi = math.pi
    local pi5 = pi*0.2
    local r = 120
    local rr = 40
    local sx = self.pos.x
    local sy = self.pos.y
    
    for i = 0, 5 do
        -- high pike
        pts[4*i+1] = r  * c(t + i*2*pi5     ) + sx
        pts[4*i+2] = r  * s(t + i*2*pi5     ) + sy
        
        -- low pike
        if i < 5 then
            pts[4*i+3] = rr * c(t + i*2*pi5 +pi5) + sx
            pts[4*i+4] = rr * s(t + i*2*pi5 +pi5) + sy
        end
    end
        
    return pts
end

function CHSName:getRealPos()
    --------------------
    --  return absolute position
    return {x=self.pos.x, y=self.pos.y}
end


print "CHSName loaded"