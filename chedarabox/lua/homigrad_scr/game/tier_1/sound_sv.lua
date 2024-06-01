util.AddNetworkString("sound")
function sound.Emit(ent,sndName,level,volume,pitch,ignorePly,dsp)
    net.Start("sound")
    net.WriteTable({sndName,ent:GetPos(),ent:EntIndex(),level,volume,pitch,dsp})
    if ignorePly then
        net.SendOmit(ignorePly)
    else
        net.Broadcast()
    end
end

util.AddNetworkString("sound surface")
function sound.EmitSurface(ply,sndName)
    net.Start("sound surface")
    net.WriteString(sndName)
    net.Send(ply)
end

local function logic(output,input,isChat,teamonly)
	local result,is3D = hook.Run("Player Can Lisen",output,input,isChat,teamonly)
		if result ~= nil then return result,is3D end

		if output:Alive() and input:Alive() and not output.Otrub and not input.Otrub then
			if input:GetPos():DistToSqr(output:GetPos()) < 800000 and not teamonly then
				return true,true
			else
				return false
			end
		elseif not output:Alive() and not input:Alive() then
			return true
		else
			if not input:Alive() and output:Alive() then return true,true end
			if not output:Alive() and input:Team() == 1002 and input:Alive() then return true end

			return false
		end
end

hook.Add("PlayerCanSeePlayersChat","RealiticChar",function(text,teamonly,input,output)
	if not IsValid(output) then return end
    if string.StartWith(text,"// ") then return true end

	return logic(output,input,true,false)
end)

hook.Add("PlayerCanHearPlayersVoice","RealisticVoice", function(input,output)
	local result,is3D = logic(output,input,false,false)
	local speak = output:IsSpeaking()
	output.IsSpeak = speak

	if output.IsOldSpeak ~= speak then
		output.IsOldSpeak = speak

		if speak then hook.Run("Player Start Voice",output) else hook.Run("Player End Voice",output) end
	end

	return result,is3D
end)

hook.Add( "PlayerDeathSound", "CustomPlayerDeath", function( ply ) return true end)
