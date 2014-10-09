// This file is used for other things related to the powers.

////////////////
// SHADOW MOB //
////////////////

/mob/living/simple_animal/hostile/retaliate/shadow
	name = "shadow"
	desc = "It flickers in and out of reality, warping the mind."
	icon = 'icons/mob/animal.dmi'
	icon_state = "forgotten"
	alpha = 50
	maxHealth = 20
	health = 20
	emote_hear = list("moans","wails","whispers")
	response_help  = "puts their hand through"
	response_disarm = "flails at"
	response_harm   = "punches"
	melee_damage_lower = 5
	melee_damage_upper = 10
	attacktext = "drains the life from"
	attack_sound = 'sound/hallucinations/growl1.ogg'
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	faction = "cult"

/mob/living/simple_animal/hostile/retaliate/shadow/New()
	..()
	visible_message("<span class='warning'>A shadow appears.</span>")
	spawn(1500)
		visible_message("<span class='warning'>The shadow fades away.</span>")
		qdel(src)

/mob/living/simple_animal/hostile/retaliate/shadow/Life()
	..()
	for(var/mob/living/carbon/human/H in range(3,src))
		H.adjustBrainLoss(rand(0.5,1))

///////////
// LIGHT //
///////////

/obj/effect/artlight
	name = "dancing lights"
	desc = "So bright, so ethereal."
	density = 0
	icon = 'icons/obj/projectiles.dmi'
	icon_state ="ice_1"
	pass_flags = PASSGLASS | PASSGRILLE
	var/mob/target = null

/obj/effect/artlight/New(l,var/duration = 450)
	..()
	SetLuminosity(8)
	processing_objects.Add(src)
	spawn(duration)
		if(src)
			qdel(src)

/obj/effect/artlight/process()
	if(!target)
		qdel(src)
	else
		x = target.x
		y = target.y
		z = target.z

/obj/effect/artlight/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return 1

//////////////
// BLOB GOO //
//////////////

/obj/effect/blobgoo
	name = "oozing goo"
	desc = "Something's growing in the goo..."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenglow"

/obj/effect/blobgoo/New(l,var/duration = 1200)
	..()
	SetLuminosity(2)
	playsound(src.loc, 'sound/effects/splat.ogg', 100, 1)
	spawn(duration)
		if(src)
			new /obj/effect/blob/node(src.loc)
			qdel(src)

///////////////////////
// RADIATION MACHINE //
///////////////////////

/obj/machinery/rad_machine
	name = "radiation machine"
	desc = "Used for the irradiation of artifacts. Remember to wear a radsuit while using it."
	icon = 'icons/obj/artifact.dmi'
	icon_state = "pod_0"
	anchored = 1
	density = 1
	var/active = 0
	var/intensity = 5
	var/obj/item/artifact/art = null

/obj/machinery/rad_machine/New()
	..()
	update_icons()

/obj/machinery/rad_machine/attack_hand(mob/user as mob)
	// Todo: Make this upgradeable?
	user.set_machine(src)

	var/datum/browser/popup = new(user, "radiation", "Radiation Machine", 300, 250)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))

	var/dat = ""
	if(active)
		dat += "Working, please wait... ([intensity] seconds remaining.)"
	else
		dat += "<b>Loaded artifact</b>: [art ? "[art.name]" : "Null"]<br>"
		if(art)
			dat += "<A HREF='?src=\ref[src];eject=1'>Eject Artifact</A><br><br>"
			dat += "<A HREF='?src=\ref[src];radiate=1'>Pulse Radiation</A><br>"
		else
			dat += "<span class='linkOff'>Eject Artifact</span><br><br>"
			dat += "<span class='linkOff'>Pulse Radiation</span><br>"
		dat += "<b>Radiation Intensity:</b> <A HREF='?src=\ref[src];decrease=1'>-</A> [intensity] <A HREF='?src=\ref[src];increase=1'>+</A><br><br>"

	dat += "<br><A HREF='?src=\ref[user];mach_close=radiation'>Close Console</A>"

	popup.set_content(dat)
	popup.open()

/obj/machinery/rad_machine/attackby(var/obj/item/artifact/A, var/mob/user)
	if(istype(A))
		if(!art)
			user.drop_item()
			art = A
			A.loc = src
			user << "<span class='notice'>You insert \the [A] into the machine.</span>"
		else
			user << "<span class='danger'>There's already an artifact in the machine.</span>"
	else
		user << "<span class='danger'>\The [src] rejects \the [A]!</span>"

/obj/machinery/rad_machine/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)

	if(href_list["eject"])
		for(var/obj/item/artifact/A in contents)
			A.loc = src.loc
			art = null
			updateUsrDialog()
			usr << "<span class='notice'>You eject \the [A].</span>"
	else if(href_list["radiate"])
		active = 1
		updateUsrDialog()
		update_icons()
		if(prob(intensity*10))
			for(var/mob/living/L in view(intensity, src))
				L.apply_effect(20, IRRADIATE)
			playsound(src.loc, 'sound/effects/EMPulse.ogg', 60, 1)
		var/duration = intensity*10
		spawn(duration)
			active = 0
			updateUsrDialog()
			update_icons()
			art.radiation_act(intensity)
	else if(href_list["increase"])
		if(intensity+1 < 11)
			intensity++
			updateUsrDialog()
	else if(href_list["decrease"])
		if(intensity-1 > 0)
			intensity--
			updateUsrDialog()

/obj/machinery/rad_machine/proc/update_icons()
	icon_state = "pod_[active]"

///////////////
// GUN STUFF //
///////////////

// TODO

/*/obj/item/ammo_casing/energy/artifact
	e_cost = 0
	projectile_type = /obj/item/projectile/artifact

/obj/item/projectile/artifact
	name = "artifact projectile"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE

/obj/item/projectile/artifact/New()
	..()
	damage = rand(5,30)
	damage_type = pick(BRUTE,BURN,TOX,OXY,CLONE,STAMINA)
	flag = pick("bullet","laser","energy","bomb")
	projectile_type = "/obj/item/projectile"
	kill_count = rand(3,10)*10
	// effects
	if(prob(20))
		stun = rand(1,5)
		weaken = rand(1,5)
	if(prob(10))
		paralyze = rand(1,4)
	if(prob(30))
		irradiate = rand(1,5)*10
	if(prob(40))
		stutter = rand(1,5)
	if(prob(50))
		eyeblur = rand(1,3)
	if(prob(25))
		drowsy = rand(1,5)
	if(prob(10))
		forcedodge = 1*/