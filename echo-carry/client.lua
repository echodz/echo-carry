local QBCore = exports['qb-core']:GetCoreObject()

local holdingBody = false
local carrying = false
local currentTarget = nil

RegisterNetEvent('carry:showMenu')
AddEventHandler('carry:showMenu', function(carrierId)
    local carryMenu = {
        {
            header = "Do you want to be carried?",
            isMenuHeader = true
        },
        {
            header = "Yes",
            icon = 'fas fa-check',
            params = {
                event = 'carry:accept',
                args = carrierId
            }
        },
        {
            header = "No",
            icon = 'fas fa-times',
            params = {
                event = 'carry:decline'
            }
        },
        {
            header = "Cancel",
            icon = 'fas fa-x',
            params = {
                event = 'qb-menu:close'
            }
        }
    }
    exports['qb-menu']:openMenu(carryMenu)
end)


RegisterNetEvent('carry:accept')
AddEventHandler('carry:accept', function(carrierId)
    local playerPed = GetPlayerPed(-1)
    local carrierPed = GetPlayerPed(GetPlayerFromServerId(carrierId))

    currentTarget = carrierId
    carrying = true

    QBCore.Functions.Notify('You are now being carried. Press E to release carry.')

    -- Attach the player to the carrier only after the request is accepted
    AttachEntityToEntity(playerPed, carrierPed, 1, -0.68, -0.2, 0.94, 180.0, 180.0, 60.0, 1, 1, 0, 1, 0, 1)

    -- Play the animation for the player being carried (if not already playing)
    if not IsEntityPlayingAnim(playerPed, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 3) then
        loadAnim("amb@world_human_bum_slumped@male@laying_on_left_side@base")
        TaskPlayAnim(playerPed, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
    end

    -- Play the animation for the carrier (if not already playing)
    if not IsEntityPlayingAnim(carrierPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
        loadAnim("missfinale_c2mcs_1")
        TaskPlayAnim(carrierPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)
    end

    -- Disable movement controls while carrying
    while carrying do
        DisableControlAction(1, 19, true)  -- Disable movement
        DisableControlAction(0, 34, true)  -- Disable looking around
        DisableControlAction(0, 9, true)   -- Disable inventory
        DisableControlAction(0, 288, true) -- Disable various other controls

        if IsControlJustPressed(0, 38) then  -- E key to release carry
            carrying = false
            ClearPedTasks(playerPed)
            DetachEntity(playerPed, true, false)
            TriggerServerEvent("carry:stop", carrierId,playerPed)
        end

        Wait(1)
    end
end)




RegisterNetEvent('carry:decline')
AddEventHandler('carry:decline', function()
    QBCore.Functions.Notify('You declined the carry request.')
    currentTarget = nil
    carrying = false
end)

RegisterNetEvent('carry:syncMe')
AddEventHandler('carry:syncMe', function()
    local playerPed = GetPlayerPed(-1)
    local carrierPed = GetPlayerPed(GetPlayerFromServerId(currentTarget))


    QBCore.Functions.Notify('You have been synced to carry the player.')

    if not IsEntityPlayingAnim(carrierPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
        loadAnim("missfinale_c2mcs_1")
        TaskPlayAnim(carrierPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)
    end
end)

RegisterNetEvent('carry:stop')
AddEventHandler('carry:stop', function()
    carrying = false
    ClearPedTasks(PlayerPedId())
    DetachEntity(GetPlayerPed(-1), true, false)
end)


function loadAnim(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end


RegisterNetEvent('carry:command')
AddEventHandler('carry:command', function()
    if not carrying then
        local closestPlayer, closestDistance = QBCore.Functions.GetClosestPlayer()


        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            local closestPlayerId = GetPlayerServerId(closestPlayer)

            TriggerServerEvent('carry:sync', closestPlayerId)
        else
            QBCore.Functions.Notify('No players nearby to carry.')
        end
    else
        QBCore.Functions.notify('You are already carrying someone.')
    end
end, false)
