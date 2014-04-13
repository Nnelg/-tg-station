/mob/living/simple_animal/shade
	name = "Shade"
	real_name = "Shade"
	desc = "A bound spirit."
	icon = 'icons/mob/mob.dmi'
	icon_state = "shade"
	icon_living = "shade"
	icon_dead = "shade_dead"
	maxHealth = 50
	health = 50
	speak_emote = list("hisses")
	emote_hear = list("wails","screeches")
	response_help  = "puts their hand through"
	response_disarm = "flails at"
	response_harm   = "punches"
	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = "drains the life from"
	minbodytemp = 0
	maxbodytemp = 4000
	min_oxy = 0
	max_co2 = 0
	max_tox = 0
	speed = -1
	stop_automated_movement = 1
	status_flags = 0
	faction = "cult"
	status_flags = CANPUSH
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	var/obj/item/device/soulstone/master_stone = null
	var/obj/item/clothing/glasses/shades_on_shade = null


	Life()
		..()
		if(stat == 2)
			new /obj/item/weapon/ectoplasm (src.loc)
			for(var/mob/M in viewers(src, null))
				if((M.client && !( M.blinded )))
					M.show_message("\red [src] lets out a contented sigh as their form unwinds. ")
					ghostize()
			qdel(src)
			return
		else
			if(prob(20)) //slow regen
				health = min( health+1, maxHealth )


	attackby(var/obj/item/O as obj, var/mob/user as mob)  //Marker -Agouri
		if(istype(O, /obj/item/device/soulstone))
			O.transfer_soul("SHADE", src, user)
/*		else if(!shades_on_shade && istype(O, obj/item/clothing/glasses))
			if()
				
*/ //			
		else
			if(O.force)
				var/damage = O.force
				if (O.damtype == STAMINA)
					damage = 0
				health -= damage
				for(var/mob/M in viewers(src, null))
					if ((M.client && !( M.blinded )))
						M.show_message("<span class='danger'>[src] has been attacked with [O] by [user]!</span>")
			else
				usr << "\red This weapon is ineffective, it does no damage."
				for(var/mob/M in viewers(src, null))
					if ((M.client && !( M.blinded )))
						M.show_message("\red [user] gently taps [src] with [O]. ")
		return

	Process_Spacemove(var/check_drift = 0)
		return 1	//Ripped straight from Space Carp!

