NodUnits = { "bggy", "bggy", "mtnk", }
NodUnits1 = { "bike", "bike", "e3", "e1", "e3", "e1", "e1", }
FirstAttackWave = { "e1", "e1", "e1", "e2", }
SecondThirdAttackWave = { "jeep", "e1", "e1", "e2", "e1","e1","e1", }
RepeatWave = { "e1", "e2", "e1", "e1", "e1", }
CleanUpTeam = {"ltnk", "ltnk", "ltnk", }

SendAttackWaveNod = function(units, spawnPoint)
	Reinforcements.Reinforce(player, units, { spawnPoint }, DateTime.Seconds(1), function(actor)
		actor.AttackMove(PlayerBase.Location)
	end)
end

SendAttackWave = function(units, spawnPoint)
	Reinforcements.Reinforce(enemy, units, { spawnPoint }, DateTime.Seconds(1), function(actor)
		actor.AttackMove(PlayerBase.Location)
	end)
	Trigger.AfterDelay(DateTime.Seconds(200), function() SendAttackWave(RepeatWave, AttackWaveSpawnC.Location) end)
end

InsertNodUnits = function()
	Media.PlaySpeechNotification(player, "Reinforce")
	Media.PlaySpeechNotification(player1, "Reinforce")
	Reinforcements.Reinforce(player, NodUnits, { NodEntry.Location, NodRallyPoint.Location })
	Reinforcements.Reinforce(player1, NodUnits1, { NodEntry.Location, NodRallyPoint.Location })
	Trigger.AfterDelay(DateTime.Seconds(8), function()
		Reinforcements.Reinforce(player1, { "mhqcoop" }, { NodEntry.Location, NodRallyPoint.Location })
		Reinforcements.Reinforce(player, { "mcv" }, { NodEntry.Location, PlayerBase.Location })
	end)
end

-- Lost actions to be done
CoopLost = function()
	Trigger.AfterDelay(DateTime.Seconds(1), function()
		enemy.MarkCompletedObjective(GDIObjective)
		player.MarkFailedObjective(NodObjective2)
		player1.MarkFailedObjective(NodObjective2)
	end)
	Trigger.AfterDelay(DateTime.Seconds(7), function()
		Media.PlayMovieFullscreen("flag.vqa")
	end)
end
-- The objectives to be added
AddObjectives = function()
	GDIObjective = enemy.AddPrimaryObjective("Eliminate all Nod forces in the area.")
	NodObjective1 = player.AddPrimaryObjective("Capture the prison.")
	NodObjective2 = player.AddSecondaryObjective("Destroy all GDI main forces.")
	NodObjective1 = player1.AddPrimaryObjective("Capture the prison.")
	NodObjective2 = player1.AddSecondaryObjective("Destroy all GDI forces.")
end

WorldLoaded = function()
	player = Player.GetPlayer("Nod")
	player1 = Player.GetPlayer("Nod1")
	enemy = Player.GetPlayer("GDI")

	Trigger.OnObjectiveAdded(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "New " .. string.lower(p.GetObjectiveType(id)) .. " objective")
	end)
	Trigger.OnObjectiveCompleted(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "Objective completed")
	end)
	Trigger.OnObjectiveFailed(player, function(p, id)
		Media.DisplayMessage(p.GetObjectiveDescription(id), "Objective failed")
	end)

	Trigger.OnPlayerWon(player, function()
		Media.PlaySpeechNotification(player, "Win")
	end)
	Trigger.OnPlayerWon(player1, function()
		Media.PlaySpeechNotification(player1, "Win")
	end)

	Trigger.OnPlayerLost(player, function()
		Media.PlaySpeechNotification(player, "Lose")
	end)
	Trigger.OnPlayerLost(player1, function()
		Media.PlaySpeechNotification(player1, "Lose")
	end)

	Trigger.OnCapture(TechCenter, function()
		Trigger.AfterDelay(DateTime.Seconds(15), function()
			player.MarkCompletedObjective(NodObjective1)
			player1.MarkCompletedObjective(NodObjective1)
		end)
		Trigger.AfterDelay(DateTime.Seconds(3), function()
			SendAttackWave(RepeatWave, AttackWaveSpawnC.Location)
		end)
		Trigger.AfterDelay(DateTime.Seconds(10), function()
			Media.PlaySpeechNotification(player, "Reinforce")
			Media.PlaySpeechNotification(player1, "Reinforce")
			SendAttackWaveNod(CleanUpTeam, AttackWaveSpawnC.Location)
		end)
		Trigger.AfterDelay(DateTime.Seconds(19), function()
			Media.PlayMovieFullscreen("desflees.vqa")
			enemy.MarkFailedObjective(GDIObjective)
		end)
	end)

	Trigger.OnKilled(TechCenter, function()
		player.MarkFailedObjective(NodObjective1)
		player1.MarkFailedObjective(NodObjective1)
		enemy.MarkCompletedObjective(GDIObjective)
		Trigger.AfterDelay(DateTime.Seconds(5), function()
			Media.PlayMovieFullscreen("flag.vqa")
		end)
	end)

	Trigger.AfterDelay(DateTime.Seconds(23), function() SendAttackWave(FirstAttackWave, AttackWaveSpawnA.Location) end)
	Trigger.AfterDelay(DateTime.Seconds(53), function() SendAttackWave(SecondThirdAttackWave, AttackWaveSpawnB.Location) end)
	Trigger.AfterDelay(DateTime.Seconds(103), function() SendAttackWave(SecondThirdAttackWave, AttackWaveSpawnC.Location) end)

-- Delay for intro videos
	Trigger.AfterDelay(DateTime.Seconds(3), function()
		InsertNodUnits()
	end)
-- Add objectives
	Trigger.AfterDelay(DateTime.Seconds(6), function()
		AddObjectives()
	end)
-- Play intro movies
	Trigger.AfterDelay(DateTime.Seconds(0), function()
		Media.PlayMovieFullscreen("nod3.vqa")
	end)

	Trigger.AfterDelay(DateTime.Seconds(1), function()
		Media.PlayMovieFullscreen("dessweep.vqa")
	end)
-- End of intro movies

end

Tick = function()

-- Lost
	if DateTime.GameTime > DateTime.Seconds(7) and player.HasNoRequiredUnits() and player1.HasNoRequiredUnits() and DateTime.GameTime > 1 and not player.MarkFailedObjective(NodObjective2) and not player1.MarkFailedObjective(NodObjective2) then
		CoopLost()
	end

-- Win all objectives done
	if DateTime.GameTime > DateTime.Seconds(7) and DateTime.GameTime % DateTime.Seconds(3) == 0 and player.IsObjectiveCompleted(NodObjective1) and player1.IsObjectiveCompleted(NodObjective1) and player.IsObjectiveCompleted(NodObjective2) and player1.IsObjectiveCompleted(NodObjective2) and enemy.HasNoRequiredUnits() then
		player.MarkCompletedObjective(NodObjective2)
		player1.MarkCompletedObjective(NodObjective2)
		enemy.MarkFailedObjective(GDIObjective)
		Media.PlayMovieFullscreen("desflees.vqa")
	end
-- Secondary objectives done only
	if DateTime.GameTime > DateTime.Seconds(7) and DateTime.GameTime % DateTime.Seconds(3) == 0 and not player.IsObjectiveCompleted(NodObjective1) and not player1.IsObjectiveCompleted(NodObjective1) and enemy.HasNoRequiredUnits() then
		player.MarkCompletedObjective(NodObjective2)
		player1.MarkCompletedObjective(NodObjective2)
		enemy.MarkFailedObjective(GDIObjective)
	end
end
