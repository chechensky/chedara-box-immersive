--
if SERVER then
    hook.Add("UpdateAnimation","fwep-attachmetfixer",function(ply,event,data)
        ply:RemoveGesture(ACT_GMOD_NOCLIP_LAYER)
    end)
end

function SWEP:ReloadSound()
    local ply = self:GetOwner()
    for k,v in pairs(self.ReloadSounds) do
        if istable(k) then return end
        timer.Create(k.."snd"..self:EntIndex(),tonumber( k, 10 ) or 0.1,1,function()
            if IsValid(ply:GetActiveWeapon()) and self:IsValid() and ply:GetActiveWeapon():GetClass() == self:GetClass()then
                if v[1] then
                    self:EmitSound(v[1], 55, 100, 1, CHAN_AUTO)
                end
            end
        end)
    end
end

skins = {
	superadmin = true,
	premium = true,
	admin = true
}