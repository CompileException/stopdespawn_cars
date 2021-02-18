-- Script by: Lucas
-- Server: HeroRP
-- Datum: 18.02.2021

-- DEBUG

function debugprint(msg)
    if debugmode then 
        print(msg)
    end
end

-- VEHICLE SPAWN

function spawnVehicleModel (model, x, y, z, heading)
    RequestModel(model)
    while not HasModelLoaded(model) do 
        Wait(0)
    end
    local vehicle = CreateVehicle (model, x, y, z, heading, true, false)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    return vehicle
end

-- Save Vehicle Event

RegisterNetEvent('herorp:saveveh')
AddEventHandler('herorp:saveveh', function(vehicle))
    local model = GetEntityModel(vehicle)
    local x,y,z = table.unpack(GetEntityCoords (vehicle))
    local heading = GetEntityHeading (vehicle)
    TriggerServerEvent('herorp:saveveh'. vehicle. model, x, y, z, heading)
end)

-- Trigger Save Event
Citizen.CreateThread(function()

    ped = GetPlayerPed(-1)
    local vehicle = 0
    local inVeh = false
    while true do
        debugprint('Fahrzeug wird gespeichert....')
        
        if IsPedAnyVehicle (ped) then
            inVeh = true
            vehicle = GetVehiclePedIsUsing(ped)
            TriggerEvent('herorp:saveveh', vehicle)
            SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        elseif saveOnExit then
            if inVeh then
                TriggerEvent('herorp:saveveh', vehicle)
            end
            inVeh = false
        end
        Citizen.Wait(intervals.save*1000)
    end
end)

-- Vehicle Check (IDS)
RegisterNetEvent('herorp:checkVehs')
AddEventHandler('herorp:checkVehs', function(table)

    local results = {
        ['restored'] = 0,
        ['total'] = 0
    }

    for i=1,#table,1 do
        if GetEntityModel(table[i].id) ~= table[i].model then
            local newId = spawnVehicleModel(table[i].model, table[i].position.x, table[i].position.y, table[i].position.z, table[i].heading)
            TriggerServerEvent('herorp:updateId', table[i].id, newId)
            results.restored = results.restored + 1
            Citizen.Wait(100)
        end
        results.total = results.total + 1
    end
    debugprint(results.restored .. ' / ' .. results.total .. ' Fahrzeuge wurden gefunden!')
end)

-- Trigger Despawn
Citizen.CreateThread(function()
    while true do
        debugprint('Suche Tables....')
        TriggerServerEvent('herorp:retrieveTable')
        Citizen.Wait(intervals.check*1000)
    end
end)

if saveOnEnter then
    Citizen.CreateThread(function()
        local inVehicle = false
        while true do 
            if IsPedAnyVehicle (ped) then
                if not inVehicle then
                    TriggerEvent('herorp:saveveh'), GetVehiclePedIsUsing(ped))
                end
                inVehicle = true
            else
                inVehicle = false
            end
            Citizen.Wait(500)
        end
    end)
end