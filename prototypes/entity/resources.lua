local sounds = require ("__base__.prototypes.entity.sounds")
local noise = require("noise")
local tne = noise.to_noise_expression
local resource_autoplace = require("resource-autoplace")

resource_autoplace.initialize_patch_set("avv-natural-gas-methane-gas", false)

local function autoplace_settings(name, order, coverage)
  return
  {
    order = order,
    control = name,
    sharpness = 15/16,
    richness_multiplier = 1500,
    richness_multiplier_distance_bonus = 20,
    richness_base = 10,
    coverage = coverage,
    peaks =
    {
      {
        noise_layer = name,
        noise_octaves_difference = -0.85,
        noise_persistence = 0.4
      }
    },
    starting_area_size = 5500 * coverage,
    starting_area_amount = 1600
  }
end

local function resource(resource_parameters, autoplace_parameters)
  if coverage == nil then coverage = 0.02 end

  return
  {
    type = "resource",
    name = resource_parameters.name,
    icon = "__base__/graphics/icons/" .. resource_parameters.name .. ".png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {"placeable-neutral"},
    order="a-b-"..resource_parameters.order,
    tree_removal_probability = 0.8,
    tree_removal_max_distance = 32 * 32,
    minable =
    {
      mining_particle = resource_parameters.name .. "-particle",
      mining_time = resource_parameters.mining_time,
      result = resource_parameters.name
    },
    walking_sound = resource_parameters.walking_sound,
    collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    -- autoplace = autoplace_settings(name, order, coverage),
    autoplace = resource_autoplace.resource_autoplace_settings
    {
      name = resource_parameters.name,
      order = resource_parameters.order,
      base_density = autoplace_parameters.base_density,
      has_starting_area_placement = true,
      regular_rq_factor_multiplier = autoplace_parameters.regular_rq_factor_multiplier,
      starting_rq_factor_multiplier = autoplace_parameters.starting_rq_factor_multiplier,
      candidate_spot_count = autoplace_parameters.candidate_spot_count
    },
    stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
    stages =
    {
      sheet =
      {
        filename = "__base__/graphics/entity/" .. resource_parameters.name .. "/" .. resource_parameters.name .. ".png",
        priority = "extra-high",
        size = 64,
        frame_count = 8,
        variation_count = 8,
        hr_version =
        {
          filename = "__base__/graphics/entity/" .. resource_parameters.name .. "/hr-" .. resource_parameters.name .. ".png",
          priority = "extra-high",
          size = 128,
          frame_count = 8,
          variation_count = 8,
          scale = 0.5
        }
      }
    },
    map_color = resource_parameters.map_color,
    mining_visualisation_tint = resource_parameters.mining_visualisation_tint
  }
end

data:extend({
{
	type = "resource",
	name = "avv-natural-gas-methane-gas-resource",
	icon = "__avv-natural-gas__/graphics/icons/methane-gas-resource.png",
	icon_size = 64, icon_mipmaps = 4,
	flags = {"placeable-neutral"},
	category = "basic-gas",
	subgroup = "raw-resource",
	order="a-b-a",
	infinite = true,
	highlight = true,
	minimum = 60000,
	normal = 300000,
	infinite_depletion_amount = 10,
	resource_patch_search_radius = 12,
	tree_removal_probability = 0.7,
	tree_removal_max_distance = 32 * 32,
	minable =
    {
		mining_time = 1,
		results =
		{
			{
				type = "fluid",
				name = "avv-natural-gas-methane-gas",
				amount_min = 20,
				amount_max = 20,
				probability = 1
			}
		}
    },

    walking_sound = sounds.oil,
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    autoplace = resource_autoplace.resource_autoplace_settings
    {
      name = "avv-natural-gas-methane-gas",
      order = "c", -- Other resources are "b"; gas won't get placed if something else is already there.
      base_density = 8.2,
      base_spots_per_km2 = 1.8,
      random_probability = 1/48,
      random_spot_size_minimum = 1,
      random_spot_size_maximum = 1, -- don't randomize spot size
      additional_richness = 220000, -- this increases the total everywhere, so base_density needs to be decreased to compensate
      has_starting_area_placement = true,
      regular_rq_factor_multiplier = 1
    },

    stage_counts = {0},
    stages =
    {
		sheet =
		{
			filename = "__avv-natural-gas__/graphics/entity/natural-gas/methane-gas.png",
			priority = "extra-high",
			width = 74,
			height = 60,
			frame_count = 4,
			variation_count = 1,
			shift = util.by_pixel(0, -2),
			hr_version =
			{
				filename = "__avv-natural-gas__/graphics/entity/natural-gas/hr-methane-gas.png",
				priority = "extra-high",
				width = 148,
				height = 120,
				frame_count = 4,
				variation_count = 1,
				shift = util.by_pixel(0, -2),
				scale = 0.5
			}
		}
    },
    map_color = {1, 1, 0.77},
    map_grid = false
}
})