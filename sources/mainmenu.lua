-----------------------------------------------------------
----    CMainMenu definition
-----------------------------------------------------------

------------------------
-- Description
--[[
    First and main menu of the game
]]

-----------------------------------------------------------
------------------------
--  Init
CMainMenu = {}
CMainMenu.__index = CMainMenu

------------------------
--  Properties
CMainMenu.type = "CMainMenu"


------------------------
--  Constructor
function CMainMenu:create()
    local menu1 = CMenu.create()
    menu1:setTitle('Wrong Places  '..Apps.version)
    menu1:setAlignment('center')
    
    -- PAGE 1 : main redirection page
    menu1:addBtn({caption='New', name='new', hint='Launch the settings for a new game', onClick=Actions.goPage2}) --, onClick=func , page=2
    menu1:addBtn({caption='Options', name='options', hint='Music and sounds options', onClick=Actions.wip})
    menu1:addBtn({caption='High scores', name='highscore', hint='Displays the best scores !', onClick=Actions.wip})
    menu1:addBtn({caption='Credits', name='credits', hint='Shows the credits list', onClick=Actions.wip})
    
    -- PAGE 2 : new game
    menu1:addNewPage()
    menu1:addBtn({caption='Mode : Normal', name='mode', hint='Mode de jeu', onClick=Actions.wip, page=2})
    -- + difficulty, size
    menu1:addBtn({caption='Let\'s GO !', name='launchGame', hint='Launch the game', onClick=Actions.wip, page=2})
    menu1:addBtn({caption='Back', name='goBack', hint='Retour au menu principal', onClick=Actions.goPage1, page=2})
    
    -- PAGE 3 : options
    
    
    return menu1
end


------------------------
--  Callbacks

function CMainMenu:load()
    
end

function CMainMenu:draw()
    
end

function CMainMenu:update(dt)
    
end

function CMainMenu:mousepressed(x, y, btn)
    
end

function CMainMenu:keypressed(key)
    
end

function CMainMenu:mousereleased(x, y, btn)
    
end

function CMainMenu:keyreleased(key)
    
end

------------------------
--  Static functions


------------------------
--  Gets / Sets
function CMainMenu:getType() return self.type end



------------------------
--  Member functions




print "CMainMenu loaded"