table.insert(LevelList,"gangwars")
gangwars = {}
gangwars.Name = "Gang Wars"

local models = {}

for i = 1,9 do table.insert(models,"models/player/group01/male_0" .. i .. ".mdl") end

for i = 1,6 do table.insert(models,"models/player/group01/female_0" .. i .. ".mdl") end

--table.insert(models,"models/player/group02/male_02.mdl")
--table.insert(models,"models/player/group02/male_06.mdl")
--table.insert(models,"models/player/group02/male_08.mdl")

--for i = 1,9 do table.insert(models,"models/player/group01/male_0" .. i .. ".mdl") end

gangwars.models = models
gangwars.red = {
	"Gang",Color(255,75,75),
	weapons = {"weapon_pocketknife","weapon_hands"},
	main_weapon = {"weapon_sib_remington870","weapon_sib_mosin"},
	secondary_weapon = {"weapon_sib_pm","weapon_sib_glock","weapon_sib_draco"},
	models = models
}


gangwars.blue = {
	"Police",Color(75,75,255),
	weapons = {"weapon_hands","tourniquet","medkit"},
	main_weapon = {"weapon_sib_m4a1"},
	secondary_weapon = {"weapon_sib_glock","weapon_sib_usp"},
	models = models
}

gangwars.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function gangwars.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,red)
	team.SetColor(2,blue)

	if CLIENT then return end

	gangwars.StartRoundSV()
end

if SERVER then return end

local colorRed = Color(255,0,0)

function gangwars.GetTeamName(ply)
	local game = TableRound()
	local team = game.teamEncoder[ply:Team()]

	if team then
		team = game[team]

		return team[1],team[2]
	end
end

function gangwars.ChangeValue(oldName,value)
	local oldValue = gangwars[oldName]

	if oldValue ~= value then
		oldValue = value

		return true
	end
end

function gangwars.AccurceTime(time)
	return string.FormattedTime(time,"%02i:%02i")
end