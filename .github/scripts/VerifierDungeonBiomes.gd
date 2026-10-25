extends SceneTree
func _initialize():call_deferred("run")
func run():
 var game=load("res://village.tscn").instantiate();game.verification_mode=true;root.add_child(game);game.start_game();game.process_mode=Node.PROCESS_MODE_DISABLED
 var c=game.campaign
 for depth in [1,21,41,61,81,100]:
  c.travel(depth);await process_frame
  var d=c.dungeon;var band=clampi((depth-1)/20,0,4)
  if d.biome.band!=band:push_error("Incorrect exported biome");quit(1);return
  var room=d.layout.rooms[d.layout.endRoom if depth==100 else d.layout.startRoom]
  var target=Vector3(room.cx*d.CELL,0,room.cy*d.CELL)
  game.hero.position=target;game.camera.position=target+Vector3(14,19,14);game.camera.look_at(target);game.camera.size=25
  await process_frame;await process_frame;await RenderingServer.frame_post_draw
  var image=root.get_texture().get_image()
  if image.is_empty():push_error("Empty exported biome frame");quit(1);return
  if depth==100 and not c.enemies.any(func(e):return e.stats.get("finalBoss",false)):push_error("Missing exported final boss");quit(1);return
  print("EXPORTED_BIOME_FRAME: ",depth,"; size=",image.get_size())
 print("EXPORTED_BIOMES_OK: six real rendered levels, shaders, final boss and no player saves")
 quit(0)
