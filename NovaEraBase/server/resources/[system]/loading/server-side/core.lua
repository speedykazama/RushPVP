-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerConnecting", function(_, _, deferrals)
	deferrals.defer()

	deferrals.handover({
		video = Video,
		socials = Socials,
		playlist = Playlist,
		autoplay = Autoplay,
		shortcuts = Shortcuts,
		title = LoadingTitle,
		subtitle = LoadingSubtitle
	})

	deferrals.done()
end)
