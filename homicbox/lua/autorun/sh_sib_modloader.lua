
dristec = dristec or {}

local function AddFile(File, dir)
    local fileSide = string.lower(string.Left(File, 3))
    
    if SERVER and fileSide == "sv_" then
        include(dir..File)
    elseif fileSide == "sh_" then
        if SERVER then 
            AddCSLuaFile(dir..File)
        end
        include(dir..File)
    elseif fileSide == "cl_" then
        if SERVER then
            AddCSLuaFile(dir..File)
        else
            include(dir..File)
        end
    else
        if SERVER then 
            AddCSLuaFile(dir..File)
        end
        include(dir..File)
    end
end

local function IncludeDir(dir)
    dir = dir .. "/"
    local files, directories = file.Find(dir.."*", "LUA")

    if files then
        for k, v in ipairs(files) do
            if string.EndsWith(v, ".lua") then
                AddFile(v, dir)
            end
        end
    end

    if directories then
        for k, v in ipairs(directories) do
            IncludeDir(dir..v)
        end
    end
end

local function Run()
    local time = SysTime()
    print("Loading sib weapons.")

    dristec.loaded = false

    IncludeDir("salatisbase")

    dristec.loaded = true

    print("Loaded sib weapons, "..tostring(math.Round(SysTime() - time,5)).." seconds needed")
end

hook.Add("InitPostEntity","loadaddon",function()
	Run()
end)

if dristec.loaded then
    Run()
end

--not complicated and works for me