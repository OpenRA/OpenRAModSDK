InitialForcesA = { "bggy", "e1", "e1", "e1", "e1" }
InitialForcesB = { "e1", "e1", "bggy", "e1", "e1" }

RifleInfantryReinforcements = { "e1", "e1" }
RocketInfantryReinforcements = { "e3", "e3", "e3" }

SendInitialForces = function()
	Media.PlaySpeechNotification(player, "Reinforce")
	Media.PlaySpeechNotification(player1, "Reinforce")
	Reinforcements.Reinforce(player, InitialForcesA, { StartSpawnPointLeft.Location, StartRallyPoint.Location }, 5)
	Reinforcements.Reinforce(player1, InitialForcesB, { StartSpawnPointRight.Location, StartRallyPoint.Location }, 10)
end

SendFirstInfantryReinforcements = function()
	Media.PlaySpeechNotification(player, "Reinforce")
	Reinforcements.Reinforce(player, RifleInfantryReinforcements, { StartSpawnPointRight.Location, StartRallyPoint.Location }, 15)
	Media.PlaySpeechNotification(player1, "Reinforce")
	Reinforcements.Reinforce(player1, RifleInfantryReinforcements, { StartSpawnPointRight.Location, StartRallyPoint.Location }, 15)
end

SendSecondInfantryReinforcements = function()
	Media.PlaySpeechNotification(player, "Reinforce")
	Reinforcements.Reinforce(player, RifleInfantryReinforcements, { StartSpawnPointLeft.Location, StartRallyPoint.Location }, 15)
	Media.PlaySpeechNotification(player1, "Reinforce")
	Reinforcements.Reinforce(player1, RifleInfantryReinforcements, { StartSpawnPointLeft.Location, StartRallyPoint.Location }, 15)
end

SendLastInfantryReinforcements = function()
	Media.PlaySpeechNotification(player, "Reinforce")

	-- Move the units properly into the map before they start attacking
	local forces = Reinforcements.Reinforce(player, RocketInfantryReinforcements, { VillageSpawnPoint.Location, VillageRallyPoint.Location }, 8)
	Utils.Do(forces, function(a)
		a.Stance = "Defend"
		a.CallFunc(function() a.Stance = "AttackAnything" end)
	end)
end

SendLastInfantryReinforcements1 = function()
	Media.PlaySpeechNotification(player1, "Reinforce")

	-- Move the units properly into the map before they start attacking
	local forces = Reinforcements.Reinforce(player1, RocketInfantryReinforcements, { VillageSpawnPoint.Location, VillageRallyPoint.Location }, 8)
	Utils.Do(forces, function(a)
		a.Stance = "Defend"
		a.CallFunc(function() a.Stance = "AttackAnything" end)
	end)
end

WorldLoaded = function()
	player = Player.GetPlayer("Nod")
	player1 = Player.GetPlayer("Nod1")
	enemy = Player.GetPlayer("GDI")
	villagers = Player.GetPlayer("Villagers")

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

	NodObjective1 = player.AddPrimaryObjective("Kill Nikoomba."), player1.AddPrimaryObjective("Kill Nikoomba.")
	NodObjective2 = player.AddPrimaryObjective("Destroy the village."), player1.AddPrimaryObjective("Destroy the village.")
	NodObjective3 = player.AddSecondaryObjective("Destroy all GDI troops in the area."), player1.AddSecondaryObjective("Destroy all GDI troops in the area.")
	GDIObjective1 = enemy.AddPrimaryObjective("Eliminate all Nod forces.")

	Trigger.OnKilled(Nikoomba, function()
		player.MarkCompletedObjective(NodObjective1)
		player1.MarkCompletedObjective(NodObjective1)
		Trigger.AfterDelay(DateTime.Seconds(1), function()
			SendLastInfantryReinforcements()
			SendLastInfantryReinforcements1()
		end)
	end)

	Camera.Position = StartRallyPoint.CenterPosition

	Trigger.AfterDelay(DateTime.Seconds(0), function()
		Media.PlayMovieFullscreen("intro2.vqa")
	end)

	Trigger.AfterDelay(DateTime.Seconds(1), function()
		Media.PlayMovieFullscreen("nod1.vqa")
	end)

	Trigger.AfterDelay(DateTime.Seconds(2), SendInitialForces)
	Trigger.AfterDelay(DateTime.Seconds(32), SendFirstInfantryReinforcements)
	Trigger.AfterDelay(DateTime.Seconds(62), SendSecondInfantryReinforcements)
end



Tick = function()
	if DateTime.GameTime > 2 then
		if player.HasNoRequiredUnits() or (player2 and player2.HasNoRequiredUnits()) then
			enemy.MarkCompletedObjective(GDIObjective1)
		end
		if villagers.HasNoRequiredUnits() then
			player.MarkCompletedObjective(NodObjective2)
			player1.MarkCompletedObjective(NodObjective2)
		end
		if enemy.HasNoRequiredUnits() then
			player.MarkCompletedObjective(NodObjective3)
			player1.MarkCompletedObjective(NodObjective3)
		end
	end
end
