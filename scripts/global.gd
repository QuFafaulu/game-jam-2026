extends Node

# Interaction priority: highest number is top priority, 0 is lowest
const PHYSICS_LAYER = 0 # Used by physics bodies, not used for overlaps or interactions
const STATION_INTERACTION_LAYER = 1 # Highest priority, used by interactable stage "stations"
const DROPPED_ITEM_INTERACTION_LAYER = 2 # Used by dropped items
const COMBAT_INTERACTION_LAYER = 3 # Used by combat entities (i.e. rats)
