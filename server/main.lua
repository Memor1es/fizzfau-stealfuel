ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('hose', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent("fizzfau-stealFuel:onUse", source)
end)


ESX.RegisterServerCallback("fizzfau-stealFuel:getItemAmount", function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local qtty = xPlayer.getInventoryItem(item).count
	cb(qtty)
end)

RegisterServerEvent("fizzfau-stealFuel:addItem")
AddEventHandler("fizzfau-stealFuel:addItem", function(item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(item, count)
end)

RegisterServerEvent("fizzfau-stealFuel:removeItem")
AddEventHandler("fizzfau-stealFuel:removeItem", function(item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(item, count)
end)