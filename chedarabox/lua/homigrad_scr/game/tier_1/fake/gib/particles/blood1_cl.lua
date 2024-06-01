bloodparticels1 = bloodparticels1 or {}
bloodparticels3 = bloodparticels3 or {}

game.AddDecal("ChBlood1", "decals/checha/ch_blood1")
game.AddDecal("ChBlood3", "decals/checha/ch_blood3")
game.AddDecal("ChBlood4", "decals/checha/ch_blood4")

game.AddDecal("ArBlood1", "decals/checha/ar_blood1")
game.AddDecal("ArBlood2", "decals/checha/ar_blood2")
game.AddDecal("ArBlood3", "decals/checha/ar_blood3")
game.AddDecal("ArBlood4", "decals/checha/ar_blood4")
game.AddDecal("ArBlood5", "decals/checha/ar_blood5")
local bloodparticels_hook = bloodparticels_hook

local tr = {filter = function(ent) return not ent:IsPlayer() and not ent:IsRagdoll() end}

local vecDown = Vector(0,0,-40)
local vecZero = Vector(0,0,0)
local LerpVector = LerpVector

local math_random = math.random
local table_remove = table.remove

local util_Decal = util.Decal
local util_TraceLine = util.TraceLine
local render_SetMaterial = render.SetMaterial
local render_DrawSprite = render.DrawSprite

local bleeding_sound = {
    "homigrad/blooddrip1.wav",
    "homigrad/blooddrip2.wav",
    "homigrad/blooddrip3.wav",
    "homigrad/blooddrip4.wav",
    "bleeding/bleeding1.wav",
    "bleeding/bleeding2.wav",
    "bleeding/bleeding3.wav",
    "bleeding/bleeding4.wav",
    "bleeding/bleeding5.wav",
    "bleeding/bleeding6.wav",
    "bleeding/bleeding7.wav",
    "bleeding/bleeding8.wav",
    "bleeding/bleeding9.wav"
}

local venous_bloodpaint = {
    "ChBlood1",
    "ChBlood3",
    "ChBlood4"
}

local artery_bloodpaint = {
    "ArBlood1",
    "ArBlood2",
    "ArBlood3",
    "ArBlood4",
    "ArBlood5"
}
bloodparticels_hook[1] = function(anim_pos)
    for i = 1,#bloodparticels1 do
        local part = bloodparticels1[i]
        render_SetMaterial(part[4])
        render_DrawSprite(LerpVector(anim_pos,part[2],part[1]),part[5],part[6])
    end
end

bloodparticels_hook[2] = function(mul)
    for i = 1,#bloodparticels1 do
        local part = bloodparticels1[i]
        if not part then break end
        local pos = part[1]
        local posSet = part[2]
        tr.start = posSet
        tr.endpos = tr.start + part[3] * mul
        result = util_TraceLine(tr)
        local hitPos = result.HitPos
        if result.Hit then
            table_remove(bloodparticels1,i)
            local dir = result.HitNormal
        if part[7] != nil then
            if part[7]:GetNWBool("ArteryHit", false) == true then
                util_Decal(table.Random(artery_bloodpaint),hitPos + dir,hitPos - dir)
            else
                util_Decal(table.Random(artery_bloodpaint),hitPos + dir,hitPos - dir)
            end
        else 
            util_Decal(table.Random(venous_bloodpaint),hitPos + dir,hitPos - dir)
        end
            sound.Play(table.Random(bleeding_sound),hitPos,67,100)
            continue
        else
            pos:Set(posSet)
            posSet:Set(hitPos)
        end

        part[3] = LerpVector(0.01 * mul,part[3],vecZero)
        part[3]:Add(vecDown)
    end
end