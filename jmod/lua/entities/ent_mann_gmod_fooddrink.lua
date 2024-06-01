-- small food
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Mannytko"
ENT.PrintName = "EZ Small Consumable"
ENT.Category = "JMod - EZ Homicide"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.JModEZstorable = true
ENT.JModPreferredCarryAngles = Angle(0, 180, 0)
ENT.NoSitAllowed = true
-- format: multiline
local FoodModels = {
	"models/foodnhouseholditems/mcdburgerbox.mdl",
	"models/foodnhouseholditems/chipsfritos.mdl",
	"models/foodnhouseholditems/chipslays5.mdl",
	"models/foodnhouseholditems/chipslays3.mdl",
	"models/foodnhouseholditems/mcdfrenchfries.mdl",
	"models/jordfood/prongleclosedfilledgreen.mdl",
	"models/foodnhouseholditems/mcddrink.mdl",
	"models/foodnhouseholditems/juicesmall.mdl",
	"models/jorddrink/7upcan01a.mdl",
	"models/jorddrink/barqcan1a.mdl",
	"models/jorddrink/cozcan01a.mdl",
	"models/jorddrink/crucan01a.mdl",
	"models/jorddrink/dewcan01a.mdl",
	"models/jorddrink/foscan01a.mdl",
	"models/jorddrink/heican01a.mdl",
	"models/jorddrink/mongcan1a.mdl",
	"models/jorddrink/pepcan01a.mdl",
	"models/jorddrink/redcan01a.mdl",
	"models/jorddrink/sprcan01a.mdl"
}

if SERVER then
	function ENT:Initialize()
		if not self.RandomModel then
			self.RandomModel = table.Random(FoodModels)
		end

		if table.KeyFromValue(FoodModels, self.RandomModel) > 5 then
			self.Drink = true
		else
			self.Drink = false
		end

		self:SetModel(self.RandomModel)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		local Phys = self:GetPhysicsObject()
		if IsValid(Phys) then
			Phys:SetMass(10)
			Phys:Wake()
		end
	end

	function ENT:PhysicsCollide(data)
		if data.DeltaTime > .2 and data.Speed > 100 then
			self:EmitSound("snd_jack_hmcd_foodbounce.wav", 60, math.random(70, 130))
		end
	end

	function ENT:Use(ply)
		local Time = CurTime()
		local Alt = ply:KeyDown(JMod.Config.General.AltFunctionKey)
		if Alt then
			ply.EZnutrition = ply.EZnutrition or {
				NextEat = 0,
				Nutrients = 0
			}

			if ply.EZnutrition and ply.EZnutrition.NextEat and ply.EZnutrition.NextEat < Time then
				if ply.EZnutrition.Nutrients < 100 then
					local snd = (self.Drink == true and "snd_jack_hmcd_drink" .. math.random(1, 3) .. ".wav") or "snd_jack_hmcd_eat" .. math.random(1, 4) .. ".wav"
					sound.Play(snd, self:GetPos(), 60, math.random(90, 110))
					JMod.ConsumeNutrients(ply, math.random(3, 6))
					self:Remove()
				else
					JMod.Hint(ply, "nutrition filled")
				end
			end
		else
			self:EmitSound("snd_jack_hmcd_foodbounce.wav", 70, math.random(90, 110))
			ply:PickupObject(self)
			JMod.Hint(ply, "alt to eat")
			if ply.EZnutrition and ply.EZnutrition.NextEat and ply.EZnutrition.NextEat > Time and GetConVar("developer"):GetInt() >= 1 then
				print("NextEat:", math.Round(ply.EZnutrition.NextEat - Time, 1))
			end
		end
	end
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_mann_jmod_fooddrink", "EZ Small Consumable")
end