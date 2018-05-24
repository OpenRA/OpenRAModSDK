WorldLoaded = function()
	neutral = Player.GetPlayer("Neutral")
end

Tick = function()
	if (neutral.HasPrerequisites( { "MapEffects" } ))
		if (Utils.RandomInteger(1, 200) == 10) then
			local delay = Utils.RandomInteger(1, 10)
			Lighting.Flash("LightningStrike", delay)
			Trigger.AfterDelay(delay, function()
				Media.PlaySound("thunder" .. Utils.RandomInteger(1,6) .. ".aud")
			end)
		end
		if (Utils.RandomInteger(1, 200) == 10) then
			Media.PlaySound("thunder-ambient.aud")
		end
	end
end