function get_filtered_amount(amount)
    -- spawn deep core ore chunks depending on the ore patch removed amount
    -- 10 000 = 3%
    -- 300% = 1 000 000
    -- Set to 10% of amount by removing ore patch and max 1 000 chunks (stacks to 100, so 10 stacks to be transportable)
    -- Yields 100 per refine, so total = 1 000 000
    local amountospawn = 0.1 * amount
    -- prevent too much spawning if amount is over the top (ie creative mod / cheating, etc).
    if amountospawn > 1000 then
        amountospawn = 1000
    elseif amountospawn < 10 then
        amountospawn = 10
    end
    
    return amountospawn
end


function spawn_ore_patch_on_depleted_ore(event)
    local ore = event.entity
    local surface = ore.surface
    local areaToScan = Position.expand_to_area(ore.position, 10)
    local patchableOres = {
        ["iron-ore"] = "iron-ore",
        ["copper-ore"] = "copper-ore",
        ["coal"] = "coal",
        ["stone"] = "stone",
        ["uranium-ore"] = "uranium-ore"
    }
    local minspawnrange = settings.global["vtk-deep-core-mining-spawn-radius-from-start"].value
    local minrichness = settings.global["vtk-deep-core-mining-patch-min-richness"].value
    local maxrichness = settings.global["vtk-deep-core-mining-patch-max-richness"].value
    
    -- since it is a user setting, it is possible to break things up, making sure this won't
    if minrichness > maxrichness then
        minrichness = maxrichness
    end

    if game.active_mods["angelsrefining"] then
        local angelsores = {
            ["angels-ore1"] = "angels-ore1", 
            ["angels-ore2"] = "angels-ore2", 
            ["angels-ore3"] = "angels-ore3", 
            ["angels-ore4"] = "angels-ore4", 
            ["angels-ore5"] = "angels-ore5", 
            ["angels-ore6"] = "angels-ore6"
        }
        patchableOres = table.merge(patchableOres, angelsores)
    end

    -- Add support for Dirty Mining of supported ore patches
    if game.active_mods["DirtyMining"] then
        local dirtyores = {}
        for orename, oreresult in pairs(patchableOres) do
            dirtyores = table.merge(dirtyores, {['dirty-ore-'..orename] = oreresult})
        end
        patchableOres = table.merge(patchableOres, dirtyores)
    end
    
    -- logic : 
    -- - depleted ore has an equivalent patch entity
    -- - 10% chance to spawn an ore patch on depletion
    -- - check if there isn't a nearby ore patch already
    -- - then spawn it on the location the ore was depleted
    
    -- debug
    -- local player = game.players[1]
    -- player.print("VTK-DEEP-CORE-MINING_DEBUG")
    -- player.print("mined ore : "..serpent.block(ore.name))
    -- player.print(serpent.block(player))
    
    local validOre = false
    local orePatchToSpawn = nil
    for patchableOre, oreResult in pairs(patchableOres) do
        -- need to pass true for "plain" search as 4th param because some ore have a "-" and it is a special character for lua string.find() apparently ...
        if string.find(patchableOre, ore.name, 1, true) then 
            if settings.global["vtk-deep-core-mining-spawn-"..oreResult.."-patch"]
            and settings.global["vtk-deep-core-mining-spawn-"..oreResult.."-patch"].value then
                validOre = true
                orePatchToSpawn = oreResult.."-patch"
                break
            end
        end
    end
    
    if validOre and not Area.inside(Position.expand_to_area({0,0}, minspawnrange), ore.position) then
        local number = math.random(1, 10)
        entitiesCount = surface.count_entities_filtered{area = areaToScan, name = orePatchToSpawn}
        
        if number == 1 and entitiesCount == 0 then
            oreamount = math.random(minrichness, maxrichness)
            newOreEntity = surface.create_entity({name = orePatchToSpawn, amount = oreamount, position = ore.position, force = game.forces.neutral})
        end
    end
  
end


function place_deep_core_cracks(area, surface)
    if not settings.global["vtk-deep-core-mining-spawn-cracks"].value then
        return
    end
    
    local minspawnrange = settings.global["vtk-deep-core-mining-spawn-radius-from-start"].value
    local crackrichness = settings.global["vtk-deep-core-mining-crack-richness"].value
    
  -- debug
  -- local player = game.players[1]
  -- player.print("VTK-DEEP-CORE-MINING_DEBUG")

    -- only spawn deep core mining cracks in nauvis
    if surface.name ~= "nauvis" then
        return
    end
    
    -- lucky day ? (1 / 500)
    local luck = math.random(1, 500)
  -- debug player.print(serpent.block(luck))
    if luck ~= 250 then
        return
    end

    -- check if there's already an entity present here (shouldn't but just in case)
    entitiesCount = surface.count_entities_filtered{area = area, name = "vtk-deepcore-mining-crack"}
  -- debug player.print(serpent.block(entitiesCount))

    if entitiesCount ~= 0 then
        return
    end
    
    local x1 = area.left_top.x
    local y1 = area.left_top.y
    local x2 = area.right_bottom.x
    local y2 = area.right_bottom.y
    
    -- minimum distance from spawn where deepcore mining cracks appear (default 1)
  -- debug
  -- player.print("setting value "..minspawnrange)
  -- player.print("position x "..x1.." y "..y1)

    if Area.inside(Position.expand_to_area({0,0}, minspawnrange), {x1, y1}) then
      return
    end
    
    local attempts = 0
    -- try 10 times to find a valid position to spawn a crack otherwise abandon
    while attempts < 10 do
        local x = math.random(x1, x2)
        local y = math.random(y1, y2)
        
        local tile = surface.get_tile(x, y)
    -- debug player.print(serpent.block(tile.name))
      
        if tile.valid and surface.can_place_entity{name = "vtk-deepcore-mining-crack", position = tile.position} then
            oreamount = crackrichness
            createdentity = surface.create_entity({name = "vtk-deepcore-mining-crack", amount = oreamount, position = tile.position, force = game.forces.neutral})
            
            -- cleanup decoratives around the newly spawned crack
            cleanupzone = Area.construct(createdentity.position.x, createdentity.position.y, createdentity.position.x, createdentity.position.y)
            cleanupzone = Area.expand(cleanupzone, 2)
            surface.destroy_decoratives(cleanupzone)
      -- debug
      -- player.print("vtk-deepcore-mining-crack placed successfully")
      -- player.print(serpent.block(tile.position))
            return
        end
        attempts = attempts + 1
    end
  
end


function remove_ore_patch(player, surface, area, entities)
    local patchescount = 0
    local sulfuricpatchescount = 0
    local dronescount = player.get_item_count("vtk-deepcore-mining-drone")
    local patches = {}
    local sulfuricpatches = {}
    local todo = true
    local sulfuricacidbarrel = "sulfuric-acid-barrel"
    if game.active_mods["angelspetrochem"] then
        sulfuricacidbarrel = "liquid-sulfuric-acid-barrel"
    end
    local sulfuricacidbarrelcount = player.get_item_count(sulfuricacidbarrel)

    -- debug
    -- player.print("inventory : "..serpent.line(player.get_inventory(defines.inventory.player_main).get_contents()))
    for _,entity in pairs(entities) do
        if entity.type == "resource"
            and (game.entity_prototypes[entity.name].resource_category == "vtk-deepcore-mining-ore-patch" 
            or game.entity_prototypes[entity.name].resource_category == "vtk-deepcore-mining-crack")
        then
            table.insert(patches, entity)
            patchescount = patchescount + 1
            if entity.name == "uranium-ore-patch" or entity.name == "vtk-deepcore-mining-crack" then
                sulfuricpatchescount = sulfuricpatchescount + 1
            end
        end
    end
    
    -- nothing todo ?
    if patchescount <= 0 then
        todo = false
    end
    -- display all requirements if not enough in inventory
    if dronescount < patchescount then
        player.print("Not enough Deep Core mining drones. "..patchescount.." needed only "..dronescount.." in inventory.")
        todo = false
    end
    if sulfuricacidbarrelcount < sulfuricpatchescount then
        player.print("Not enough sulfuric acid barrel. "..sulfuricpatchescount.." needed only "..sulfuricacidbarrelcount.." in inventory.")
        todo = false
    end
    if not todo then
        return
    end
    
    -- removing !
    for _,entity in pairs(patches) do
        local amountospawn = get_filtered_amount(entity.amount)
        -- debug
        -- player.print("VTK-DEEP-CORE-MINING_DEBUG")
        -- player.print("Found "..patchescount.." patches to remove and "..sulfuricpatchescount.." sulfuric patches to remove")
        -- player.print(serpent.block(entity.name))
        -- player.print(serpent.block(entity.amount))
        -- player.print(serpent.block(amountospawn))

        if entity.name == "iron-ore-patch" then
            surface.spill_item_stack(entity.position, {name="vtk-deepcore-mining-iron-ore-chunk", count = amountospawn}, true)
          
        elseif entity.name == "copper-ore-patch" then
            surface.spill_item_stack(entity.position, {name="vtk-deepcore-mining-copper-ore-chunk", count = amountospawn}, true)
          
        elseif entity.name == "coal-patch" then
            surface.spill_item_stack(entity.position, {name="vtk-deepcore-mining-coal-chunk", count = amountospawn}, true)
          
        elseif entity.name == "stone-patch" then
            surface.spill_item_stack(entity.position, {name="vtk-deepcore-mining-stone-chunk", count = amountospawn}, true)
          
        elseif entity.name == "uranium-ore-patch" then
            surface.spill_item_stack(entity.position, {name="vtk-deepcore-mining-uranium-ore-chunk", count = amountospawn}, true)

        elseif entity.name == "vtk-deepcore-mining-crack" then
            surface.spill_item_stack(entity.position, {name="vtk-deepcore-mining-ore-chunk", count = amountospawn}, true)
        
        elseif entity.name == "angels-ore1-patch" then
            surface.spill_item_stack(entity.position, {name="vtk-deepcore-mining-angels-ore1-chunk", count = amountospawn}, true)
          
        elseif entity.name == "angels-ore2-patch" then
          surface.spill_item_stack(entity.position, {name="vtk-deepcore-mining-angels-ore2-chunk", count = amountospawn}, true)
          
        elseif entity.name == "angels-ore3-patch" then
            surface.spill_item_stack(entity.position, {name="vtk-deepcore-mining-angels-ore3-chunk", count = amountospawn}, true)
          
        elseif entity.name == "angels-ore4-patch" then
            surface.spill_item_stack(entity.position, {name="vtk-deepcore-mining-angels-ore4-chunk", count = amountospawn}, true)
          
        elseif entity.name == "angels-ore5-patch" then
            surface.spill_item_stack(entity.position, {name="vtk-deepcore-mining-angels-ore5-chunk", count = amountospawn}, true)
          
        elseif entity.name == "angels-ore6-patch" then
            surface.spill_item_stack(entity.position, {name="vtk-deepcore-mining-angels-ore6-chunk", count = amountospawn}, true)
        
        end
        entity.destroy()
    end
    
    player.remove_item{name="vtk-deepcore-mining-drone", count = patchescount}
    if sulfuricpatchescount > 0 then
        player.remove_item{name=sulfuricacidbarrel, count = sulfuricpatchescount}
    end
	
end