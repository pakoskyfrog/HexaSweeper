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
    Apps.state = CGame:create()
end

