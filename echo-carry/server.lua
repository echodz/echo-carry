local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('carry:sync')
AddEventHandler('carry:sync', function(target)
    TriggerClientEvent('carry:showMenu', target, source)
    TriggerClientEvent('carry:syncMe', source)
end)

RegisterServerEvent('carry:stop')
AddEventHandler('carry:stop', function(target)
    TriggerClientEvent('carry:stop', target)
end)
