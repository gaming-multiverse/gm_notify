local Config = require("shared.client")

if Config.debug then
	RegisterCommand("notifySuccess", function()
		NotificationNuiHandler("success", "test notify", 5000)
	end)
	RegisterCommand("notifyError", function()
		NotificationNuiHandler("error", "test notify", 5000)
	end)
	RegisterCommand("notifyWarning", function()
		NotificationNuiHandler("warning", "test notify", 5000)
	end)
end
