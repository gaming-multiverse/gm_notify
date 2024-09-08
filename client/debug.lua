local Config = require("shared.client")

-- If you arent using rsg please delete/comment the following code
local RSGCore = exports["rsg-core"]:GetCoreObject()

if Config.debug then
	RegisterCommand("notifySuccess", function()
		print("yeet")
		NotificationNuiHandler("success", "test notify", 5000)
	end)
	RegisterCommand("notifyError", function()
		NotificationNuiHandler("error", "test notify", 5000)
	end)
	RegisterCommand("notifyWarning", function()
		NotificationNuiHandler("warning", "test notify", 5000)
	end)
end
