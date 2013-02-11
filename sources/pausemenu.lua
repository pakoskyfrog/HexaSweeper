-- Pakoskyfrog 2013

-----------------------------------------------------------
----    CPauseMenu definition
-----------------------------------------------------------

------------------------
-- Description
--[[
    Pause menu of the game
]]

-----------------------------------------------------------
------------------------
--  Init
CPauseMenu = {}
setmetatable(CPauseMenu, CMenu)

------------------------
--  Properties
CPauseMenu.type = "CPauseMenu"


------------------------
--  Constructor
function CPauseMenu:create()
    local bcol = Apps.colors.white
    local colr = {200,200,200}

    local menu1 = CMenu.create()
    setmetatable(menu1, self)
    self.__index = self
    
    menu1:setWindowed()
    menu1:setAlignment('center')
    
    menu1:addBtn({caption='Resume the game', name='resume', onClick=Actions.nullUnderState})
    menu1:addBtn({caption='Show the solution', name='soluce', onClick=Actions.wip})
    menu1:addBtn({caption='Restart new', hint='Will rebuild a new game with same settings as previous one' , name='new', onClick=Actions.restartGame})
    menu1:addBtn({caption='Back to main menu', name='gomenu', onClick=Actions.activateMainMenu})
    
    -- changing colors
    for name, btn in pairs(menu1.pages[1].buttons) do
        btn.colors.over = bcol
        btn.colors.text = colr
    end
    
    return menu1
end


------------------------
--  Callbacks
function CPauseMenu:keypressed(key)
    --------------------
    --  called when a key is pressed
    if key == 'escape' then
        print('pause : exit by escape')
        Actions:nullUnderState()
    end
end


------------------------
--  Static functions


------------------------
--  Gets / Sets
function CPauseMenu:getType() return self.type end



------------------------
--  Member functions




print "CPauseMenu loaded"