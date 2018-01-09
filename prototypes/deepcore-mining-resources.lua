data:extend(
{
  {
    type = "resource-category",
    name = "vtk-deepcore-ore"
  }
})

local function resource_patch_maker(ore_name, ore_patch_name, hardnessparam, miningtime, mapcolor, fluid)
  local fluid_req = {
    minable =
    {
      hardness = hardnessparam,
      mining_time = miningtime,
      results =
      {
        {
          type = "item",
          name = ore_name,
          amount_min = 1,
          amount_max = 1,
          probability = 1
        }
      },
      fluid_amount = 10,
      required_fluid = "sulfuric-acid"
    }
  }
  
  oredata = 
  {
    type = "resource",
    name = ore_patch_name,
    icon = "__vtk-deep-core-mining__/graphics/icons/"..ore_patch_name..".png",
    icon_size = 32,
    flags = {"placeable-neutral"},
    category = "vtk-deepcore-ore",
    order = "a-b-a",
    infinite = true,
    minimum = 60000,
    normal = 300000,
    minable =
    {
      hardness = hardnessparam,
      mining_time = miningtime,
      results =
      {
        {
          type = "item",
          name = ore_name,
          amount_min = 1,
          amount_max = 1,
          probability = 1
        }
      }
    },
    collision_box = {{ -1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{ -0.75, -0.75}, {0.75, 0.75}},
    stage_counts = {0},
    stages =
    {
      sheet =
      {
        filename = "__vtk-deep-core-mining__/graphics/resource/"..ore_patch_name.."-sprite.png",
        priority = "extra-high",
        width = 100,
        height = 100,
        frame_count = 3,
        variation_count = 1
      }
    },
    map_color = mapcolor,
    map_grid = false
  }
  
  if fluid then
    for k,v in pairs(fluid_req) do oredata[k] = v end

    return oredata
  end
  
  return oredata
end

data:extend(
{
  resource_patch_maker(
    "copper-ore", 
    "copper-ore-patch", 
    0.9,                         -- hardnessparam
    2,                           -- miningtime
    {r=0.803, g=0.388, b=0.215}, -- mapcolor
    false                        -- fluid
  ),
  resource_patch_maker(
    "iron-ore", 
    "iron-ore-patch", 
    0.9, 
    2, 
    {r=0.337, g=0.419, b=0.427},
    false
  ),
  resource_patch_maker(
    "coal", 
    "coal-patch", 
    0.9, 
    2, 
    {r=0, g=0, b=0},
    false
  ),
  resource_patch_maker(
    "stone",
    "stone-patch",
    0.4, 
    2, 
    {r=0.478, g=0.450, b=0.317},
    false
  ),
  resource_patch_maker(
    "uranium-ore", 
    "uranium-ore-patch", 
    0.9, 
    4, 
    {r=0, g=0.7, b=0},
    true
  )
})