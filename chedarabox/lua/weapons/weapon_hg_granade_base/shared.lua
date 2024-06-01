SWEP.Base = "weapon_base"

SWEP.PrintName = "База Гаранаты"
SWEP.Author = "kek"
SWEP.Purpose = "Бах Бам Бум, Бадабум!"

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.Spawnable = false

SWEP.ViewModel = "models/pwb/weapons/w_f1.mdl"
SWEP.WorldModel = "models/pwb/weapons/w_f1.mdl"

SWEP.Granade = ""

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function TrownGranade(ply,force,granade)
    local granade = ents.Create(granade)
    granade:SetPos(ply:GetShootPos() +ply:GetAimVector()*10)
	granade:SetAngles(ply:EyeAngles()+Angle(45,45,0))
	granade:SetOwner(ply)
	granade:SetPhysicsAttacker(ply)
    granade:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	granade:Spawn()       
	granade:Arm()
	local phys = granade:GetPhysicsObject()              
	if not IsValid(phys) then granade:Remove() return end                         
	phys:SetVelocity(ply:GetVelocity() + ply:GetAimVector() * force)
	phys:AddAngleVelocity(VectorRand() * force/2)
end

function SWEP:Deploy()
    self:SetHoldType( "knife" )
end

function SWEP:PrimaryAttack()
    if SERVER then    
        TrownGranade(self:GetOwner(),750,self.Granade)
        self:Remove()
        self:GetOwner():SelectWeapon("weapon_hands")
    elseif CLIENT then
    end
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("weapons/m67/handling/m67_throw_01.wav")
end

function SWEP:SecondaryAttack()
    if SERVER then
        TrownGranade(self:GetOwner(),250,self.Granade)
        self:Remove()
        self:GetOwner():SelectWeapon("weapon_hands")
    elseif CLIENT then
    end
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("weapons/m67/handling/m67_throw_01.wav")
end


function SWEP:Reload()
    if SERVER then
        if self.Armed then return end
        if self.DoNotArm then return end

        local ply = self:GetOwner()
        local granade = ents.Create(self.Granade)

        if ply:KeyDown(IN_WALK) and self.Trap then
            
            local tr = util.TraceHull( {
                start = self:GetOwner():EyePos(),
                endpos = self:GetOwner():EyePos() + ( self:GetOwner():GetAimVector() * 100 ),
                filter = self:GetOwner(),
                mins = Vector(-1.5,-1.5,-1.5),
                maxs = Vector(1.5,1.5,1.5),
            })
        
            print(tr.Entity)
            if not IsValid(tr.Entity) and not tr.HitWorld then return end

            self.ArmedEnt = granade
            self.Armed = true
            
            granade:SetPos(tr.HitPos)
            granade:SetAngles(tr.HitNormal:Angle())
            granade:SetNoDraw(false)
            granade:Spawn()

            granade:EmitSound( "snd_jack_hmcd_click.wav", 60, 100, 1, CHAN_AUTO )
            
            granade.Constraint = constraint.Weld(granade, tr.Entity, 0, 0, 300, false, false)
            granade:EmitSound( "snd_jack_hmcd_detonator.wav", 60, 100, 1, CHAN_AUTO )
            
            timer.Simple(0, function()
                granade.Constraint:CallOnRemove( "RigGrenade", function( ent ) granade:Arm(1) end)
            end)

            self:Remove()
            self:GetOwner():SelectWeapon("weapon_hands")
        end
    end
end

function SWEP:OnDrop()
    if SERVER then
        local grenarm

        if not self.Armed then
            granade = ents.Create(self.Granade)
            grenarm = granade
        else
            grenarm = self.ArmedEnt
            grenarm:SetParent()
        end
        
        local ply = self:GetOwner()
        --local force = 15

        grenarm:SetNoDraw(false)
        --grenarm:SetPos(ply:GetShootPos() + ply:GetAimVector() * 10)
	    --grenarm:SetAngles(ply:EyeAngles()+Angle(45,45,0))
	    grenarm:SetOwner(ply)
	    --grenarm:SetPhysicsAttacker(ply)
        --grenarm:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        --[[local phys = grenarm:GetPhysicsObject()              
	    if not IsValid(phys) then grenarm:Remove() return end                         
	    phys:SetVelocity(ply:GetVelocity() + ply:GetAimVector() * force)
	    phys:AddAngleVelocity(VectorRand() * force/2)]]
    end
end