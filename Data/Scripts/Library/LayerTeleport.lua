function TeleportToLayer(obj)
  local info_list = require("TRSubObjects")
  
  object_str = Object.Get_Type().Get_Name()
  if info_list[object_str] then
    obj.Prevent_All_Fire(true)
      for i, mesh in pairs(info_list[object_str].meshes) do 
        Hide_Sub_Object(obj, 1, mesh);
      end
      --hiding a second time because that disables the hyperspace sound!(not for initial forces though)
      --also, repeatedly calling the .Hide function seems to help for some reason
      Sleep(1)
      obj.Hide(true)
      Sleep(0.1)
      obj.Hide(true)
    
    Sleep(3.9)
    zlayer_dummy_list = Spawn_Unit(Find_Object_Type(info_list[object_str].heights[GameRandom(1,table.getn(info_list[object_str].heights))]), obj.Get_Position(), obj.Get_Owner())
    zlayer_dummy = zlayer_dummy_list[1]
    obj.Teleport(zlayer_dummy)

    obj.Cinematic_Hyperspace_In(1)
     for i, mesh in pairs(info_list[object_str].meshes) do 
        Hide_Sub_Object(obj, 0, mesh);
     end

    zlayer_dummy.Despawn()
    obj.Prevent_All_Fire(false)
    --ScriptExit()
  end
end