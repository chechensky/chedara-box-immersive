local function drawTextShadow(t,f,x,y,c,px,py)
	draw.SimpleText(t,f,x + 1,y + 1,Color(0,0,0,c.a),px,py)
	draw.SimpleText(t,f,x - 1,y - 1,Color(255,255,255,math.Clamp(c.a*.25,0,255)),px,py)
	draw.SimpleText(t,f,x,y,c,px,py)
end

local healthCol = Color(120,255,20)
function GM:HUDPaint()
	self:DrawRadialMenu()
	self:DrawMedKitMenu()
end

local tex = surface.GetTextureID("SGM/playercircle")
local gradR = surface.GetTextureID("gui/gradient")

local function colorDif(col1, col2)
	local x = col1.x - col2.x
	local y = col1.y - col2.y
	local z = col1.z - col2.z
	x = x > 0 and x or -x
	y = y > 0 and y or -y
	z = z > 0 and z or -z
	return x + y + z
end
local Health,Stamina,PersonTex,StamTex,HelTex,BGTex=0,0,surface.GetTextureID("vgui/hud/hmcd_person"),surface.GetTextureID("vgui/hud/hmcd_stamina"),surface.GetTextureID("vgui/hud/hmcd_health"),surface.GetTextureID("vgui/hud/hmcd_background")

function GM:GUIMousePressed(code, vector)
	--
end

local WHOTBackTab={
	["$pp_colour_addr"]=0,
	["$pp_colour_addg"]=0,
	["$pp_colour_addb"]=0,
	["$pp_colour_brightness"]=-.05,
	["$pp_colour_contrast"]=1,
	["$pp_colour_colour"]=0,
	["$pp_colour_mulr"]=0,
	["$pp_colour_mulg"]=0,
	["$pp_colour_mulb"]=0
}
local RedVision={
	["$pp_colour_addr"]=0,
	["$pp_colour_addg"]=0,
	["$pp_colour_addb"]=0,
	["$pp_colour_brightness"]=0,
	["$pp_colour_contrast"]=1,
	["$pp_colour_colour"]=1,
	["$pp_colour_mulr"]=0,
	["$pp_colour_mulg"]=0,
	["$pp_colour_mulb"]=0
}

function GM:GUIMousePressed(code, vector)
	return self:RadialMousePressed(code,vector)
end

function GM:GUIMousePressed(code, vector)
	return self:MedKitMousePressed(code,vector)
end