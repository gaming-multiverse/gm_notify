local Config = require("shared.client")

NotificationNuiHandler = function(notifyType, message, duration)
	if duration == nil then
		duration = 5000
	end
	if notifyType == nil then
		notify = "warning"
	end

	SendNUIMessage({
		action = "displayNotification",
		data = {
			notifyType = notifyType,
			message = message,
			duration = duration,
		},
	})
end

RegisterNetEvent("ws_notify:client:Nofity", function(notifyType, message, duration)
	NotificationNuiHandler(notifyType, message, duration)
end)

if Config.ox_lib_replacement then
	RegisterNetEvent("ox_lib:notify", function(data)
		local notifyType = data.type
		local message = data.description
		local duration = data.duration

		if data.type == nil then
			notifyType = "primary"
		end

		if data.title ~= nil and data.description == nil then
			message = data.title
		elseif data.title ~= nil and data.description ~= nil then
			message = data.description
		end

		if duration == nil then
			duration = 3500
		end

		NotificationNuiHandler(notifyType, message, duration)
	end)
end

RegisterNUICallback("ws_notify:nui:sendMaxVisibleNotifications", function(data, cb)
	cb(Config.maxVisibleNotifications)
end)

exports("notify", NotificationNuiHandler)
