extends WeaponComponent

func select_target():
	enemies.clear()
	if not spaceship is SpaceShip:
		return
	for enemy in spaceship.enemies_node.enemies:
		enemies.append(enemy)

	if enemies.size():
		enemies.sort_custom(func(a,b): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
		target = enemies[0]



func fire_gun():
	fill_ammo_storage()
	
	if not animation_player.is_playing() and not ammo_storage < ammo_drain and target != null:
		var proj = projectile.instantiate()
		add_child(proj)
		proj.global_position = turret_muzzel.global_position
		proj.speed = 0.0
		proj.target = Vector2(1,0).rotated(turret.global_rotation) #target.global_position - global_position
		animation_player.play("fire")
		fire_audio.play(0)
		
		drain_ammo(ammo_drain)
		
		if ammo_bar != null:
			ammo_bar.value = float(ammo_storage)/float(ammo_max_storage)
	
	if fire and ray.is_colliding():
		target = null
	
	is_out_of_ammo()
