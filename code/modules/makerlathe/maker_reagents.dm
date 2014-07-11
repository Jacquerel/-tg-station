/*
	After some thoughts on the subject I decided that I should use reagents
	to unify the "amount of materials" nonsense.  Doing this requires adding
	reagents for special materials (plasteel, diamond, bananium) and making
	a way to get solid sheets back in some cases
*/
// note SOLID is only defined in reagents.dm but whatever

/datum/reagent
	var/resource_item = null // if this is a typepath, makers can eject this as a solid item

	iron/resource_item = /obj/item/stack/sheet/metal
	gold/resource_item = /obj/item/stack/sheet/mineral/gold
	silver/resource_item = /obj/item/stack/sheet/mineral/silver
	uranium/resource_item = /obj/item/stack/sheet/mineral/uranium

	// and meds too I guess idk
	bicaridine/resource_item = /obj/item/stack/medical/bruise_pack
	dermaline/resource_item = /obj/item/stack/medical/ointment

	plasma/solid
		name = "Solid Plasma"
		id = "splasma"
		//reagent_state = SOLID
		resource_item = /obj/item/stack/sheet/mineral/plasma
	iron/plasteel
		name = "Plasteel"
		id = "plasteel"
		resource_item = /obj/item/stack/sheet/plasteel
	carbon/diamond
		name = "Diamond"
		id = "diamond"
		resource_item = /obj/item/stack/sheet/mineral/diamond
	nutriment/cardboard
		name = "Cardboard"
		id = "cardboard"
		nutriment_factor = 0.25 * REAGENTS_METABOLISM
		resource_item = /obj/item/stack/sheet/cardboard

	banana/bananium
		name = "Bananium"
		id = "bananium"
		//reagent_state = SOLID
		resource_item = /obj/item/stack/sheet/mineral/clown
	silicon/glass
		name = "Glass"
		id = "glass"
		resource_item = /obj/item/stack/sheet/glass
	silicon/glass/rglass
		name = "Reinforced Glass"
		id = "rglass"
		resource_item = /obj/item/stack/sheet/rglass
	silicon/sandstone
		name = "Sandstone"
		id = "sandstone"
		resource_item = /obj/item/stack/sheet/mineral/sandstone
	leather
		name = "Leather"
		id = "leather"
		//reagent_state = SOLID
		resource_item = /obj/item/stack/sheet/leather
	leather/xeno
		name = "Xeno Chitin"
		id = "xenol"
		resource_item = /obj/item/stack/sheet/xenochitin
	cloth
		name = "Cloth"
		id = "cloth"
		//reagent_state = SOLID
		resource_item = /obj/item/stack/sheet/cloth
	cloth/carpet
		name = "Carpet"
		id = "carpet"
		resource_item = /obj/item/stack/tile/carpet
	grass
		name = "Grass"
		id = "grass"
		resource_item = /obj/item/stack/tile/grass
