-- Pakoskyfrog 2013

-----------------------------------------------------------
----    CEdit definition
-----------------------------------------------------------

------------------------
-- Description
--[[
    A editable text zone, with a key pressed filter.
]]

-----------------------------------------------------------
------------------------
--  Init
CEdit = {}
CEdit.__index = CEdit

------------------------
--  Properties
CEdit.type = "CEdit"
CEdit.font = Apps:getFont()
-- TODO refactor pos = {x=,y=}
CEdit.x = 10
CEdit.y = 10
CEdit.w = 50
CEdit.h = CEdit.font:getHeight() + 4
CEdit.focus = false
CEdit.crypted = false           -- display *** instead of letters
-- CEdit.hiddenText = ''
-- don't change any color without making a new copy
CEdit.color   = Apps.colors.white -- the one that is in fact used by draw()
CEdit.NRcolor = Apps.colors.white -- normal text color
CEdit.BGcolor = Apps.colors.black
CEdit.NEcolor = Apps.colors.red   -- not enabled state color
CEdit.FRcolor = Apps.colors.green -- frame color
CEdit.visible = true
CEdit.enabled = true
CEdit.blink   = false
CEdit.blTimer = 0
CEdit.hover   = false

------------------------
--  Constructor
function CEdit:create(sender)
    local Edit = {}
    setmetatable(Edit, CEdit)
    Edit.parent = sender
    Edit.ID = Apps:getNextID()
    
    Edit.text = ''
    
    
    return Edit
end


------------------------
--  Callbacks

function CEdit:load()
    
end

function CEdit:draw()
    -- print(self.type, 'draw !!')
    if self.visible then
        -- frame
        local pos = self:getRealPos()
        local x, y = pos.x, pos.y
        local w, h = self:getWidth(), self:getHeight()
        -- print(x,y,w,h)
        love.graphics.setColor(self.BGcolor)
        love.graphics.rectangle('fill', x, y, w, h)
        love.graphics.setColor(self.FRcolor)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle('line', x, y, w, h)
        
        -- text
        love.graphics.setFont(self.font)
        love.graphics.setColor(self.color)
        love.graphics.print(self.text, x+2, y+2)
        
        -- cursor
        if self:hasFocus() and self.blink then
            local px  = x + self:getTextWidth() + 3
            love.graphics.line(px,y+3, px, y+self:getTextHeight()+1)
        end
        
    end
end

function CEdit:update(dt)
    if not self.visible then return end
    if not self.enabled then return end

    if self:hasFocus() then
        self.blTimer = self.blTimer + dt
        local ref = math.floor(self.blTimer*3) % 2
        self.blink = (ref == 0)
    end
    
    -- hovering
    self.hover = false
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    
    if x > self.x
        and x < self.x + self.w
        and y > self.y
        and y < self.y + self.h then
            self.hover = true
            if self.hint then
                Apps.hintZone.lines = {self.hint}
            end
    end
    
end

function CEdit:mousepressed(x, y, btn)
    -- like this every button passes the focus
    if self.hover then
        if not self:hasFocus() then
            self:setFocus()
            return true
        end
    end
    
    return false
end

function CEdit:keypressed(key)
    if not self.visible then return end
    if not self.enabled then return end

    local pat = '[a-z0-9\- ]+'
    local s,e = string.find(key, pat)
    if s and e-s==0 then
        if (love.keyboard.isDown('lshift')) or (love.keyboard.isDown('rshift')) then
            self:addText(string.upper(key))
        else
            self:addText(key)
        end
    end
    
    pat = 'kp[0-9\-]'
    s,e = string.find(key, pat)
    if s then
        self:addText(string.sub(key, e, e))
    end
    
    if key == 'backspace' then
        self.text = string.sub(self.text, 1, -2)
    end
end

function CEdit:mousereleased(x, y, btn)
    
end

function CEdit:keyreleased(key)
    
end

------------------------
--  Static functions


------------------------
--  gets / sets
function CEdit:getType() return self.type end

function CEdit:getTextWidth()
    return self.font:getWidth(self.text)
end

function CEdit:getTextHeight()
    return self.font:getHeight()
end

function CEdit:getWidth()
    return self.w
end

function CEdit:getHeight()
    return self.h
end

function CEdit:getRealPos()
    --------------------
    --  Ascending func that passes through every parent
    local pp = self.parent:getRealPos()
    
    return {x = self.x + pp.x, y = self.y + pp.y}
end

function CEdit:getText()
    if self.crypted then
        return self.hiddenText
    else
        return self.text
    end
end


function CEdit:hasFocus()
    return self.focus
end


function CEdit:setText(text)
    self.text = ''
    self.hiddenText = ''
    self:addText(text)
end


function CEdit:setPosX(newX)
    -- nil value retrieve the default value in the class description
    if newX == nil or type(newX) == 'number' then
        self.x = newX
    else
        assert(false, 'x must be a number or nil.')
    end
end

function CEdit:setPosY(newY)
    -- nil value retrieve the default value in the class description
    if newY == nil or type(newY) == 'number' then
        self.y = newY
    else
        assert(false, 'y must be a number or nil.')
    end
end

function CEdit:setWidth(newW)
    -- nil value retrieve the max(CEdit.w, length of text)
    if newW == nil or type(newW) == 'number' then
        local wt = self:getTextWidth()
        self.w = math.max(math.max(newW, CEdit.w), wt+4)
    else
        assert(false, 'The width must be a number or nil.')
    end
end

function CEdit:setHeight(newH)
    -- can't be saller than textHeight
    if newH == nil or type(newH) == 'number' then
        local ht = self:getTextHeight()
        self.w = math.max(newH, ht+4)
    else
        assert(false, 'The height must be a number or nil.')
    end
end

function CEdit:setFont(font)
    -- nil -> default
    if font == nil then font = 'default' end
    if type(font) == string then font = Apps:getFont(font) end
    if type(font) == 'userdata' then
        self.font = font
        self:setHeight()
        self:setWidth(self:getWidth())
        return true
    else
        assert(false, 'Font must either be a font size (string) or a userdata font.')
        return false
    end
end

function CEdit:setFocus()
    --------------------
    --  will assume that only one child has the focus
    
    if Apps.focused ~= nil and Apps.focused.focus ~= nil then
        Apps.focused.focus = false
    end
    Apps.focused = self
    self.focus = true
    
    -- love.graphics.setFont(self.font)
end

function CEdit:setEnabled(bool)
    if bool == nil then bool = false end
    if bool then
        self.enabled = true
        self.color = NRcolor
    else
        self.enabled = false
        self.color = NEcolor
    end
end

function CEdit:setCrypted(bool)
    if bool == nil then bool = false end
    -- self.crypted = bool
    if bool then
        self.crypted = true
        local stars = ''
        for i = 1, #self.text do
            stars = stars .. '*'
        end
        self.hiddenText = self.text
        self.test = stars
    else
        self.crypted = false
        self.text = self.hiddenText or ''
    end
end



------------------------
--  Member functions
function CEdit:init(options)
    --------------------
    --  options : table containing what you want to initialize
    --      x, y : relative position coordinates
    if options.x then self:setPosX(options.x) end
    if options.y then self:setPosY(options.y) end
    if options.w or options.width  then self:setWidth(options.w) end
    if options.h or options.height then self:setHeight(options.h) end
    if options.font then self:setFont(options.font) end
    -- colors TODO
    if options.crypted ~= nil then self:setCrypted(options.crypted) end
    if options.enabled ~= nil then self:setEnabled(options.enabled) end
    if options.text and type(options.text) == 'string' then self:setText(options.text) end
end

function CEdit:addText(txt)
    --------------------
    --  Add some text to self.text, without going over the width
    
    local lim = self:getWidth() - 4
    if self.crypted then
        local stars = ''
        for i = 1, #txt do
            stars = stars .. '*'
        end
        local nw  = self.font:getWidth(self.text .. stars)
        if nw <= lim then
            
            self.text = self.text .. stars
            self.hiddenText = self.hiddenText .. txt
            return true
        else
            return false
        end
    else
        local nw  = self.font:getWidth(self.text .. txt)
        if nw <= lim then
            self.text = self.text .. txt
            return true
        else
            return false
        end
    end
end






print "CEdit loaded"