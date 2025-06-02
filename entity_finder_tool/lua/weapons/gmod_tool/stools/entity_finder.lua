TOOL.Category = "Render"
TOOL.Name = "Entity Finder"
TOOL.Command = nil
TOOL.ConfigName = ""
TOOL.Information = {
    { name = "left", text = "Mark nearest entity to aim point" },
    { name = "right", text = "Remove all marks" },
    { name = "reload", text = "Mark nearest entity to player" }
}

if CLIENT then
    haloEnts = {}
    hook.Add("PreDrawHalos", "EntityFinder_Halos", function()
        halo.Add(haloEnts, Color(255, 0, 0), 5, 5, 4, true, true)
    end)
end

local markedEntities = {}

local function IsAlreadyMarked(ent)
    for _, marked in ipairs(markedEntities) do
        if not IsValid(marked) then continue end  -- Skip invalid entities
        if marked == ent then return true end
        if marked:GetNWBool("EntityFinder_Orb") and IsValid(marked:GetNWEntity("EntityFinder_Target")) then
            if marked:GetNWEntity("EntityFinder_Target") == ent then 
                return true 
            end
        end
    end
    return false
end

local function IsIgnored(ent, ply)
    if not IsValid(ent) then return true end
    if ent:IsPlayer() or ent:IsWeapon() or ent:GetClass() == "predicted_viewmodel" or ent:GetClass() == "gmod_hands" or ent:GetClass() == "manipulate_flex" or ent:GetClass() == "manipulate_bone" then return true end
    if ent:IsWorld() then return true end
    if ent.GetOwner and ent:GetOwner() == ply then return true end
    return false
end

local function FindNearestEntity(pos, ply)
    local nearestEnt = nil
    local nearestDist = math.huge
    for _, ent in ipairs(ents.GetAll()) do
        if not IsIgnored(ent, ply) and not IsAlreadyMarked(ent) then
            local dist = ent:GetPos():DistToSqr(pos)
            if dist < nearestDist then
                nearestDist = dist
                nearestEnt = ent
            end
        end
    end
    return nearestEnt
end

local function IsTiny(ent)
    local mins, maxs = ent:OBBMins(), ent:OBBMaxs()
    local size = (maxs - mins):Length()
    return size < 50  -- Keep your improved tiny threshold
end

local function ShouldUseOrb(ent)
    if ent:GetClass() == "npc_enemyfinder" then
        return true
    end
    
    if IsTiny(ent) then return true end
    local model = ent:GetModel() or ""
    if not util.IsValidModel(model) or model:lower() == "models/error.mdl" then
        return true
    end
    return false
end

local function SpawnOrb(pos, targetEnt)
    local orb = ents.Create("prop_physics")
    if not IsValid(orb) then return nil end
    orb:SetModel("models/props_junk/watermelon01.mdl")
    orb:SetPos(pos)
    orb:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    orb:SetMoveType(MOVETYPE_NONE)
    orb:SetRenderMode(RENDERMODE_TRANSCOLOR)
    orb:SetColor(Color(255, 0, 0, 120))  -- Keep transparency
    orb:Spawn()
    orb:SetModelScale(1.5)  -- Keep your scaled size

    local phys = orb:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end

    orb:SetNWBool("EntityFinder_Orb", true)
    if IsValid(targetEnt) then
        orb:SetNWEntity("EntityFinder_Target", targetEnt)
    end
    return orb
end

local function MarkEntity(ply, ent)
    if not IsValid(ent) then return end

    local name = ent:GetClass() or "unknown"
    local distance = ent:GetPos():Distance(ply:GetPos())
    local pos = ent:GetPos()
    local posStr = string.format("(%.2f, %.2f, %.2f)", pos.x, pos.y, pos.z)

    if SERVER then
        if ShouldUseOrb(ent) then
            local orb = SpawnOrb(pos, ent)
            if IsValid(orb) then
                table.insert(markedEntities, orb)
                ply:ChatPrint(string.format("[EntityFinder] (Orb) %s at %.2f units - %s", name, distance, posStr))
                ply:SendLua("table.insert(haloEnts, Entity(" .. orb:EntIndex() .. "))")
            end
        else
            ent:SetNWBool("EntityFinder_Marked", true)
            table.insert(markedEntities, ent)
            ply:ChatPrint(string.format("[EntityFinder] %s at %.2f units - %s", name, distance, posStr))
            ply:SendLua("table.insert(haloEnts, Entity(" .. ent:EntIndex() .. "))")
        end

        -- New visibility check with trace
        local needsViewAdjustment = distance > 2000
        if not needsViewAdjustment then
            -- Check if entity is visible
            local traceData = {
                start = ply:EyePos(),
                endpos = pos,
                filter = {ply, ent} -- Ignore player and the entity itself
            }
            local trace = util.TraceLine(traceData)
            needsViewAdjustment = trace.Hit
        end

        if needsViewAdjustment then
            local dir = (pos - ply:GetPos()):GetNormalized()
            local ang = dir:Angle()
            ply:SetEyeAngles(Angle(ang.p, ang.y, 0))
        end
    end
end

local function UnmarkAll(ply)
    for _, ent in ipairs(markedEntities) do
        if IsValid(ent) then
            if ent:GetNWBool("EntityFinder_Orb") then
                ent:Remove()
            else
                ent:SetNWBool("EntityFinder_Marked", false)
            end
        end
    end
    markedEntities = {}
    if SERVER then
        ply:SendLua("haloEnts = {}")
    end
end

hook.Add("PlayerDeath", "EntityFinder_ClearMarks", function(ply)
    UnmarkAll(ply)
end)

function TOOL:LeftClick(trace)
    if CLIENT then return true end

    local ply = self:GetOwner()
    local targetPos = trace.HitPos
    local nearestEnt = FindNearestEntity(targetPos, ply)
    if nearestEnt then
        MarkEntity(ply, nearestEnt)
    end
    return true
end

function TOOL:RightClick(trace)
    if CLIENT then return true end
    local ply = self:GetOwner()
    UnmarkAll(ply)
    return true
end

function TOOL:Reload(trace)
    if CLIENT then return true end

    local ply = self:GetOwner()
    local nearestEnt = FindNearestEntity(ply:GetPos(), ply)
    if nearestEnt then
        MarkEntity(ply, nearestEnt)
    end
    return true
end