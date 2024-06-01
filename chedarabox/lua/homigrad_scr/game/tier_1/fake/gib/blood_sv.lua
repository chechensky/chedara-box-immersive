util.AddNetworkString("blood particle")
util.AddNetworkString("blood particle more")
util.AddNetworkString("blood particle explode")
util.AddNetworkString("blood particle headshoot")
util.AddNetworkString("blood particle arteryWHO")

function BloodParticle(pos,vel)
	net.Start("blood particle")
	net.WriteVector(pos)
	net.WriteVector(vel)
	net.Broadcast()
end

function BloodParticleMore(pos,vel)
	net.Start("blood particle more")
	net.WriteVector(pos)
	net.WriteVector(vel)
	net.Broadcast()
end

function BloodParticleExplode(pos)
	net.Start("blood particle explode")
	net.WriteVector(pos)
	net.Broadcast()
end

function BloodParticleHeadshoot(pos,vel)
	net.Start("blood particle headshoot")
	net.WriteVector(pos)
	net.WriteVector(vel)
	net.Broadcast()
end

function BloodParticleArtery(pos,vel,ply)
	net.Start("blood particle arteryWHO")
	net.WriteVector(pos)
	net.WriteVector(vel)
	net.WriteEntity(ply)
	net.Broadcast()
end

