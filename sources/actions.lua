-- Pakoskyfrog 2013

-----------------------------------------------------------
----    Action functions
-----------------------------------------------------------

------------------------
-- Description
--[[
    Centralisation of actions, call by buttons mostly.
]]

-----------------------------------------------------------
------------------------
--  Init
Actions = {}

function Actions.activateMainMenu()
    --------------------
    --  assigne primary state to the mainmenu
    Apps.state = CMainMenu:create()
    Apps.state:load()
end


function Actions.wip()
    --------------------
    --  Dummy function that indicates it's a work in progress
    Apps:addMsg("WIP : this is not implemented yet.")
end

function Actions:goPage1()
    --------------------
    --  Makes the menu goes back to the first page
    -- self is the button clicked
    self.parent:setCurrentPage(1)
end

function Actions:goPage2()
    --------------------
    --  Makes the menu goes to the new game page
    -- self is the button clicked
    self.parent:setCurrentPage(2)
end

function Actions:goPage3()
    --------------------
    --  Makes the menu goes to the options page
    -- self is the button clicked
    self.parent:setCurrentPage(3)
end

function Actions:goPage4()
    --------------------
    --  Makes the menu goes to the credits page
    -- self is the button clicked
    self.parent:setCurrentPage(4)
end

function Actions:goPage5()
    --------------------
    --  Makes the menu goes to the high score page
    -- self is the button clicked
    
    Actions.actualizeHS()
    self.parent:setCurrentPage(5)
end

function Actions.actualizeHS()
    --------------------
    --  will change the caption of the 10 buttons according to the HS
    
    local page = Apps.state.pages[5]
    print(highScores.getPageOptions(page))
    highScores.setPageButtons(page, highScores.getHS(highScores.getPageOptions(page)))
end

function Actions:selectMe()
    --------------------
    --  this will handle the selection of the buttons of the HS page
    -- btn.framed is used to have the selected parameter
    
    -- detect the line
    local n = self.name:sub(-1) -- n is d s or m
    
    -- reinit the line
    for name, btn in pairs(self.parent.pages[5].buttons) do
        if btn.name:sub(-1) == n then
            btn.framed = false
        end
    end
    
    -- select me
    self.framed = true
    
    -- actualize the list
    Actions.actualizeHS()
end


function Actions:nextOption()
    --------------------
    --  Will change button status to the next option
    self.optSelected = math.mod(self.optSelected, #self.options) + 1
    self:setCaption(self.prefix .. self.options[self.optSelected])
end

function Actions:adjustVolumeUp()
    --------------------
    --  Add 5 to volume, maxed out at 100
    self.optSelected = math.min(self.optSelected+5, 100)
    self:setCaption(self.prefix .. self.optSelected)
end

function Actions:adjustVolumeDown()
    --------------------
    --  Add -5 to volume, 0 is off
    self.optSelected = math.max(self.optSelected-5, 0)
    self:setCaption(self.prefix .. self.optSelected)
end

function Actions:launchGame()
    --------------------
    --  Will extract options and launch the game accordingly
    
    -- option transfert TODO
    local btns = Apps.state.pages[2].buttons
    local options = {}
    options.mode = btns.mode.options[btns.mode.optSelected]
    options.diff = btns.diff.options[btns.diff.optSelected]
    options.size = btns.size.options[btns.size.optSelected]
    
    Apps.state = CGame:create(options)
end

function Actions:restartGame()
    --------------------
    --  re-launch a game with previous options
    
    Apps.state = CGame:create(Apps.state.options)
end


function Actions:nullUnderState()
    --------------------
    --  set the underState to nil
    Apps.state.state = nil
end

function Actions:addPlayerName()
    --------------------
    --  ... in the high scores
    
    local name = self.parent.edit:getText()
    if name == '' then name = 'Player' end
    
    highScores.add(name, math.floor(Apps.state.hud.time), Apps.state.options.diff, Apps.state.options.size, Apps.state.options.mode)

    Actions.nullUnderState()
end

function Actions:showHelp()
    -- redirection
    if Apps.state.options.mode == 'Classic' then
        Actions.showHelpClassic()
    elseif Apps.state.options.mode == 'Alchemist' then
        Actions.showHelpAlchemist()
    end
end
function Actions.showHelpClassic()
    --------------------
    --  Will show usefull tips as an understate
    Apps.state.state = CHelpShow:create('classic',3) -- 3 pages on classic mode
end
function Actions.showHelpAlchemist()
    --------------------
    --  Will show usefull tips as an understate
    Apps.state.state = CHelpShow:create('alchemist',3)
end

