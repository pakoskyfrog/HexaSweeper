-- Pakoskyfrog 2013/02/09 14:12:38

-----------------------------------------------------------
----    highScores definition
-----------------------------------------------------------

------------------------
-- Description
--[[
    This will handle all about high scores.
]]

-----------------------------------------------------------
------------------------
--  Init
highScores = {}

------------------------
--  Static functions
function highScores.load()
    --------------------
    --  This will load previous scores and store them
    highScores.filename = 'hs.lua'
    
    -- does a list already exist ?
	if not love.filesystem.exists(highScores.filename) then
        highScores.createFirstHS()
    end

    -- loading...
    -- local chunk = love.filesystem.load(highScores.filename)
    -- highScores.HSList = chunk()
    
    local ok, chunk, result
    ok, chunk = pcall( love.filesystem.load, highScores.filename ) -- load the chunk safely
    if not ok then
      print('The following error happend: ' .. tostring(chunk))
    else
      ok, result = pcall(chunk) -- execute the chunk safely

      if not ok then -- will be false if there is an error
        print('The following error happened: ' .. tostring(result))
      end
    end
    highScores.HSList = result
    
    return true
end

function highScores.save()
    --------------------
    --  this will rewrite the scores into the file
    
    highScores.cutBestHS()
    
    local hsl = highScores.HSList
    
    local out = 'local hsl = {}\n'

    for modes, md in pairs(hsl) do
        out = out .. 'hsl.'..modes..' = {}\n'
        for diffs, d in pairs(md) do
            out = out .. 'hsl.'..modes..'.'..diffs..' = {}\n'
            for size, s in pairs(d) do
                out = out .. 'hsl.'..modes..'.'..diffs..'.'..size..' = {\n'
                for n = 1, #s do
                    out = out .. '  {\''..s[n][1]..'\', '..s[n][2]..'},\n'
                end
                out = out .. '}\n'
            end
        end
    end
    
    out = out .. '\nreturn hsl\n'
    
    local file = love.filesystem.newFile(highScores.filename)
	if not file:open("w") then return end
    file:write(out)
	return file:close()
end

local function sortScore(a, b)
	return a[2] < b[2]
end
function highScores.sortHS()
    --------------------
    --  this function sort the scores, fastest to slowest
    local hsl = highScores.HSList
    
    for modes, md in pairs(hsl) do
        for diffs, d in pairs(md) do
            for size, s in pairs(d) do
                for n = 1, #s do
                    table.sort(s, sortScore)
                end
                
            end
            
        end
        
    end
    
end

function highScores.cutBestHS()
    --------------------
    --  this function will cut the 10 best scores
    
    highScores.sortHS()
    
    local hsl = highScores.HSList
    
    for modes, md in pairs(hsl) do
        for diffs, d in pairs(md) do
            for size, s in pairs(d) do
                -- for n = 1, math.min(#s, 10) do
                if #s > 10 then
                    local tmp = {}
                    for n = 1,  10 do
                        tmp[n] = s[n]
                    end
                    s = tmp
                end
            end
            
        end
        
    end
end

local function secToString(sec)
    --------------------
    --  will convert seconds in M:S fomat
    local m,s
    m = math.floor(sec/60)
    s = sec - m*60
    local e = ''
    if s < 10 then e = '0' end
    return m..':'..e..s
end

-- TODO : make an iterator
function highScores.getHS(diff, size, mode, noConvert)
    --------------------
    --  will extract and format the high scores of given mode, size and difficulty
    
    -- parameters : ("var" : default)
    -- diff : one of 'Trivial', 'Easy', "Normal", 'Tricky', 'Impossible'
    -- size : one of 'Small', "Normal", 'Big'
    -- mode : "Classic", 'Alchemist'
    
    -- defaults
    if not (diff == 'Trivial' or  diff == 'Easy' or diff == 'Tricky' or diff == 'Impossible') then
        diff = 'Normal'
    end
    if not (size == 'Small' or size == 'Big') then
        size = 'Normal'
    end
    if not (mode == 'Alchemist') then
        mode = 'Classic'
    end
    
    --extract and reformat
    local out = {}
    local hsl = highScores.HSList
    local sub = hsl[mode][diff][size]
    
    for i = 1, #sub do
        if noConvert then
            out[i] = {sub[i][1], math.floor(sub[i][2])}
        else
            out[i] = {sub[i][1], secToString(math.floor(sub[i][2]))}
        end
    end
    
    return out
end

function highScores.add(name, time, diff, size, mode)
    --------------------
    --  Will add a score to the list
    
    -- parameters : ("var" : default)
    -- name : Name of the player < 12 char (via CEdit)
    -- time : integer, seconds
    -- diff : one of 'Trivial', 'Easy', "Normal", 'Tricky', 'Impossible'
    -- size : one of 'Small', "Normal", 'Big'
    -- mode : "Classic", 'Alchemist'
    
    -- defaults
    if not (diff == 'Trivial' or  diff == 'Easy' or diff == 'Tricky' or diff == 'Impossible') then
        diff = 'Normal'
    end
    if not (size == 'Small' or size == 'Big') then
        size = 'Normal'
    end
    if not (mode == 'Alchemist') then
        mode = 'Classic'
    end
    
    
    -- insert
    local hsl = highScores.HSList
    local sub = hsl[mode][diff][size]
    sub[#sub+1] = {name, time}
    
    -- sort
    highScores.sortHS()
    -- cut
    highScores.cutBestHS()
    
    -- save
    highScores.save()
end

function highScores.createFirstHS()
    --------------------
    --  this will create a dummy list of high scores
    
    local modes = {'Classic', 'Alchemist'}
    local diffs = {'Trivial', 'Easy', "Normal", 'Tricky', 'Impossible'}
    local sizes = {'Small', "Normal", 'Big'}
    local names = {'\'Pako\'', '\'Alice\'', '\'Bob\''}
    local score = {60, 90, 120}
    local coefs = {1, 1.5, 2, 3, 4}
    
    local out = 'local hsl = {}\n'
    
    for md = 1, #modes do
        out = out .. 'hsl.'..modes[md]..' = {}\n'
        for d = 1, #diffs do
            out = out .. 'hsl.'..modes[md]..'.'..diffs[d]..' = {}\n'
            for s = 1, #sizes do
                out = out .. 'hsl.'..modes[md]..'.'..diffs[d]..'.'..sizes[s]..' = {\n'
                for n = 1, #names do
                    out = out .. '  {'..names[n]..', '..tostring(score[n]*coefs[s]*(coefs[d]+1))..'},\n'
                end
                out = out .. '}\n'
            end
            
        end
        
    end
    
    out = out .. '\nreturn hsl\n'
    
    local file = love.filesystem.newFile(highScores.filename)
	if not file:open("w") then return end
    file:write(out)
	return file:close()
end

function highScores.generateMenuPage(parent)
    --------------------
    --  will return a page for the mainmenu
    
    local dx, dy = 15, 5
    local diffs = {'Trivial', 'Easy', 'Normal', 'Tricky', 'Impossible'}
    local sizes = {'Small', 'Normal', 'Big'}
    local modes = {'Classic', 'Alchemist'}
    local page = {ypos = 115, btnCount = 0, buttons = {}}
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    
    do
        local xsum = 0
        for d = 1, #diffs do
            local b = CButton:create(parent, diffs[d], 0, page.ypos, 'default')
            b.name = diffs[d]..'d'
            b.onClick = Actions.selectMe
            page.buttons[b.name] = b
            xsum = xsum + b.width
        end
        local sx = (w-(xsum + (#diffs-1)*dx))/2
        xsum = sx
        for d = 1, #diffs do
            page.buttons[diffs[d]..'d'].pos.x = xsum
            xsum = xsum + page.buttons[diffs[d]..'d'].width + dx
        end
        page.ypos = page.ypos + page.buttons[diffs[1]..'d'].height + dy
        page.buttons[diffs[1]..'d'].framed = true
        page.btnCount = page.btnCount + #diffs
    end
    do
        local xsum = 0
        for s = 1, #sizes do
            local b = CButton:create(parent, sizes[s], 0, page.ypos, 'default')
            b.name = sizes[s]..'s'
            b.onClick = Actions.selectMe
            page.buttons[b.name] = b
            xsum = xsum + b.width
        end
        local sx = (w-(xsum + (#sizes-1)*dx))/2
        xsum = sx
        for s = 1, #sizes do
            page.buttons[sizes[s]..'s'].pos.x = xsum
            xsum = xsum + page.buttons[sizes[s]..'s'].width + dx
        end
        page.ypos = page.ypos + page.buttons[sizes[1]..'s'].height + dy
        page.buttons[sizes[1]..'s'].framed = true
        page.btnCount = page.btnCount + #sizes
    end
    do
        local xsum = 0
        for m = 1, #modes do
            local b = CButton:create(parent, modes[m], 0, page.ypos, 'default')
            b.name = modes[m]..'m'
            b.onClick = Actions.selectMe
            page.buttons[b.name] = b
            xsum = xsum + b.width
        end
        local sx = (w-(xsum + (#modes-1)*dx))/2
        xsum = sx
        for m = 1, #modes do
            page.buttons[modes[m]..'m'].pos.x = xsum
            xsum = xsum + page.buttons[modes[m]..'m'].width + dx
        end
        page.ypos = page.ypos + page.buttons[modes[1]..'m'].height + dy
        page.buttons[modes[1]..'m'].framed = true
        page.btnCount = page.btnCount + #modes
    end
    
    do
        page.ypos = page.ypos + dy
        local clr = {200,200,200,100}
        for h = 1, 10 do
            local b = CButton:create(parent, 'Amonymous 99:99', 0, page.ypos, 'default')
            b.name = 'btnHS'..tostring(h-1)
            b.hasBG = true
            b.colors.bg = clr
            b.pos.x = (w-b.width)/2
            page.buttons[b.name] = b
            b.visible = false
            page.ypos = page.ypos + b.height + dy
        end
        
    end
    
    
    do
        local b = CButton:create(parent, 'Back', 0, page.ypos+dy)
        b.pos.x = (w-b.width)/2
        b.name = 'back'
        b.onClick = Actions.goPage1
        page.buttons[b.name] = b
        page.btnCount = page.btnCount + 1
    end
    
    page.setAlignment = function () do end end
    
    print('HS page generated')
    return page
end

function highScores.getPageOptions(page)
    --------------------
    --  will extract the selected option on the high score page
    
    local res = {}
    local up = {d='diffs', s='sizes', m='modes'}
    
    for name, btn in pairs(page.buttons) do
        if btn.framed then
            local n = name:sub(-1) -- n is d s or m
            res[up[n]] = btn.caption
        end
    end
    
    return res.diffs, res.sizes, res.modes
end

function highScores.setPageButtons(page, captions)
    --------------------
    --  will update HS captions
    
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    
    for i = 1, 10 do
        local b = page.buttons['btnHS'..tostring(i-1)]
        if captions[i] then
            b:setCaption(captions[i][1]..'  '..captions[i][2])
            b.pos.x = (w-b.width)/2
            b.visible = true
        else
            b.visible = false
        end
    end
    
end


highScores.load()
print "highScores loaded"