SWEP.Base = 'weapon_food_base'

SWEP.PrintName = "Пиво"
SWEP.Author = "Homicbox"
SWEP.Purpose = "Обычное бутылочное пиво"
SWEP.Category = "Еда"

SWEP.Slot = 3
SWEP.SlotPos = 3
SWEP.Spawnable = true

SWEP.ViewModel = "models/foodnhouseholditems/beer_stoltz.mdl"
SWEP.WorldModel = "models/foodnhouseholditems/beer_stoltz.mdl"


SWEP.Healsound = Sound("eating_&_drinking/drinking.wav")
SWEP.Satiety = 0.05
SWEP.EatsCounts = 6

SWEP.DrawWorldModelPos = Vector(3.5, -1.5, 3.5)
SWEP.DrawWorldModelAng = Angle(180, 0, 0)

function SWEP:PrimaryAttack()
	--self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	if SERVER then
		self:GetOwner().hungryregen = self:GetOwner().hungryregen + self.Satiety
		self.EatsCounts = self.EatsCounts - 1
		sound.Play(self.Healsound, self:GetPos(),75,100,1.5)
        self:SetNextPrimaryFire( CurTime() + 1 )
        self:GetOwner().painlosing = self:GetOwner().painlosing + 0.1

        if self:GetOwner().painlosing > 3 then
            self:GetOwner().painlosing = self:GetOwner().painlosing + 2
        end
        
        if self.EatsCounts <= 0 then
            self:Remove()
		    self:GetOwner():SelectWeapon("weapon_hands")
        end
	end
	if CLIENT then
        self:SetNextPrimaryFire( CurTime() + 1 )
        SIB_Alchogol = SIB_Alchogol + 0.1
	end
end