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
