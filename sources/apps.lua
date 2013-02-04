
------------------------
--  INIT
Apps = {}
Apps.debug = true
Apps.version = 0.1
Apps.type = 'Apps'

-- some fonts (list may change)
Apps.fonts = { default = love.graphics.newFont(24),
               large   = love.graphics.newFont(32),
               big     = love.graphics.newFont(44),
               huge    = love.graphics.newFont(72),
               small   = love.graphics.newFont(20),
               tiny    = love.graphics.newFont(12),  }

-- Some basic colors
Apps.colors = { white = {255,255,255},
                gray  = {128,128,128},
                black = {  0,  0,  0},
                blue  = {  0,  0,255},
                red   = {255,  0,  0},
                green = {  0,255,  0},
                cyan    = {  0,255,255},
                magenta = {255,  0,255},
                yellow  = {  0,255,255},
              }
              
Apps.ID = 0
Apps.curID = 0

--------------------
-- hintZone
Apps.hintZone = {}
Apps.hintZone.h = 100
Apps.hintZone.w = 0
Apps.hintZone.textSize = "default"
Apps.hintZone.start = {x=10, y=love.graphics.getHeight() - Apps.fonts.default:getHeight()  -5}
Apps.hintZone.lines = nil

--------------------
--  msgZone
Apps.msgZone = {start={x=5, y=5}}
Apps.msgZone.textSize = "small"
Apps.msgZone.lines = {}                 -- msgs container
Apps.msgZone.duration = 0.75             -- sec
Apps.msgZone.color = Apps.colors.msgZone_Text or {150,150,150}    -- display color
Apps.msgZone.backColor = Apps.colors.msgZone_Bg or {0,0,0,200}
Apps.msgZone.lifeTime = 0               -- record of first message lifetime

Apps.actualTime = 0


------------------------
--  Apps functions
function Apps:load()
    Apps.state = CMainMenu:create()
    Apps.state:load()
end

function Apps:keypressed(key)
    -- everywhere exit
    if key == "f4" and (love.keyboard.isDown("ralt") or love.keyboard.isDown("lalt") ) then
        love.event.push("quit")
    end
    
    -- states
    if not self.state then return end -- just in case, state should always be non nil
    if self.state.state then
        self:addMsg((self.state.state:getType()).." : "..key)
        self.state.state:keypressed(key)
    else
        self:addMsg((self.state:getType()).." : "..key)
        self.state:keypressed(key)
    end
end

function Apps:keyreleased(key)
    -- states
    if not self.state then return end -- just in case, state should always be non nil
    if self.state.state then
        self:addMsg((self.state.state:getType()).." : "..key)
        self.state.state:keyreleased(key)
    else
        self:addMsg((self.state:getType()).." : "..key)
        self.state:keyreleased(key)
    end
end

function Apps:mousepressed(x, y, button)
    -- states
    if not self.state then return end -- just in case, state should always be non nil
    if self.state.state then
        self.state.state:mousepressed(x,y,button)
    else
        self.state:mousepressed(x,y,button)
    end
end

function Apps:mousereleased(x, y, button)
    -- states
    if not self.state then return end -- just in case, state should always be non nil
    if self.state.state then
        self.state.state:mousereleased(x, y, button)
    else
        self.state:mousereleased(x, y, button)
    end
end

function Apps:draw()
    -- 2 lvled stateness
    if self.state then self.state:draw() end
    if self.state and self.state.state then self.state.state:draw() end
    
    local lg = love.graphics
    
    --------------------
    -- hintZone
    do
        if self.hintZone.lines then
            -- for title or display control purpose
            local ypos = 0
            for index, line in ipairs(self.hintZone.lines) do
                local size  = line.size or "default"
                local start = self.hintZone.start
                local pos   = line.position or {0, 0}
                local clr   = line.color or Apps.colors.hintZone_Text or {150,150,150}
                love.graphics.setFont(self.fonts[size])
                love.graphics.setColor(clr)
                love.graphics.print(line.text, start.x+pos[1], start.y+pos[2]+ypos)
                ypos = ypos + 5 + self.fonts[size]:getHeight()
            end
        end
    end
    
    --------------------
    --  msgZone
    if #self.msgZone.lines > 0 then
        lg.setFont(self.fonts[self.msgZone.textSize])
        local h = self.fonts[self.msgZone.textSize]:getHeight()
        
        for i = 1, math.min(3, #self.msgZone.lines), 1 do
            local msg = self.msgZone.lines[i].msg
            local w = self.fonts[self.msgZone.textSize]:getWidth(msg)
            lg.setColor(self.msgZone.backColor or {0,0,0,200})
            lg.rectangle("fill", self.msgZone.start.x, self.msgZone.start.y + (i-1)*h, w, h)
            lg.setColor(self.msgZone.lines[i].color or self.msgZone.color)
            lg.print(msg, self.msgZone.start.x, self.msgZone.start.y + (i-1)*h)
        end
    end
end

function Apps:update(dt)
    -- states
    if not self.state then return end -- just in case, state should always be non nil
    if self.state.state then
        self.state.state:update(dt)
        if self.state.bg then
            self.state.bg:update(dt)
        end
    else
        self.state:update(dt)
    end
    
    self.actualTime = self.actualTime + dt

    
    --------------------
    -- msgZone 
    if #self.msgZone.lines > 0 then
        if self.actualTime - self.msgZone.lifeTime > self.msgZone.duration then
            table.remove(self.msgZone.lines, 1)
            self.msgZone.lifeTime = self.actualTime
        end
    else
        self.msgZone.lifeTime = self.actualTime
    end
end

function Apps:addMsg(msg)
    --------------------
    --  Adds a message to the message list
    if type(msg) == "string" then
        table.insert(self.msgZone.lines, {msg=msg})
    elseif type(msg) == "number" then
        table.insert(self.msgZone.lines, {msg=tostring(msg)})
    elseif type(msg) == "table" then
        table.insert(self.msgZone.lines, {msg='Table, size='..tostring(#msg)})
    else
        table.insert(self.msgZone.lines, {msg='undef'})
    end
end

function Apps:getType() return 'Apps' end

function Apps:getFont(size)
    if size == '' or size == nil then size = 'default' end
    if type(size) ~= 'string' then return false end
    if self.fonts[size] then
        return self.fonts[size]
    else
        return false
    end
end

function Apps:getNextID()
    self.curID = self.curID + 1
    return self.curID
end



