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

	UnarmedAttack(var/atom/A)
		if(!istype(A,mob/living/carbon))
			A.attack_animal(src)
			return
		
		var/mob/living/carbon/M = A
		
		if(M.stat==DEAD)
			src << "This body is devoid of life. There is nothing for you to feed off of here."
			return
		
		if(attack_sound)
			playsound(M.loc, attack_sound, 50, 1, 1)
		for(var/mob/O in viewers(M, null))
			O.show_message("\red <B>[src]</B> [attacktext] [M]!", 1)
		add_logs(src, M, "attacked", admin=0)

		
		M.take_overall_damage(3,0)
		M.adjustStaminaLoss(rand(1,6)+rand(1,6))

		health = min(health+3,maxHealth*2)
		
		if(prob(15))
			M << "\purple An icy spear of dread reaches to your very soul!"
			M.Jitter(500)
			M.hallucination = min( M.hallucination+100, max(400,M.hallucination) ) //Won't reduce hallucination if above 400





	Process_Spacemove(var/check_drift = 0)
		return 1	//Ripped straight from Space Carp!

