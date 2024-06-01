local spawns = {
    ["rp_truenorth_v1a"] = {
        Vector(-2952, 14210, 200),
        Vector(-703, 11371, 185),
        Vector(12290, 13146, 109),
        Vector(12515, 6488, 317),
        Vector(15366, -8413, 77),
        Vector(14036, -5350, 205),
        Vector(13645, -6290, 333),
        Vector(15187, -2086, 45),
        Vector(-1533, -6899, 4432),
        Vector(-9355, -15436, 4152),
        Vector(11154, -15290, 111),
        Vector(-11579, 15667, -134)
    },
    ["rp_asheville"] = {
        Vector(-11541, 1115, -132),
		Vector(-9433, -14778, 60),
        Vector(278, -12509, 254),
        Vector(278, -12509, 254),
        Vector(14010, 12582, 224),
		Vector(8253, 2395, -356)
    }
}

hook.Add("PlayerSpawn","homicebox-randomspawn",function(ply)
	if PLYSPAWN_OVERRIDE then return end
    if spawns[game.GetMap()] then
        ply:SetPos(table.Random(spawns[game.GetMap()]))
    end
end)