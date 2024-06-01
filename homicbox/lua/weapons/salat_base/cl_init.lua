--
include( "sh_bullet.lua" )
include( "sh_util.lua" )
include( "shared.lua" )

viewShootPunch = Angle(0,0,0)

net.Receive("huysound",function(len)
	local pos = net.ReadVector()
	local sound = net.ReadString()
	local farsound = net.ReadString()
	local ent = net.ReadEntity()

	if ent == LocalPlayer() then return end

	local dist = LocalPlayer():EyePos():Distance(pos)
	if ent:IsValid() and dist < 4000 then
		ent:EmitSound(sound,100,math.random(90,110),1,CHAN_WEAPON,0,0)
	elseif ent:IsValid() then
        timer.Simple(dist/45000,function()
		    ent:EmitSound(farsound,120,math.random(90,110),1,CHAN_WEAPON,0,0)
        end)
	end
end)

function SWEP:ShootPunch(force)
    force = force/50
    viewShootPunch.x = math.Clamp(viewShootPunch.x - ((self.HoldType == "revolver" and force*5) or force),-force*5,0)
    viewShootPunch.y = math.Clamp(viewShootPunch.y+math.random(-force,force)*0.5,-force,force)
	viewShootPunch.z = math.Clamp(viewShootPunch.z+math.random(-force,force)*15,-force,force)
	self.setAng = self:GetOwner():EyeAngles()+viewShootPunch/3
	self.setAng.z = 0
	self.eyeSpray:Add(Angle(-force/1.5,viewShootPunch.y/5,0))
    return viewShootPunch
end

function draw.Circle( x, y, radius, seg )
    local cir = {}

    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    for i = 0, seg do
        local a = math.rad( ( i / seg ) * -360 )
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end

    local a = math.rad( 0 ) -- This is needed for non absolute segment counts
    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    surface.DrawPoly( cir )
end


local rtsize = 512


local vecZero = Vector(0,0,0)
local angZero = Angle(0,0,0)


function surface.DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )
	
	local c = math.cos( math.rad( rot ) )
	local s = math.sin( math.rad( rot ) )
	
	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s
	
	surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )
	
end

function SWEP:DrawHUD()
    if !self.DrawScope then return end
    ply = self:GetOwner()
    local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
    local muzzle = self:GetAttachment(self:LookupAttachment("muzzle"))
    local rt = {
        x = 0,
        y = 0,
        w = 512,
        h = 512,
        angles = muzzle.Ang+self.ScopeAdjust,
        origin = muzzle.Pos+self.addPos,
        drawviewmodel = false,
        fov = self.ScopeFov,
        znear = 1,
        zfar = 26000
    }
    rt.angles[3] = rt.angles[3] -180
    render.PushRenderTarget(self.rtmat, 0, 0, 512, 512)
        local old = DisableClipping(true)
        render.Clear(1,1,1,255)
        render.RenderView( rt )

        cam.Start2D()
            surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
            surface.SetMaterial( self.ScopeMat ) -- Use our cached material
            surface.DrawTexturedRectRotated( 256, 256, self.ScopeSize * 1000, self.ScopeSize * 1000, self.ScopeRot or 0 ) -- Actually draw the rectangl
        cam.End2D()
        DisableClipping(old)
    render.PopRenderTarget()
end