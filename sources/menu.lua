-- Pakoskyfrog 2013

-----------------------------------------------------------
----    CMenu definition
-----------------------------------------------------------

------------------------
-- Description
--[[
    Menu Class definition, can produce a main menu or a windowed menu, as respectively state and understate of application.
]]

-----------------------------------------------------------
------------------------
--  Init
CMenu = {}
CMenu.__index = CMenu

------------------------
--  Properties
CMenu.type = "CMenu"
CMenu.title = "No title"
CMenu.align = 'left'
CMenu.windowed = false
CMenu.dy = 10 -- vertical space between btns
CMenu.margin = 50
CMenu.winMargin = 20
CMenu.bgFrozen = false

------------------------
--  Constructor
function CMenu:create()
    local menu = {}
    setmetatable(menu, CMenu)
    
    if CBackground then
        menu.bg = CBackground:create()
    end
    
    menu.ID = Apps:getNextID()
    
    menu.curPage = 1
    menu.pages = {}
    menu:addNewPage()
    
    return menu
end


------------------------
--  Callbacks

function CMenu:load()
    if self.bg then
        self.bg:load()
    end
end

function CMenu:draw()
    -- background
    if not self.windowed and self.bg then self.bg:draw() end
    
    -- title
    if not self.windowed then
        love.graphics.setFont(self.titleFont or Apps.fonts.huge)
        love.graphics.setColor(self.titleColor or Apps.colors.main_Title or {100,255,100})
        love.graphics.print(self.title, 20, 20)
    end
    
    -- frame
    if self.windowed then
        local w = 350 -- TMP
        local h = 50 + self.pages[self.curPage].btnCount * (self.pages[self.curPage].buttons.quit.height + self.dy)
        local x = (love.graphics.getWidth()-w)*0.5
        local y = (love.graphics.getHeight()-h)*0.5
        love.graphics.setColor(Apps.colors.menu_bg or {0,0,0,200})
        love.graphics.rectangle('fill',x,y,w,h)
        love.graphics.setColor(Apps.colors.menu_frame or {100,255,100})
        love.graphics.setLineWidth(4)
        love.graphics.rectangle('line',x,y,w,h)
    end
    
    -- buttons
    for n,b in pairs(self.pages[self.curPage].buttons) do
        b:draw()
    end
end

function CMenu:update(dt)
    for n,b in pairs(self.pages[self.curPage].buttons) do
        b:update(dt)
    end
    if CBackground and not self.bgFrozen then
        self.bg:update(dt)
    end
end

function CMenu:mousepressed(x, y, btn)
    for n,b in pairs(self.pages[self.curPage].buttons) do
        if b:mousepressed(x, y, btn) then   
            if self.pages[self.curPage].buttons[n] then
                print("Menu: clicked on", n, self.pages[self.curPage].buttons[n].caption or 'undef', b.ID, btn)
            end
        end
    end
end

function CMenu:keypressed(key)
    for n,b in pairs(self.pages[self.curPage].buttons) do
        b:keypressed(k)
    end
end

function CMenu:mousereleased(x, y, btn) end

function CMenu:keyreleased(key) end

------------------------
--  Static functions

------------------------
--  Gets / Sets
function CMenu:getType()
    return self.type
end


function CMenu:setTitle(tit)
    if type(tit) == 'string' then
        self.title = tit
    end
end

function CMenu:setAlignment(ali)
    if ali == 'left' or ali == 'center' or ali == 'right' then
        self.align = ali
    else
        self.align = nil
    end
    
    -- realign btns
    local xpos
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    for p = 1, #self.pages do
        if not self.pages[p].setAlignment then
        for n,b in pairs(self.pages[p].buttons) do
            local tx = b.width
            if self.align == 'left' then
                if self.windowed then
                    xpos = self.winMargin + (love.graphics.getWidth()-350)*0.5  -- TMP
                else
                    xpos = self.margin
                end
            elseif self.align == 'center' then
                xpos = (w-tx)*0.5
                
            else --Right
                if self.windowed then
                    xpos = (love.graphics.getWidth()+350)*0.5 - self.winMargin - tx  -- TMP
                else
                    xpos = w - tx - self.margin
                end
            end
            b.pos.x = xpos
        end
        else
            -- the page has its own alignment func
            self.pages[p].setAlignment(ali)
        end
    end
end

function CMenu:setWindowed(bool)
    if bool or bool==nil then
        self.windowed = true
    else
        self.windowed = false
    end
end

function CMenu:setCurrentPage(num)
    if type(num) == 'number' then
        -- TODO range protection
        self.curPage = num
    end
end

function CMenu:setVerticalSpace(dv)
    self.dy = dv
end

function CMenu:setBG(bg)
    
end

------------------------
--  Member functions

-- menu1:addBtn({caption='butn 1', name='first', hint='click me'}) --, onClick=func , page=2
function CMenu:addBtn(pseudoBtn)
    local b = CButton:create(self, pseudoBtn.caption, 0, 0)
    local xpos = self.margin
    local tx = b.width
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    
    page = pseudoBtn.page or self.curPage or 1
    
    if self.windowed then
        xpos = self.winMargin + (love.graphics.getWidth()-350)*0.5  -- TMP
        if self.align == 'center' then
            xpos = (w-tx)*0.5
        elseif self.align == 'right' then
            xpos = (love.graphics.getWidth()+350)*0.5 - self.winMargin - tx  -- TMP
        end
    else
        if self.align == 'center' then
            xpos = (w-tx)*0.5
        elseif self.align == 'right' then
            xpos = w - tx - self.margin
        end
    end
    if pseudoBtn.hint then
        b.hint = {text = pseudoBtn.hint}
    end
    if pseudoBtn.onClick and type(pseudoBtn.onClick) == 'function' then
        b.onClick = pseudoBtn.onClick
    end
    if pseudoBtn.onRollUp and type(pseudoBtn.onRollUp) == 'function' then
        b.onRollUp = pseudoBtn.onRollUp
    end
    if pseudoBtn.onRollDown and type(pseudoBtn.onRollDown) == 'function' then
        b.onRollDown = pseudoBtn.onRollDown
    end
    b.name = pseudoBtn.name
    b.pos  = {x=xpos, y=self.pages[page].ypos}
    self.pages[page].ypos = self.pages[page].ypos + self.dy + b.height
    self.pages[page].buttons[b.name] = b
    self.pages[page].btnCount = self.pages[page].btnCount + 1
    
    
    -- Adapt ypos in case of winMode
    if self.windowed then
        local c = self.pages[page].btnCount - 1
        local bh = self.pages[page].buttons.quit.height
        local h = 50 + c * (bh + self.dy)
        local sy = (love.graphics.getHeight()-h)*0.5 + self.winMargin

        self.pages[page].buttons[b.name].pos.y = sy + (bh + self.dy)*(c-1)
        
        for name, btn in pairs(self.pages[page].buttons) do
            btn.pos.y = btn.pos.y - (bh + self.dy)*0.5
        end
        
    end
    
    -- Adapt Quit btn
    local q = self.pages[page].buttons.quit
    q.pos.y = self.pages[page].ypos
    if self.windowed then
        q.pos.y = self.pages[page].buttons[b.name].pos.y + q.height + self.dy
    end
end

function CMenu:addNewPage()
    self.pages[#self.pages+1] = {ypos = 20 + Apps.fonts.huge:getHeight() + self.dy, btnCount=0}
    self.pages[#self.pages].buttons = {}
    self:addBtn({caption='Quit', name='quit', hint='Quit the game', onClick=CMenu.click_quit, page=#self.pages})
    self.pages[#self.pages].buttons.quit.hint.color = Apps.colors.btn_Red or {255,100,100}
end


function CMenu:click_quit(x, y, button)
    --------------------
    --  Onclick action : quit
    
    love.event.push("quit")
end

-- function CMenu:click_goback(x, y, button)
    -- --------------------
    -- --  Onclick action : back to main menu
    
    -- Apps.state.buttons , Apps.state.buttons2 = Apps.state.buttons2 , Apps.state.buttons
    -- Apps:addMsg("Menu charge")
-- end



print "CMenu loaded"