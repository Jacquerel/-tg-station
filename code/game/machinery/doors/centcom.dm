/obj/machinery/door/airlock/centcom
	icon = 'icons/obj/doors/Doorele.dmi'
	opacity = 1
	doortype = 8
	req_access = list(access_cent_general)

	attackby(w,user) // no hacking centcom doors
		attack_hand(user)
		return 1 // no afterattack

	allowed(mob/user)
		if(unlock_centcom || (ismob(user) && user.client && user.client.holder)) return 1
		return ..(user)