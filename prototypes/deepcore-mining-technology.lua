data:extend(
{
  {
    type = "technology",
    name = "vtk-deepcore",
    icon_size = 128,
    icon = "__vtk-deep-core-mining__/graphics/technology/deepcore-tech.png",
    effects = 
    {
        {
          type = "unlock-recipe",
          recipe = "vtk-deepcore-mining-drone"
        },
        {
          type = "unlock-recipe",
          recipe = "vtk-deepcore-mining-planner"
        },
        {
          type = "unlock-recipe",
          recipe = "vtk-deepcore-mining-iron-ore-chunk-refining"
        },
        {
          type = "unlock-recipe",
          recipe = "vtk-deepcore-mining-copper-ore-chunk-refining"
        },
        {
          type = "unlock-recipe",
          recipe = "vtk-deepcore-mining-coal-chunk-refining"
        },
        {
          type = "unlock-recipe",
          recipe = "vtk-deepcore-mining-stone-chunk-refining"
        },
        {
          type = "unlock-recipe",
          recipe = "vtk-deepcore-mining-uranium-ore-chunk-refining"
        },
      },
    prerequisites = {"advanced-electronics", "robotics", "advanced-material-processing", "sulfur-processing"}, 
    unit =
    {
      count = 500,
      ingredients = {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1},
      },
      time = 30,
    },
    upgrade = true,
    order = "e-c-c-a"
  },
  {
    type = "technology",
    name = "vtk-deepcore-mining",
    icon_size = 128,
    icon = "__vtk-deep-core-mining__/graphics/technology/deepcore-mining.png",
    effects = 
    {
        {
          type = "unlock-recipe",
          recipe = "vtk-deepcore-mining-drill"
        },
      },
    prerequisites = {"vtk-deepcore", "advanced-material-processing-2", "productivity-module-3", "mining-productivity-4"}, 
    unit =
    {
      count = 1000,
      ingredients = {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1},
        {"production-science-pack", 1},
      },
      time = 60,
    },
    upgrade = true,
    order = "e-c-c-a"
  },
  {
    type = "technology",
    name = "vtk-deepcore-mining-advanced",
    icon_size = 128,
    icon = "__vtk-deep-core-mining__/graphics/technology/deepcore-mining-advanced.png",
    effects = 
    {
        {
          type = "unlock-recipe",
          recipe = "vtk-deepcore-mining-drill-advanced"
        },
        {
          type = "unlock-recipe",
          recipe = "vtk-deepcore-mining-ore-chunk-refining"
        },
    },
    prerequisites = {"vtk-deepcore", "vtk-deepcore-mining", "mining-productivity-12"}, 
    unit =
    {
      count = 1500,
      ingredients = {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1},
        {"production-science-pack", 1},
        {"high-tech-science-pack", 1},
      },
      time = 60,
    },
    upgrade = true,
    order = "e-c-c-a"
  },
})

if mods["angelsrefining"] then
  table.insert(data.raw['technology']['vtk-deepcore']['effects'], {type = "unlock-recipe", recipe = "vtk-deepcore-mining-angels-ore1-chunk-refining" })
  table.insert(data.raw['technology']['vtk-deepcore']['effects'], {type = "unlock-recipe", recipe = "vtk-deepcore-mining-angels-ore2-chunk-refining" })
  table.insert(data.raw['technology']['vtk-deepcore']['effects'], {type = "unlock-recipe", recipe = "vtk-deepcore-mining-angels-ore3-chunk-refining" })
  table.insert(data.raw['technology']['vtk-deepcore']['effects'], {type = "unlock-recipe", recipe = "vtk-deepcore-mining-angels-ore4-chunk-refining" })
  table.insert(data.raw['technology']['vtk-deepcore']['effects'], {type = "unlock-recipe", recipe = "vtk-deepcore-mining-angels-ore5-chunk-refining" })
  table.insert(data.raw['technology']['vtk-deepcore']['effects'], {type = "unlock-recipe", recipe = "vtk-deepcore-mining-angels-ore6-chunk-refining" })
end