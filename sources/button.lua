-- Pakoskyfrog 2013

-----------------------------------------------------------
----    CButton definition
-----------------------------------------------------------

------------------------
-- Description
--[[
    Clickable button
]]

-----------------------------------------------------------
------------------------
--  Init
CButton = {}
CButton.__index = CButton

------------------------
-- Properties --
CButton.type = "CButton"

------------------------
--  Constructor
function CButton:create(sender, text, x, y, size)
    local btn = {}
    setmetatable(btn, CButton)
    
    btn.parent = sender
    btn.ID = Apps:getNextID()
    
    btn.caption = text
    btn.fontSize = size or "large"
    
    btn.hover = false
    
    btn.pos    = {x=x, y=y}
    btn.height = Apps.fonts[btn.fontSize]:getHeight()
    btn.width  = Apps.fonts[btn.fontSize]:getWidth(text)
    
    btn.visible = true
    btn.enabled = true
    btn.framed  = false
    btn.hasBG   = false
    
    btn.colors = {
        text  = Apps.colors.btn_Text  or {200,200,200},
        bg    = Apps.colors.btn_BG    or {  0,  0,  0,200},
        frame = Apps.colors.btn_Frame or {150,255,150},
        notEn = Apps.colors.btn_NotEnabled or {100,100,100},
        over  = Apps.colors.btn_Over or  {255,255,255},
    }
    
    -- btn.shortcut={'shift','r'}
    return btn
end


------------------------
-- Callbacks --
function CButton:draw()
    if not self.visible then return end

    local lg = love.graphics
    
    if self.hasBG then
        lg.setColor(self.colors.bg)
        lg.rectangle('fill',self.pos.x, self.pos.y, self.width, self.height)
    end
    if self.framed then
        lg.setColor(self.colors.frame)
        lg.setLineWidth(3)
        lg.rectangle('line',self.pos.x, self.pos.y, self.width, self.height)
    end
    
    if self.selfFont then
        lg.setFont(self.selfFont)
    else
        lg.setFont(Apps.fonts[self.fontSize])
    end
    
    if self.hover then
        lg.setColor(self.colors.over)
    else
        lg.setColor(self.colors.text)
    end
    
    lg.print(self.caption, self.pos.x, self.pos.y)
    
end

function CButton:update(dt)
    self.hover = false
    
    if not self.visible then return end

    local x = love.mouse.getX()
    local y = love.mouse.getY()
    
    if x > self.pos.x
        and x < self.pos.x + self.width
        and y > self.pos.y
        and y < self.pos.y + self.height then
            self.hover = true
            if self.hint then
                Apps.hintZone.lines = {self.hint}
            end
    end
    
end

function CButton:mousepressed(x, y, button)
    if not self.visible then return false end
    if self.hover then
        self.hover = false
        
        if self.onClick and button == "l" then -- left btn
            self:onClick(x, y, button)
        end
        if self.onRightClick and button == "r" then -- right btn
            self:onRightClick(x, y, button)
        end
        if self.onMidClick and button == "m" then -- mid btn
            self:onMidClick(x, y, button)
        end
        if self.onRollUp and button == "wu" then -- wheel up btn
            self:onRollUp(x, y, button)
        end
        if self.onRollDown and button == "wd" then -- wheel down btn
            self:onRollDown(x, y, button)
        end
        
        return true
    end
    
    return false
end

function CButton:keypressed(k)
    -- nothing
    
    -- TODO, activation of shortcuts and retroactive research in containers
end

------------------------
--  Gets / Sets

function CButton:getType() return self.type end

function CButton:setCaption(text)
    local btn = self
    btn.caption = text
    if self.selfFont then
        btn.height = self.selfFont:getHeight()
        btn.width  = self.selfFont:getWidth(text)
    else
        btn.height = Apps.fonts[btn.fontSize]:getHeight()
        btn.width  = Apps.fonts[btn.fontSize]:getWidth(text)
    end
    
end

function CButton:setFont(size)
    -- TODO check existence
    self.fontSize = size
end

function CButton:setEnabled(bool)
    bool = bool or true
    self.enabled = bool
end

function CButton:setVisible(bool)
    bool = bool or true
    self.visible = bool
end

function CButton:setFrame(bool, color)
    bool = bool or true
    self.framed = bool
    
    if color then
        -- TODO check color's validity
        self.colors.frame = color
    end
end

function CButton:setBackground(bool, color)
    bool = bool or true
    self.framed = bool
    
    if color then
        -- TODO check color's validity
        self.colors.bg = color
    end
end

function CButton:setColor(color)
    if type(color) == 'table' then
        self.colors.text = color
    end
end

function CButton:setShortcut(list)
    --------------------
    --  TODO
    
end

function CButton:setHint(text, color)
    self.hint = {text = text, color = color}
end



------------------------
-- Member functions --


print "Loaded."

