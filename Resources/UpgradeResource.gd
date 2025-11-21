extends Resource
class_name UpgradeResource

@export var playerStatsPropertyChanges : Dictionary[String, Variant]

@export_multiline var text : String = ""

@export var tex : Texture2D

#If they should be removed from future selections after being picked
@export var unique : bool = false


static var rareityRate : Dictionary[RARITY, float] = {
	RARITY.COMMON : 0.6,
	RARITY.UNCOMMON : 0.85,
	RARITY.RARE : 0.97,
	RARITY.MYTHIC : 1.0
}

enum RARITY{
	COMMON,
	UNCOMMON,
	RARE,
	MYTHIC
}
@export var rarity : RARITY = RARITY.COMMON
