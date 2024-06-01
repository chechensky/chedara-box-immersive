table.insert(LevelList,"survival")
survival = {}
survival.Name = "Survival - Looter Shooter"

survival.models = models
survival.red = {
	"PMC Faggots",Color(154,146,146),
	weapons = {"weapon_kabar","weapon_hands"},
	main_weapon = {""},
	secondary_weapon = {""},
	models = "models/player/dod_american.mdl"
}


survival.blue = {
	"PMC Assholes",Color(232,227,227),
	weapons = {"weapon_sogknife","weapon_hands"},
	main_weapon = {""},
	secondary_weapon = {""},
	models = "models/player/dod_german.mdl"
}

survival.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function survival.StartRound()
	game.CleanUpMap(false)
	playsound = true
	team.SetColor(1,red)
	team.SetColor(2,blue)

	if CLIENT then return end

	survival.StartRoundSV()
end

if SERVER then return end

local colorRed = Color(255,0,0)

function survival.GetTeamName(ply)
	local game = TableRound()
	local team = game.teamEncoder[ply:Team()]

	if team then
		team = game[team]

		return team[1],team[2]
	end
end

function survival.ChangeValue(oldName,value)
	local oldValue = survival[oldName]

	if oldValue ~= value then
		oldValue = value

		return true
	end
end

function survival.AccurceTime(time)
	return string.FormattedTime(time,"%02i:%02i")
end