ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)

	end
end)

Citizen.CreateThread(function()
	if Config.DrawText then
		while true do
			local coords = GetEntityCoords(GetPlayerPed(-1))
			local closestVehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 70)
			local vehCoords = GetEntityCoords(closestVehicle)
			local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, vehCoords.x, vehCoords.y, vehCoords.z, false)
			Wait(15)
			if distance < Config.DrawTextDistance then
				DrawText3D(vehCoords.x, vehCoords.y, vehCoords.z + 0.3, _U("draw_text"))
			end
		end
	end
end)

RegisterNetEvent("fizzfau-stealFuel:onUse")
AddEventHandler("fizzfau-stealFuel:onUse", function()
	local ped = GetPlayerPed(-1)
	local coords = GetEntityCoords(ped)
	local closestVehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 70)
	local fuel = GetVehicleFuelLevel(closestVehicle)
	print(coords) --Debug
	print(closestVehicle) --Debug
	print(fuellevel) --Debug
	if fuel > 6.0 then
		exports['mythic_progbar']:Progress({
			name = "unique_action_name",
			duration = 7500,
			label = 'Benzin Hortumlanıyor',
			useWhileDead = true,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "timetable@gardener@filling_can",
				anim = "gar_ig_5_filling_can",
				flags = 49,
			},
			prop = {
				model = "prop_cs_petrol_can",
				bone = 18905,
				coords = { x = 0.10, y = 0.02, z = 0.08 },
				rotation = { x = -80.0, y = 0.0, z = 0.0 },
			},
		}, function(status)
			if not status then
				letSleep = false
			end
			SetFuel(closestVehicle, 6.0)
			TriggerServerEvent("fizzfau-stealFuel:removeItem", "hose", 1)
			ESX.TriggerServerCallback("fizzfau-stealFuel:getItemAmount", function(qtty)
					if qtty > 0 then
						exports['mythic_notify']:SendAlert('success', _U('added_gascan'))
						TriggerServerEvent("fizzfau-stealFuel:removeItem", "empty_gascan", 1)
						if Config.Disc_Inventoryhud then
							TriggerServerEvent("fizzfau-stealFuel:addItem", "WEAPON_PETROLCAN", 1)
						else
							TriggerEvent("fizzfau-stealFuel:addGascan")
						end
					else
						exports['mythic_notify']:SendAlert('error', _U('you_dont_have'))
					end
			end, "empty_gascan")
		end)
	elseif fuel <= 6.0 then
		exports['mythic_notify']:SendAlert('error', _U('not_enough_fuel'))
	end
end)

RegisterNetEvent("fizzfau-stealFuel:addGascan")
AddEventHandler("fizzfau-stealFuel:addGascan", function(source)
	local ped = GetPlayerPed(-1)
	GiveWeaponToPed(ped, 883325847, 4500, false, true)
	SetPedAmmo(ped, 883325847, 4500)
end)


function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
	end
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 400
    DrawRect(_x,_y+0.0125, 0.0002+ factor, 0.025, 0, 0, 0, 50)
end