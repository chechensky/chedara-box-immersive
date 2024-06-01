local value,gg

if CLIENT then
	value = 1

	net.Receive("info_staminamul",function()
		value = net.ReadFloat()
	end)
end

local jmod
if CLIENT then
	hook.Add("Move","homigrad",function(ply,mv)
		gg(ply,mv,value)
	end)

else
	hook.Add("Move","homigrad",function(ply,mv)
		gg(ply,mv,(ply.staminamul or 1))
	end)
end


gg = function(ply,mv,value)
	value = mv:GetMaxSpeed() * value

	ply:SetRunSpeed(Lerp((ply:IsSprinting() and mv:GetForwardSpeed() > 1) and 0.03 or 0.4,ply:GetRunSpeed(),(ply:IsSprinting() and mv:GetForwardSpeed() > 1) and 550 or ply:GetWalkSpeed()))
	ply:SetWalkSpeed(Lerp( (mv:GetForwardSpeed() > 1 and 0.03) or 1,ply:GetWalkSpeed(),(mv:GetForwardSpeed() > 1 and 200) or 90))
	ply:SetSlowWalkSpeed(Lerp( (ply:GetVelocity():Length() > 1 and 0.03) or 1,ply:GetSlowWalkSpeed(),(ply:GetVelocity():Length() > 1 and 100) or 20))


	mv:SetMaxSpeed(value)
	mv:SetMaxClientSpeed(value)

	local value = ply.EZarmor
	value = value and ply.EZarmor.speedfrac

	if value and value ~= 1 then
		value = mv:GetMaxSpeed() * math.max(value,0.75)
		mv:SetMaxSpeed(value)
		mv:SetMaxClientSpeed(value)
	end
end

hook.Remove("Move","JMOD_ARMOR_MOVE")