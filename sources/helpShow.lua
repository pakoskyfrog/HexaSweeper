-- Pakoskyfrog 2013/02/18 15:08:39

-----------------------------------------------------------
----    CHelpShow definition
-----------------------------------------------------------

------------------------
-- Description
--[[
    Help display understate.
    just shows pictures with {next/prev/back} btns
]]

-----------------------------------------------------------
------------------------
--  Init
CHelpShow = {}
CHelpShow.__index = CHelpShow

------------------------
--  Properties
CHelpShow.type = "CHelpShow"


------------------------
--  Constructor
function CHelpShow:create(name, num)
    local HelpShow = {}
    setmetatable(HelpShow, CHelpShow)
    
    HelpShow.btns = {}
    HelpShow.btns[1] = CButton:create(HelpShow, 'prev', 0, 0)
    HelpShow.btns[2] = CButton:create(HelpShow, 'next', 0, 0)
    HelpShow.btns[3] = CButton:create(HelpShow, 'back', 0, 0)
    HelpShow.btns[1].onClick = CHelpShow.prevPage
    HelpShow.btns[2].onClick = CHelpShow.nextPage
    HelpShow.btns[3].onClick = Actions.nullUnderState
    HelpShow.btns[1].colors.text = {200,200,200}
    HelpShow.btns[2].colors.text = {200,200,200}
    HelpShow.btns[3].colors.text = {200,200,200}
    
    HelpShow.currentPage = 1
    HelpShow.num = num
    HelpShow.name = name
    
    CHelpShow.load(HelpShow)
    return HelpShow
end


------------------------
--  Callbacks

function CHelpShow:load()
    self.pics = {}
    for i = 1, self.num do
        self.pics[i] = love.graphics.newImage('gfx/help'..self.name..i..'.png')
    end
    self:updateBtnsPositions()
    
    print('CHelpShow loaded ['..self.name..']')
end

function CHelpShow:draw()
    local p = self.pics[self.currentPage]
    local w,h = p:getWidth(), p:getHeight()
    local sx = (Apps.w-w)*0.5
    local sy = (Apps.h-h)*0.5
    
    -- img / page
    love.graphics.setColor(Apps.colors.white)
    love.graphics.draw(p, sx, sy)
    
    -- frame
    love.graphics.setColor(Apps.colors.btn_Frame)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle('line',sx,sy, w,h)
    
    -- btns
    for i, b in ipairs(self.btns) do
        b:draw()
    end
end

function CHelpShow:update(dt)
    -- btns
    for i, b in ipairs(self.btns) do
        b:update(dt)
    end
    
end

function CHelpShow:mousepressed(x, y, btn)
    for i, b in ipairs(self.btns) do
        b:mousepressed(x, y, btn)
    end
end

function CHelpShow:keypressed(key)
    
end

function CHelpShow:mousereleased(x, y, btn)
    
end

function CHelpShow:keyreleased(key)
    
end

------------------------
--  Static functions


------------------------
--  Member functions
function CHelpShow:getType()
    return self.type
end

function CHelpShow:prevPage()
    --------------------
    --  go one page back
    self.parent.currentPage = math.max(self.parent.currentPage-1, 1)
    self.parent:updateBtnsPositions()
end
function CHelpShow:nextPage()
    --------------------
    --  go one page forward
    self.parent.currentPage = math.min(self.parent.currentPage+1, self.parent.num)
    self.parent:updateBtnsPositions()
end

function CHelpShow:updateBtnsPositions()
    --------------------
    --  will make the buttons go where they should be
    local p = self.pics[self.currentPage]
    local w,h = p:getWidth(), p:getHeight()
    local dx, dy = 5, 5
    local sx = (Apps.w-w)*0.5 + dx
    local b = self.btns[1] -- prev : left/bottom
    local sy = (Apps.h+h)*0.5 - dy - b.height
    
    b.pos = {x=sx, y=sy}
    
    b = self.btns[2] -- next : left/bottom . sec pos
    b.pos = {x=sx + b.width+dx, y=sy}
    
    b = self.btns[3] -- back : right/bottom
    b.pos = {x=(Apps.w+w)*0.5 - dx - b.width, y=sy}
end



print "CHelpShow loaded"