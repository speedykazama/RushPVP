-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Drones = {}
local Scaleforms = {}
local Instructional = {}
local tab, temp = nil, false
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADMOVIE
-----------------------------------------------------------------------------------------------------------------------------------------
Scaleforms.LoadMovie = function(name)
  local scaleform = RequestScaleformMovie(name)
  while not HasScaleformMovieLoaded(scaleform) do Wait(0); end
  return scaleform
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADINTERACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
Scaleforms.LoadInteractive = function(name)
  local scaleform = RequestScaleformMovieInteractive(name)
  while not HasScaleformMovieLoaded(scaleform) do Wait(0); end
  return scaleform
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNLOADMOVIE
-----------------------------------------------------------------------------------------------------------------------------------------
Scaleforms.UnloadMovie = function(scaleform)
  SetScaleformMovieAsNoLongerNeeded(scaleform)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADADDTIONALTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
Scaleforms.LoadAdditionalText = function(gxt,count)
  for i=0,count,1 do
    if not HasThisAdditionalTextLoaded(gxt,i) then
      ClearAdditionalText(i, true)
      RequestAdditionalText(gxt, i)
      while not HasThisAdditionalTextLoaded(gxt,i) do Wait(0); end
    end
  end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETLABELS
-----------------------------------------------------------------------------------------------------------------------------------------
Scaleforms.SetLabels = function(scaleform,labels)
  PushScaleformMovieFunction(scaleform, "SET_LABELS")
  for i=1,#labels,1 do
    local txt = labels[i]
    BeginTextCommandScaleformString(txt)
    EndTextCommandScaleformString()
  end
  PopScaleformMovieFunctionVoid()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPMULTI
-----------------------------------------------------------------------------------------------------------------------------------------
Scaleforms.PopMulti = function(scaleform,method,...)
  PushScaleformMovieFunction(scaleform,method)
  for _,v in pairs({...}) do
    local trueType = Scaleforms.TrueType(v)
    if trueType == "string" then      
      PushScaleformMovieFunctionParameterString(v)
    elseif trueType == "boolean" then
      PushScaleformMovieFunctionParameterBool(v)
    elseif trueType == "int" then
      PushScaleformMovieFunctionParameterInt(v)
    elseif trueType == "float" then
      PushScaleformMovieFunctionParameterFloat(v)
    end
  end
  PopScaleformMovieFunctionVoid()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPFLOAT
-----------------------------------------------------------------------------------------------------------------------------------------
Scaleforms.PopFloat = function(scaleform,method,val)
  PushScaleformMovieFunction(scaleform,method)
  PushScaleformMovieFunctionParameterFloat(val)
  PopScaleformMovieFunctionVoid()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPINT
-----------------------------------------------------------------------------------------------------------------------------------------
Scaleforms.PopInt = function(scaleform,method,val)
  PushScaleformMovieFunction(scaleform,method)
  PushScaleformMovieFunctionParameterInt(val)
  PopScaleformMovieFunctionVoid()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPBOOL
-----------------------------------------------------------------------------------------------------------------------------------------
Scaleforms.PopBool = function(scaleform,method,val)
  PushScaleformMovieFunction(scaleform,method)
  PushScaleformMovieFunctionParameterBool(val)
  PopScaleformMovieFunctionVoid()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPRET
-----------------------------------------------------------------------------------------------------------------------------------------
Scaleforms.PopRet = function(scaleform,method)                
  PushScaleformMovieFunction(scaleform, method)
  return PopScaleformMovieFunction()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPVOID
-----------------------------------------------------------------------------------------------------------------------------------------
Scaleforms.PopVoid = function(scaleform,method)
  PushScaleformMovieFunction(scaleform, method)
  PopScaleformMovieFunctionVoid()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETBOOL
-----------------------------------------------------------------------------------------------------------------------------------------
Scaleforms.RetBool = function(ret)
  return GetScaleformMovieFunctionReturnBool(ret)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETINT
-----------------------------------------------------------------------------------------------------------------------------------------
Scaleforms.RetInt = function(ret)
  return GetScaleformMovieFunctionReturnInt(ret)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUETYPE
-----------------------------------------------------------------------------------------------------------------------------------------
Scaleforms.TrueType = function(val)
  if type(val) ~= "number" then return type(val); end

  local s = tostring(val)
  if string.find(s,'.') then 
    return "float"
  else
    return "int"
  end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- V3SQRMAGNITUDE
-----------------------------------------------------------------------------------------------------------------------------------------
function V3SqrMagnitude(self)
  return self.x * self.x + self.y * self.y + self.z * self.z
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGROUNDZ
-----------------------------------------------------------------------------------------------------------------------------------------
function GetGroundZ(pos)
  local found,z = GetGroundZFor_3dCoord(pos.x,pos.y,pos.z)
  if not found then
    return GetGround(vector3(pos.x,pos.y,pos.z-1.0))
  else
    return vector3(pos.x,pos.y,z)
  end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- V3CLAMPMAGNITUDE
-----------------------------------------------------------------------------------------------------------------------------------------
function V3ClampMagnitude(self,max)
  if V3SqrMagnitude(self) > (max * max) then
    self = V3SetNormalize(self)
    self = V3Mul(self,max)
  end
  return self
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- V3SETNORMALIZE
-----------------------------------------------------------------------------------------------------------------------------------------
function V3SetNormalize(self)
  local num = V3Magnitude(self)
  if num == 1 then
    return self
  elseif num > 1e-5 then
    self = V3Div(self,num)
  else
    self = vector3(0.0,0.0,0.0)
  end
  return self
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- V3MUL
-----------------------------------------------------------------------------------------------------------------------------------------
function V3Mul(self,q)
  if type(q) == "number" then
    self = self * q
  else
    self = V3MulQuat(self,q)
  end
  return self
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- V3MAGNITUDE
-----------------------------------------------------------------------------------------------------------------------------------------
function V3Magnitude(self)
  return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- V3DIV
-----------------------------------------------------------------------------------------------------------------------------------------
function V3Div(self,d)
  self = vector3(self.x / d,self.y / d,self.z / d)
  
  return self
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- V3MULQUAT
-----------------------------------------------------------------------------------------------------------------------------------------
function V3MulQuat(self,quat)    
  local num   = quat.x * 2
  local num2  = quat.y * 2
  local num3  = quat.z * 2
  local num4  = quat.x * num
  local num5  = quat.y * num2
  local num6  = quat.z * num3
  local num7  = quat.x * num2
  local num8  = quat.x * num3
  local num9  = quat.y * num3
  local num10 = quat.w * num
  local num11 = quat.w * num2
  local num12 = quat.w * num3
  
  local x = (((1 - (num5 + num6)) * self.x) + ((num7 - num12) * self.y)) + ((num8 + num11) * self.z)
  local y = (((num7 + num12) * self.x) + ((1 - (num4 + num6)) * self.y)) + ((num9 - num10) * self.z)
  local z = (((num8 - num11) * self.x) + ((num9 + num10) * self.y)) + ((1 - (num4 + num5)) * self.z)
  
  self = vector3(x, y, z) 
  return self
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- V2DIST
-----------------------------------------------------------------------------------------------------------------------------------------
function V2Dist(v1, v2)
  if not v1 or not v2 or not v1.x or not v2.x or not v1.y or not v2.y then return 0; end
  return math.sqrt( ( (v1.x or 0) - (v2.x or 0) )*(  (v1.x or 0) - (v2.x or 0) )+( (v1.y or 0) - (v2.y or 0) )*( (v1.y or 0) - (v2.y or 0) ) )
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function CreateBlip(pos,sprite,color,text,scale,display,shortRange,highDetail)
  local blip = AddBlipForCoord(pos.x,pos.y,pos.z)
  SetBlipSprite(blip, sprite)
  SetBlipDisplay(blip, 2)
  SetBlipScale(blip, 0.5)
  SetBlipColour(blip, color)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString((text or "Blip "..tostring(blip)))
  EndTextCommandSetBlipName(blip)
  return blip
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(pos, text)
  local camCoords = GetGameplayCamCoords()
  local distance = #(pos - camCoords)

  if not size then size = 1 end
  if not font then font = 1 end

  local dist = Vdist(GetEntityCoords(PlayerPedId()),pos)

  local scale = (size / distance) * 2
  local fov = (1 / GetGameplayCamFov()) * 100
  scale = scale * fov

  SetTextScale(0.0 * scale, 0.55 * scale)
  SetTextFont(font)
  SetTextColour(255, 255, 255, 255)
  SetTextDropshadow(0, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(true)

  SetDrawOrigin(pos, 0)
  BeginTextCommandDisplayText('STRING')
  AddTextComponentSubstringPlayerName(text)
  EndTextCommandDisplayText(0.0, 0.0)
  ClearDrawOrigin()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWSPOTLIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawSpotlight(pos,alpha)
  local lightPos = vector3(pos.x,pos.y,pos.z + 5.0)
  local direction = pos - lightPos
  local normal = V3SetNormalize(direction)
  DrawSpotLight(lightPos.x,lightPos.y,lightPos.z, normal.x,normal.y,normal.z, 255,255,255, alpha, 1.0, 0.0, 10.0, 1.0)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POINTONSPHERE
-----------------------------------------------------------------------------------------------------------------------------------------
function PointOnSphere(alt,azu,radius,orgX,orgY,orgZ)
  local toradians = 0.017453292384744
  alt,azu,radius,orgX,orgY,orgZ = ( tonumber(alt or 0) or 0 ) * toradians, ( tonumber(azu or 0) or 0 ) * toradians, tonumber(radius or 0) or 0, tonumber(orgX or 0) or 0, tonumber(orgY or 0) or 0, tonumber(orgZ or 0) or 0
  if      vector3
  then
      return
      vector3(
           orgX + radius * math.sin( azu ) * math.cos( alt ),
           orgY + radius * math.cos( azu ) * math.cos( alt ),
           orgZ + radius * math.sin( alt )
      )
  end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOWHELPNOTIFICATION
-----------------------------------------------------------------------------------------------------------------------------------------
function ShowHelpNotification(msg, thisFrame, beep, duration)
  AddTextEntry('DroneHelpNotification', msg)

  if thisFrame then
    DisplayHelpTextThisFrame('DroneHelpNotification', false)
  else
    if beep == nil then beep = false; end
    BeginTextCommandDisplayHelp('DroneHelpNotification')
    EndTextCommandDisplayHelp(0, false, beep, duration or -1)
  end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INIT
-----------------------------------------------------------------------------------------------------------------------------------------
Instructional.Init = function()
  local scaleform = Scaleforms.LoadMovie('INSTRUCTIONAL_BUTTONS')
  Scaleforms.PopVoid(scaleform,'CLEAR_ALL')
  Scaleforms.PopInt(scaleform,'SET_CLEAR_SPACE',200) 
  return scaleform
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCONTROLS
-----------------------------------------------------------------------------------------------------------------------------------------
Instructional.SetControls = function(scaleform,controls)
  for i=1,#controls,1 do
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(i-1)
    for k=1,#controls[i].codes,1 do
      ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, controls[i].codes[k], true))
    end
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(controls[i].text)
    EndTextCommandScaleformString()
    PopScaleformMovieFunctionVoid()
  end

  Scaleforms.PopVoid(scaleform,'DRAW_INSTRUCTIONAL_BUTTONS')
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATE
-----------------------------------------------------------------------------------------------------------------------------------------
Instructional.Create = function(controls)
  local scaleform = Instructional.Init()
  Instructional.SetControls(scaleform,controls)
  return scaleform
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
local Config = {
    BankAccountName = "bank",
  
    DroneSounds = true,
  
    MaxVelocity = 250.0,
    BoostSpeed  = 3.0, 
    BoostAccel  = 2.0,        
    BoostDrain  = 1.0,       
    BoostFill   = 0.2,        
    TazerFill   = 0.2,       
  
    Drones = {
      [1] = {
        label = "Basit Drone 1",                             
        name = "drone",                               
        public = true,                                        
        price = 10000,                                       
        model = GetHashKey('ch_prop_casino_drone_02a'),       
        stats = {                        
          speed   = 1.0,             
          agility = 1.0,              
          range   = 100.0,           

          maxSpeed    = 2,             
          maxAgility  = 2,
          maxRange    = 200,
        },
        abilities = {
          infared     = true,  
          nightvision = true, 
          boost       = false,  
          tazer       = false,  
          explosive   = false,
        },
        restrictions = {},         
      },
    },
  
    Controls = {
      Drone = {
        ["inspect"] = {
          codes = {38},
          text = "Technology store",
        },
        ["pickup_drone"] = {
          codes = {38},
          text = "Get the Drone",
        },
        ["direction"] = {
          codes = {32,33,34,35},
          text = "Direction",
        },
        ["heading"] = {
          codes = {51,52},
          text = "heading",
        },
        ["height"] = {
          codes = {36,21},
          text = "height",
        },
        ["camera"] = {
          codes = {24,25},
          text = "camera",
        },
        ["centercam"] = {
          codes = {214},
          text = "center camera",
        },
        ["zoom"] = {
          codes = {16,17},
          text = "zoom"
        },
        ["nightvision"] = {
          codes = {140},
          text = "nightvision"
        },
        ["infared"] = {
          codes = {75},
          text = "Infrared"
        },
        ["tazer"] = {
          codes = {157},
          text = "tazer"
        },
        ["explosive"] = {
          codes = {158},
          text = "explosive"
        },
        ["boost"] = {
          codes = {160},
          text = "boost"
        },
        ["home"] = {
          codes = {213},
          text = "back home",
        },
        ["disconnect"] = {
          codes = {167},
          text = "disconnect"
        },
      },
      Homing = {
        ["cancel"] = {
          codes = {213},
          text = "cancel",
        },
        ["disconnect"] = {
          codes = {167},
          text = "disconnect"
        },
      }
    },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SCENEMODELS
-----------------------------------------------------------------------------------------------------------------------------------------
Drones.SceneModels = {
  drone   = GetHashKey('ch_prop_arcade_drone_01a'),
  laptop  = GetHashKey('hei_prop_hst_laptop')
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SCENEANIMATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
Drones.SceneAnimations = {
  [1] = {
    laptop  = 'hack_enter_laptop',
    drone   = 'hack_enter_card',
    bag     = 'hack_enter_suit_bag',
  },
  [2] = {
    laptop  = 'hack_loop_laptop',
    drone   = 'hack_loop_card',
    bag     = 'hack_loop_suit_bag',
  }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
Drones.LoadModel = function(hash)
  RequestModel(hash)
  while not HasModelLoaded(hash) do Wait(0); end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADDICT
-----------------------------------------------------------------------------------------------------------------------------------------
Drones.LoadDict = function(dict)
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do Wait(0); end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
Drones.CreateObject = function(pos, hash, net)
  Drones.LoadModel(hash)
  local del_obj = GetClosestObjectOfType(pos.x, pos.y, pos.z, 2.5, hash, false, true, true)
  if del_obj then
    SetEntityAsMissionEntity(del_obj, true, true)
    DeleteObject(del_obj)
  end
  local _object = CreateObject(hash, pos.x, pos.y, pos.z, net, true, true)
  if (type(pos) == "vector4") then
    SetEntityHeading(_object,pos.w)
  end
  return _object
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SCENEOBJETS
-----------------------------------------------------------------------------------------------------------------------------------------
Drones.SceneObjects = function()
  local pos = GetEntityCoords(PlayerPedId())
  local objects = {}
  for key,hash in pairs(Drones.SceneModels) do
    objects[key] = Drones.CreateObject(pos, hash, 1)
    SetEntityAsMissionEntity(objects[key], true, true)
    SetEntityCollision(objects[key], false, false)
    SetModelAsNoLongerNeeded(hash)
  end
  return objects
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATECAM
-----------------------------------------------------------------------------------------------------------------------------------------
Drones.CreateCam = function(attach_to)
  local camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 0.0, 0.0, 0.0, 0, 0, 0, 50 * 1.0)
  local min,max = GetModelDimensions(GetEntityModel(attach_to))

  SetCamActive(camera, true)
  RenderScriptCams(true, false, 0, true, false)
  AttachCamToEntity(camera,attach_to, 0.0, 0.0, -max.z/2, false)
  SetFocusEntity(attach_to, true)

  ClearTimecycleModifier()
  SetTimecycleModifier("eyeinthesky")
  SetTimecycleModifierStrength(0.1)

  return camera
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATECONTROLS
-----------------------------------------------------------------------------------------------------------------------------------------
Drones.CreateControls = function(abilities)
  local controls
  if type(abilities) == "string" then
    controls = {
      [1] = Config.Controls.Homing["cancel"],
      [2] = Config.Controls.Homing["disconnect"]
    }
  else
    controls = {
      [1] = Config.Controls.Drone["direction"],
      [2] = Config.Controls.Drone["heading"],
      [3] = Config.Controls.Drone["height"],
      [4] = Config.Controls.Drone["camera"],
      [5] = Config.Controls.Drone["zoom"],
    }

    if abilities.nightvision then
      table.insert(controls,Config.Controls.Drone["nightvision"])
    end

    if abilities.infared then
      table.insert(controls,Config.Controls.Drone["infared"])
    end

    if abilities.tazer then
      table.insert(controls,Config.Controls.Drone["tazer"])
    end

    if abilities.boost then
      table.insert(controls,Config.Controls.Drone["boost"])
    end

    if abilities.explosive then
      table.insert(controls,Config.Controls.Drone["explosive"])
    end

    table.insert(controls,Config.Controls.Drone["centercam"])
    table.insert(controls,Config.Controls.Drone["home"])
    table.insert(controls,Config.Controls.Drone["disconnect"])
  end

  return controls
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNDRONE
-----------------------------------------------------------------------------------------------------------------------------------------
Drones.SpawnDrone = function(drone_data)
  DoScreenFadeOut(500)
  local controls = Drones.CreateControls(drone_data.abilities)
  Drones.ButtonsScaleform = Instructional.Create(controls)
  Wait(500)

  local drone_model = drone_data.model
  local ply_ped     = PlayerPedId()
  local ply_pos     = GetEntityCoords(ply_ped)
  local drone       = Drones.CreateObject(vec3(ply_pos.x,ply_pos.y,ply_pos.z+2), drone_model, 1)
  local cam         = Drones.CreateCam(drone)

  SetEntityAsMissionEntity(drone, true, true)
  SetObjectPhysicsParams(drone, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0)

  local pos = GetEntityCoords(drone)
  local hed = GetEntityHeading(drone)
  local rot = GetEntityRotation(drone, 2)

  local velocity = vector3(0.0, 0.0, 0.0)
  local rotation = vector3(0.0, 0.0, 0.0)

  Drones.DroneScaleform = Scaleforms.LoadMovie("DRONE_CAM")
  Scaleforms.PopBool(Drones.DroneScaleform,"SET_EMP_METER_IS_VISIBLE", 0)
  Scaleforms.PopBool(Drones.DroneScaleform,"SET_INFO_LIST_IS_VISIBLE", 0)
  Scaleforms.PopBool(Drones.DroneScaleform,"SET_SOUND_WAVE_IS_VISIBLE", 0)
  Scaleforms.PopBool(Drones.DroneScaleform,"SET_TRANQUILIZE_METER_IS_VISIBLE", 0)

  Scaleforms.PopBool(Drones.DroneScaleform,"SET_DETONATE_METER_IS_VISIBLE",   drone_data.abilities.explosive)
  Scaleforms.PopBool(Drones.DroneScaleform,"SET_SHOCK_METER_IS_VISIBLE",      drone_data.abilities.tazer)
  Scaleforms.PopBool(Drones.DroneScaleform,"SET_RETICLE_IS_VISIBLE",          drone_data.abilities.tazer)
  Scaleforms.PopBool(Drones.DroneScaleform,"SET_BOOST_METER_IS_VISIBLE",      drone_data.abilities.boost)
  Scaleforms.PopBool(Drones.DroneScaleform,"SET_HEADING_METER_IS_VISIBLE", 1)
  Scaleforms.PopBool(Drones.DroneScaleform,"SET_ZOOM_METER_IS_VISIBLE", 1)

  Scaleforms.PopInt(Drones.DroneScaleform,"SET_ZOOM", 0)
  Scaleforms.PopInt(Drones.DroneScaleform,"SET_BOOST_PERCENTAGE", 100)
  Scaleforms.PopInt(Drones.DroneScaleform,"SET_DETONATE_PERCENTAGE", 100)
  Scaleforms.PopInt(Drones.DroneScaleform,"SET_SHOCK_PERCENTAGE", 100)

  Scaleforms.PopInt(Drones.DroneScaleform,"SET_TRANQUILIZE_PERCENTAGE", 100)
  Scaleforms.PopInt(Drones.DroneScaleform,"SET_EMP_PERCENTAGE", 100)

  Scaleforms.PopMulti(Drones.DroneScaleform,"SET_ZOOM_LABEL", 0, "DRONE_ZOOM_1")
  Scaleforms.PopMulti(Drones.DroneScaleform,"SET_ZOOM_LABEL", 1, "")
  Scaleforms.PopMulti(Drones.DroneScaleform,"SET_ZOOM_LABEL", 2, "DRONE_ZOOM_2")
  Scaleforms.PopMulti(Drones.DroneScaleform,"SET_ZOOM_LABEL", 3, "")
  Scaleforms.PopMulti(Drones.DroneScaleform,"SET_ZOOM_LABEL", 4, "DRONE_ZOOM_3")

  Drones.SoundID = GetSoundId()
  if Config.DroneSounds then
    PlaySoundFromEntity(Drones.SoundID, "Flight_Loop", drone, "DLC_BTL_Drone_Sounds", true, 0) 
  end

  DoScreenFadeIn(500)
  Drones.DroneControl(drone_data, drone, cam)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATTACHOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
function attachObject()
	tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
	AttachEntityToEntity(tab, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.05, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function stopAnim()
	temp = false
	StopAnimTask(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a" ,8.0, -8.0, -1, 49, 0, false, false, false)
    DeleteObject(tab)
    FreezeEntityPosition(PlayerPedId(), false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function startAnim()
  if not temp then
		RequestAnimDict("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a")
		while not HasAnimDictLoaded("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a") do
			Citizen.Wait(0)
		end
		attachObject()
    TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a" ,8.0, -8.0, -1, 49, 0, false, false, false)
    FreezeEntityPosition(PlayerPedId(), true)
		temp = true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRONECONTROL
-----------------------------------------------------------------------------------------------------------------------------------------
Drones.DroneControl = function(drone_data, drone, camera)
  local ply_ped = PlayerPedId()
  local ply_pos = GetEntityCoords(ply_ped)
  local ply_fwd = GetEntityForwardVector(ply_ped)

  local pos = ply_pos + ply_fwd

  local zoom = 0
  local head = 0.0
  local boost = 100.0
  local explosive = 100.0
  local tazer = 100.0

  local rotation_momentum = 0.0
  local movement_momentum = vector3(0.0, 0.0, 0.0)
  local camera_rotation = vector3(0.0, 0.0, 0.0)

  Drones.DisplayRadar = (not IsRadarHidden())
  DisplayRadar(false)
  startAnim()
  while true do
    local forward,right,up,p = GetEntityMatrix(drone)
    local dist = Vdist(ply_pos,p)

    DisableAllControlActions(0)
    SetEntityNoCollisionEntity(ply_ped, drone, true)

    local boosted = false
    if drone_data.abilities.boost then
      if IsDisabledControlPressed(0, Config.Controls.Drone["boost"].codes[1]) and boost > 1.0 then
        boost = math.max(1.0, boost - (Config.BoostDrain * GetFrameTime()))
        boosted = true
      else
        boost = math.min(100.0, boost + (Config.BoostFill * GetFrameTime()))
      end
      Scaleforms.PopInt(Drones.DroneScaleform, "SET_BOOST_PERCENTAGE", math.floor(boost))
    end

    local did_move = false
    local max_boost = (Config.MaxVelocity * drone_data.stats.speed)
    if boosted then
      max_boost = max_boost * Config.BoostSpeed
    end
    if IsDisabledControlPressed(0, Config.Controls.Drone["direction"].codes[1]) then
      movement_momentum = V3ClampMagnitude(movement_momentum + (forward * drone_data.stats.agility),max_boost)
      did_move = true
    end

    if IsDisabledControlPressed(0, Config.Controls.Drone["direction"].codes[2]) then
      movement_momentum = V3ClampMagnitude(movement_momentum - (forward * drone_data.stats.agility),max_boost)
      did_move = true
    end

    if IsDisabledControlPressed(0, Config.Controls.Drone["direction"].codes[3]) then
      movement_momentum = V3ClampMagnitude(movement_momentum - (right * drone_data.stats.agility),max_boost)
      did_move = true
    end

    if IsDisabledControlPressed(0, Config.Controls.Drone["direction"].codes[4]) then
      movement_momentum = V3ClampMagnitude(movement_momentum + (right * drone_data.stats.agility),max_boost)
      did_move = true
    end

    if IsDisabledControlPressed(0, Config.Controls.Drone["height"].codes[1]) then
      movement_momentum = V3ClampMagnitude(movement_momentum - (up * drone_data.stats.agility),max_boost)
      did_move = true
    end

    if IsDisabledControlPressed(0,Config.Controls.Drone["height"].codes[2]) then
      movement_momentum = V3ClampMagnitude(movement_momentum + (up * drone_data.stats.agility),max_boost)
      did_move = true
    end

    if IsDisabledControlPressed(0,Config.Controls.Drone["camera"].codes[1]) then
      camera_rotation = camera_rotation - (vector3(1.0,0.0,0.0) / math.max(2,zoom))
    end

    if IsDisabledControlPressed(0,Config.Controls.Drone["camera"].codes[2]) then
      camera_rotation = camera_rotation + (vector3(1.0,0.0,0.0) / math.max(2,zoom))
    end

    if IsDisabledControlPressed(0,Config.Controls.Drone["heading"].codes[1]) then
      rotation_momentum = math.max(-1.5,rotation_momentum - 0.02)
    elseif IsDisabledControlPressed(0,Config.Controls.Drone["heading"].codes[2]) then
      rotation_momentum = math.min(1.5,rotation_momentum + 0.02)
    else
      if rotation_momentum > 0.0 then
        rotation_momentum = math.max(0.0,rotation_momentum - 0.04)
      elseif rotation_momentum < 0.0 then
        rotation_momentum = math.min(0.0,rotation_momentum + 0.04)
      end
    end

    if IsDisabledControlJustPressed(0,Config.Controls.Drone["zoom"].codes[1]) then
      zoom = math.max(0, (zoom or 0) - 1)
      Scaleforms.PopInt(Drones.DroneScaleform, "SET_ZOOM", zoom)

      SetCamFov(camera, 50.0 - (10.0 * zoom))
    end
    
    if IsDisabledControlJustPressed(0,Config.Controls.Drone["zoom"].codes[2]) then
      zoom = math.min(4, (zoom or 0) + 1)
      Scaleforms.PopInt(Drones.DroneScaleform, "SET_ZOOM", zoom)

      SetCamFov(camera, 50.0 - (10.0 * zoom))
    end

    if drone_data.abilities.nightvision and IsDisabledControlJustPressed(0,Config.Controls.Drone["nightvision"].codes[1]) then
      if not NightvisionEnabled then
        NightvisionEnabled = true
        SetNightvision(true)
      else
        NightvisionEnabled = false
        SetNightvision(false)
      end
    end

    if drone_data.abilities.infared and IsDisabledControlJustPressed(0,Config.Controls.Drone["infared"].codes[1]) then
      if not InfaredEnabled then
        InfaredEnabled = true
        SetSeethrough(true)
      else
        InfaredEnabled = false
        SetSeethrough(false)
      end
    end

    if drone_data.abilities.tazer then
      if IsDisabledControlJustPressed(0,Config.Controls.Drone["tazer"].codes[1]) and tazer >= 100.0 then
        tazer = 1.0
        local right,forward,up,p = GetCamMatrix(camera)
        forward = forward * 10.0

        SetCanAttackFriendly(PlayerPedId(), true, false)
        SetCanAttackFriendly(drone, true, false)
        NetworkSetFriendlyFireOption(true)
        Wait(0)

        ShootSingleBulletBetweenCoords(p.x,p.y,p.z, p.x+forward.x, p.y+forward.y, p.z+forward.z, 0, false, GetHashKey('WEAPON_STUNGUN'), PlayerPedId(), true, true, 100.0)   
      else
        tazer = math.min(100.0,tazer + (Config.TazerFill * GetFrameTime()))
      end
      Scaleforms.PopInt(Drones.DroneScaleform, "SET_SHOCK_PERCENTAGE", math.floor(tazer))
    end

    if drone_data.abilities.explosive then
      if IsDisabledControlJustPressed(0,Config.Controls.Drone["explosive"].codes[1]) and explosive >= 100.0 then
        local pos = GetEntityCoords(drone)

        Drones.Disconnect(drone, drone_data, true)
        Drones.DestroyCam(camera)
        AddExplosion(pos.x,pos.y,pos.z,1,1.0,true,false,1.0)
        return
      else
        explosive = math.min(100.0, explosive + (1.0 * GetFrameTime()))
      end
      Scaleforms.PopInt(Drones.DroneScaleform, "SET_DETONATE_PERCENTAGE", math.floor(explosive))
    end

    if IsDisabledControlPressed(0,Config.Controls.Drone["centercam"].codes[1]) then
      camera_rotation = vector3(0.0,0.0,0.0)
    end

    if IsDisabledControlPressed(0,Config.Controls.Drone["home"].codes[1]) then
      PointCamAtEntity(camera,PlayerPedId(),0.0,0.0,0.0,1)

      local continue_flying = false
      local dist = Vdist(GetEntityCoords(drone),GetEntityCoords(PlayerPedId()))
      local controls = Drones.CreateControls("home")
      Drones.ButtonsScaleform = Instructional.Create(controls)

      Wait(100)
      while dist > 3.0 do
        local ply_ped   = PlayerPedId()
        local drone_pos = GetEntityCoords(drone)
        local ply_pos   = GetEntityCoords(ply_ped)
        local direction = -V3ClampMagnitude((drone_pos - ply_pos) * 10.0,(Config.MaxVelocity * drone_data.stats.speed))

        DisableAllControlActions(0)
        SetEntityNoCollisionEntity(ply_ped,drone,true)

        ApplyForceToEntity(drone,0,direction.x,direction.y,20.0 + (V2Dist(drone_pos,ply_pos) <= 5.0 and direction.z or 0.0), 0.0,0.0,0.0, 0, 0,1,1,0,1)

        DrawScaleformMovieFullscreen(Drones.ButtonsScaleform,255,255,255,255,0)
        DrawScaleformMovieFullscreen(Drones.DroneScaleform,255,255,255,255,0)

        if IsDisabledControlJustReleased(0,Config.Controls.Homing["cancel"].codes[1]) then
          continue_flying = true
          Wait(100)
          break
        elseif IsDisabledControlJustReleased(0, Config.Controls.Homing["disconnect"].codes[1]) then
          Wait(100)
          break
        end
        
        dist = Vdist(drone_pos,ply_pos)
        SetTimecycleModifierStrength(dist / drone_data.stats.range)
        Wait(0)
      end
      
      if not continue_flying then
        Drones.Disconnect(drone, drone_data)
        Drones.DestroyCam(camera)
        return
      else
        local controls = Drones.CreateControls(drone_data.abilities)
        Drones.ButtonsScaleform = Instructional.Create(controls)
        StopCamPointing(camera)
      end
    end

    if IsDisabledControlJustReleased(0,Config.Controls.Drone["disconnect"].codes[1]) then
      Drones.Disconnect(drone, drone_data)
      Drones.DestroyCam(camera)
      return
    end

    local boost_val = Config.BoostSpeed
    head = head + (rotation_momentum * drone_data.stats.agility)

    if not did_move then
      if V3Magnitude(movement_momentum) > 0.0 then
        movement_momentum = movement_momentum - ((movement_momentum / 10.0) * drone_data.stats.agility)
      end
    end

    ApplyForceToEntity(drone,0,movement_momentum.x,movement_momentum.y,20.0 + movement_momentum.z, 0.0,0.0,0.0, 0, 0,1,1,0,1)
    SetEntityHeading(drone,head)
    SetCamRot(camera,camera_rotation.x,camera_rotation.y,camera_rotation.z+head,2)

    SetTimecycleModifierStrength(dist / drone_data.stats.range)
    DrawScaleformMovieFullscreen(Drones.ButtonsScaleform,255,255,255,255,0)
    DrawScaleformMovieFullscreen(Drones.DroneScaleform,255,255,255,255,0)

    Wait(0)
  end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESTROYCAM
-----------------------------------------------------------------------------------------------------------------------------------------
Drones.DestroyCam = function(cam)
  local ply_ped   = PlayerPedId()
  SetFocusEntity(ply_ped)
  ClearTimecycleModifier()  
  RenderScriptCams(false,true,500,0,0)
  Wait(500)
  stopAnim()
  DestroyCam(cam)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
Drones.Disconnect = function(drone, drone_data, destroy)
  local ply_pos   = GetEntityCoords(PlayerPedId())
  local drone_pos = GetEntityCoords(drone)

  DeleteEntity(drone)

  if not destroy and Vdist(drone_pos, ply_pos) <= 10.0 then
    TriggerServerEvent("Drones:Back", drone_data)
  elseif destroy then
  else
    local pos = GetGroundZ(drone_pos) + vector3(0.0,0.0,0.8)
    TriggerServerEvent("Drones:Disconnect", GetEntityModel(drone), drone_data, pos)
  end

  StopSound(Drones.SoundID)
  ReleaseSoundId(Drones.SoundID)
  Drones.SoundID = nil

  DisplayRadar(Drones.DisplayRadar)

  SetSeethrough(false)
  SetNightvision(false)
  DeleteObject(drone)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATETHREAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
  ClearTimecycleModifier()
  ClearPedTasks(PlayerPedId())
  SetFocusEntity(PlayerPedId())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USE
-----------------------------------------------------------------------------------------------------------------------------------------
Drones.Use = function(drone_data)
  Drones.SceneModels["drone"] = drone_data.model

  Drones.SpawnDrone(drone_data)

  Wait(1000)
  FreezeEntityPosition(PlayerPedId(), false)
  ClearPedTasks(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPDRONE
-----------------------------------------------------------------------------------------------------------------------------------------
Drones.DropDrone = function(drone, drone_data, pos)
  Drones.CreateObject(pos, drone, 1)
  droneDropped = true
  droneDropped_pos = pos
  droneDropped_data = drone_data
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRONES:USEDRONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Drones:UseDrone")
AddEventHandler("Drones:UseDrone", Drones.Use)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRONES:DROPDRONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Drones:DropDrone")
AddEventHandler("Drones:DropDrone", Drones.DropDrone)