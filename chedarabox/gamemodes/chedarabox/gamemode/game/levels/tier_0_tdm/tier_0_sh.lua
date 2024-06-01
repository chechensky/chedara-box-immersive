table.insert(LevelList,"tdm")
tdm = {}
tdm.Name = "Team Death Match"

local models = {}

for i = 1,9 do table.insert(models,"models/player/group01/male_0" .. i .. ".mdl") end

for i = 1,6 do table.insert(models,"models/player/group01/female_0" .. i .. ".mdl") end

--table.insert(models,"models/player/group02/male_02.mdl")
--table.insert(models,"models/player/group02/male_06.mdl")
--table.insert(models,"models/player/group02/male_08.mdl")

--for i = 1,9 do table.insert(models,"models/player/group01/male_0" .. i .. ".mdl") end

tdm.models = models
tdm.red = {
	"Terrorists",Color(255,75,75),
	weapons = {"weapon_sogknife","weapon_hands"},
	main_weapon = {""},
	secondary_weapon = {""},
	models = models
}


tdm.blue = {
	"Counter-Terrorists",Color(75,75,255),
	weapons = {"weapon_sogknife","weapon_hands"},
	main_weapon = {""},
	secondary_weapon = {""},
	models = models
}

tdm.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function tdm.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,red)
	team.SetColor(2,blue)

	if CLIENT then return end

	tdm.StartRoundSV()
end

if SERVER then return end

local colorRed = Color(255,0,0)

function tdm.GetTeamName(ply)
	local game = TableRound()
	local team = game.teamEncoder[ply:Team()]

	if team then
		team = game[team]

		return team[1],team[2]
	end
end

function tdm.ChangeValue(oldName,value)
	local oldValue = tdm[oldName]

	if oldValue ~= value then
		oldValue = value

		return true
	end
end

function tdm.AccurceTime(time)
	return string.FormattedTime(time,"%02i:%02i")
end