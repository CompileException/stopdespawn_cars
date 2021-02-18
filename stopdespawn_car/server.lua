-- Script by: Lucas
-- Server: HeroRP
-- Datum: 18.02.2021

-- DEBUG

function debugprint(msg)
    if debugmode then 
        print(msg)
    end
end

-- Vehicle Table (SAVE)
local vehicles = {}

-- Update ID´s
RegisterServerEvent('herorp:updateId')
AddEventHandler('herorp:updateId', function(oldId, newId)
    for i=1, #vehicles,1 do
        if vehicles[i].id == oldId then
            vehicles[i].id = newId
        end
    end
end)

-- Complete Save in Table and send info
function insert(index, id, model, x, y, z, heading)
    vehicles[index] = {
        ['id'] = id,
		['model'] = model,
		['position'] = {
			['x'] = x,
			['y'] = y,
			['z'] = z
		},
		['heading'] = heading
	}
end

-- Save Vehicles
RegisterServerEvent('herorp:saveveh')
AddEventHandler('herorp:saveveh', function(id, model, x, y, z, heading)
	if vehicles[1] then
		for i=1,#vehicles,1 do
			if vehicles[i].id == id then
				insert(i, id, model, x, y, z, heading)
				debugprint(model .. '(' .. id ..')' .. 'updated!')
				break
			elseif i == #vehicles then
				insert(#vehicles+1, id, model, x, y, z, heading)
				debugprint(model .. '(' .. id ..')' .. 'added!')
			end
		end
	else
		insert(#vehicles+1, id, model, x, y, z, heading)
		debugprint(model .. '(' .. id ..')' .. 'added!')
	end
end)


-- Load Tables
RegisterServerEvent('herorp:retrieveTable')
AddEventHandler('herorp:retrieveTable', function()
	debugprint('Suche Fahrzeuge')
	TriggerClientEvent('herorp:checkVehs', GetPlayers()[1], vehicles)
end)

AddEventHandler('EnteredVehicle')