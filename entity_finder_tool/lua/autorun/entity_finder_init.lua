if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("weapons/gmod_tool/stools/entity_finder.lua")
end

-- Universal language registration
hook.Add("Initialize", "EntityFinder_Lang", function()
    if CLIENT then
        language.Add("tool.entity_finder.name", "Entity Finder")
        language.Add("tool.entity_finder.desc", "Detects and marks the nearest entity to your aim point or player position")
        language.Add("tool.entity_finder.left", "Left click to mark nearest entity to aim point")
        language.Add("tool.entity_finder.right", "Right click to remove all marks")
        language.Add("tool.entity_finder.reload", "Press R to mark nearest entity to player")
    end
end)