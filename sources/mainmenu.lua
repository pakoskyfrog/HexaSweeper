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
    menu1:addBtn({caption='Options', name='options', hint='Music and sounds options', onClick=Actions.goPage3})
    menu1:addBtn({caption='High scores', name='highscore', hint='Displays the best scores !', onClick=Actions.wip})
    menu1:addBtn({caption='Credits', name='credits', hint='Shows the credits list', onClick=Actions.wip})
    
    -- PAGE 2 : new game
        -- TODO : add options capabylities inside the Class buttons
    menu1:addNewPage()
    menu1:addBtn({caption='Mode : Normal', name='mode', hint='Game modes', onClick=Actions.wip, page=2})
    menu1.pages[2].buttons.mode.options = {'Normal', 'Alchemist'}
    menu1.pages[2].buttons.mode.prefix = 'Mode : '
    menu1.pages[2].buttons.mode.optSelected = 1
    
    menu1:addBtn({caption='Difficulty : Normal', name='diff', hint='Games difficulties (5)', onClick=Actions.nextOption, page=2})
    menu1.pages[2].buttons.diff.options = {'Trivial', 'Easy', 'Normal', 'Tricky', 'Impossible'}
    menu1.pages[2].buttons.diff.prefix = 'Difficulty : '
    menu1.pages[2].buttons.diff.optSelected = 3
    
    menu1:addBtn({caption='Size : Small', name='size', hint='Game sizes (3)', onClick=Actions.nextOption, page=2})
    menu1.pages[2].buttons.size.options = {'Small', 'Normal', 'Big'}
    menu1.pages[2].buttons.size.prefix = 'Size : '
    menu1.pages[2].buttons.size.optSelected = 1
    
    -- + difficulty, size
    menu1:addBtn({caption='Let\'s GO !', name='launchGame', hint='Launch the game', onClick=Actions.wip, page=2})
    menu1:addBtn({caption='Back', name='goBack', hint='Retour au menu principal', onClick=Actions.goPage1, page=2})
    
    -- PAGE 3 : options
    menu1:addNewPage()
    
    menu1:addBtn({caption='Music Volume : 50', name='music', hint='Music volume controler', onRollDown=Actions.adjustVolumeDown, onRollUp=Actions.adjustVolumeUp, page=3})
    menu1.pages[3].buttons.music.prefix = 'Music Volume : '
    menu1.pages[3].buttons.music.optSelected = 50
    
    menu1:addBtn({caption='Effects Volume : 50', name='effects', hint='Effects volume controler', onRollDown=Actions.adjustVolumeDown, onRollUp=Actions.adjustVolumeUp, page=3})
    menu1.pages[3].buttons.effects.prefix = 'Effects Volume : '
    menu1.pages[3].buttons.effects.optSelected = 50
    
    menu1:addBtn({caption='Back', name='goBack', hint='Retour au menu principal', onClick=Actions.goPage1, page=3})

    
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