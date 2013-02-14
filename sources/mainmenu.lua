-- Pakoskyfrog 2013

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
setmetatable(CMainMenu, CMenu)

------------------------
--  Properties
CMainMenu.type = "CMainMenu"


------------------------
--  Constructor
function CMainMenu:create()
    local menu1 = CMenu.create()
    setmetatable(menu1, self)
    self.__index = self
    
    menu1:setTitle('Wrong Places  '..Apps.version)
    menu1:setAlignment('center')
    
    -- PAGE 1 : main redirection page
    menu1:addBtn({caption='New', name='new', hint='Launch the settings for a new game', onClick=Actions.goPage2}) --, onClick=func , page=2
    menu1:addBtn({caption='Options', name='options', hint='Music and sounds options', onClick=Actions.goPage3})
    menu1:addBtn({caption='High scores', name='highscore', hint='Displays the best scores !', onClick=Actions.goPage5})
    menu1:addBtn({caption='Achievements', name='achiev', hint='Displays what you have amazingly done !', onClick=Actions.wip})
    menu1:addBtn({caption='Credits', name='credits', hint='Shows the credits list', onClick=Actions.goPage4})
    
    -- PAGE 2 : new game
        -- TODO : add options capabylities inside the Class button
    menu1:addNewPage()
    menu1:addBtn({caption='Start the game', name='launchGame', hint='Launch the game', onClick=Actions.launchGame, page=2})

    menu1:addBtn({caption='Mode  Classic', name='mode', hint='Game modes', onClick=Actions.nextOption, page=2})
    menu1.pages[2].buttons.mode.options = {'Classic', 'Alchemist'}
    menu1.pages[2].buttons.mode.prefix = 'Mode  '
    menu1.pages[2].buttons.mode.optSelected = 1
    
    menu1:addBtn({caption='Difficulty  Normal', name='diff', hint='Games difficulties (5)', onClick=Actions.nextOption, page=2})
    menu1.pages[2].buttons.diff.options = {'Trivial', 'Easy', 'Normal', 'Tricky', 'Impossible'}
    menu1.pages[2].buttons.diff.prefix = 'Difficulty  '
    menu1.pages[2].buttons.diff.optSelected = 3
    
    menu1:addBtn({caption='Size  Small', name='size', hint='Game sizes (3)', onClick=Actions.nextOption, page=2})
    menu1.pages[2].buttons.size.options = {'Small', 'Normal', 'Big'}
    menu1.pages[2].buttons.size.prefix = 'Size  '
    menu1.pages[2].buttons.size.optSelected = 1
    
    menu1:addBtn({caption='Back', name='goBack', hint='Retour au menu principal', onClick=Actions.goPage1, page=2})
    
    -- PAGE 3 : options
    menu1:addNewPage()
    
    menu1:addBtn({caption='Music Volume  50', name='music', hint='Music volume controler', onRollDown=Actions.adjustVolumeDown, onRollUp=Actions.adjustVolumeUp, page=3})
    menu1.pages[3].buttons.music.prefix = 'Music Volume  '
    menu1.pages[3].buttons.music.optSelected = 50
    
    menu1:addBtn({caption='Effects Volume  50', name='effects', hint='Effects volume controler', onRollDown=Actions.adjustVolumeDown, onRollUp=Actions.adjustVolumeUp, page=3})
    menu1.pages[3].buttons.effects.prefix = 'Effects Volume  '
    menu1.pages[3].buttons.effects.optSelected = 50
    
    menu1:addBtn({caption='Back', name='goBack', hint='Retour au menu principal', onClick=Actions.goPage1, page=3})
    
    -- PAGE 4 : credits
    menu1:addNewPage()
    menu1:addBtn({caption='Pako Skyfrog 2013', name='me', hint='That\'s me ^^', page=4})
    menu1:addBtn({caption='Coded in Lua', name='lua', page=4})
    menu1:addBtn({caption='Love2D at http://love2d.org', name='love', page=4})
    menu1:addBtn({caption='Cliparts from http://openclipart.org', name='cliparts', page=4})
    menu1:addBtn({caption='Editor of choice : The Gimp', name='gimp', page=4})
    menu1:addBtn({caption='Editor of choice : Notepad++', name='notepad', page=4})
    
    menu1:addBtn({caption='Back', name='goBack', hint='Retour au menu principal', onClick=Actions.goPage1, page=4})

    -- PAGE 5 : high Scores
    menu1.pages[5] = highScores.generateMenuPage(menu1)
    
    return menu1
end


------------------------
--  Callbacks
function CMainMenu:load()
    --------------------
    --  once loader
    CMenu.load(self)
    
    self.titleFont = love.graphics.newFont('gfx/title.ttf', 100)
    self.menuFont  = love.graphics.newFont('gfx/menu2.ttf', 36)
    
    for i = 1, 3 do
        for name, btn in pairs(self.pages[i].buttons) do
            btn.selfFont = self.menuFont
            btn:setCaption(btn.caption) -- actualize dimensions
        end
    end
    
    -- actualize positions
    self:setAlignment('center')
    print('main menu loaded')
end

function CMainMenu:keypressed(key)
    if key == 'escape' then
        self:setCurrentPage(1)
    end
end


------------------------
--  Static functions


------------------------
--  Gets / Sets
function CMainMenu:getType() return self.type end



------------------------
--  Member functions




print "CMainMenu loaded"