fx_version("cerulean")
game("rdr3")
rdr3_warning(
	"I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships."
)
lua54("yes")

shared_scripts({
	"@ox_lib/init.lua",
	"shared/*.lua",
})

client_script({
	"client/*.lua",
})

ui_page("html/index.html")

files({
	"html/**/*",
})
