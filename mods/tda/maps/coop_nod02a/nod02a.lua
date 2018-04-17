NodUnits = { "bggy", "e1", "e1", "e1", "e1", "bggy" }
NodUnits1 = { "bggy", "e1", "e1", "e1", "e1", "mhqcoop" }
NodBaseBuildings = { "hand", "fact", "nuke" }
NodBaseBuildings1 = { "hand", "nuke" }

DfndActorTriggerActivator = { Refinery, Barracks, Powerplant, Yard }
Atk3ActorTriggerActivator = { Guard1, Guard2, Guard3, Guard4, Guard5, Guard6, Guard7 }

Atk1CellTriggerActivator = { CPos.New(45,37), CPos.New(44,37), CPos.New(45,36), CPos.New(44,36), CPos.New(45,35), CPos.New(44,35), CPos.New(45,34), CPos.New(44,34) }
Atk4CellTriggerActivator = { CPos.New(50,47), CPos.New(49,47), CPos.New(48,47), CPos.New(47,47), CPos.New(46,47), CPos.New(45,47), CPos.New(44,47), CPos.New(43,47), CPos.New(42,47), CPos.New(41,47), CPos.New(40,47), CPos.New(39,47), CPos.New(38,47), CPos.New(37,47), CPos.New(50,46), CPos.New(49,46), CPos.New(48,46), CPos.New(47,46), CPos.New(46,46), CPos.New(45,46), CPos.New(44,46), CPos.New(43,46), CPos.New(42,46), CPos.New(41,46), CPos.New(40,46), CPos.New(39,46), CPos.New(38,46) }

Atk2TriggerFunctionTime = DateTime.Seconds(40)
Atk5TriggerFunctionTime = DateTime.Minutes(1) + DateTime.Seconds(15)
Atk6TriggerFunctionTime = DateTime.Minutes(1) + DateTime.Seconds(20)
Atk7TriggerFunctionTime = DateTime.Seconds(50)
Pat1TriggerFunctionTime = DateTime.Seconds(30)

Atk1Waypoints = { waypoint2, waypoint4, waypoint5, waypoint6 }
Atk2Waypoints = { waypoint2, waypoint5, waypoint7, waypoint6 }
Atk3Waypoints = { waypoint2, waypoint4, waypoint5, waypoint9 }
Atk4Waypoints = { waypoint0, waypoint8, waypoint9 }
Pat1Waypoints = { waypoint0, waypoint1, waypoint2, waypoint3 }

UnitToRebuild = 'e1'
GDIStartUnits = 0

getActors = function(owner, units)
	local maxUnits = 0
	local actors = { }
	for type, count in pairs(units) do
		local globalActors = Utils.Where(Map.ActorsInWorld, function(actor)
			return actor.Owner == owner and actor.Type == type and not actor.IsDead
		end)
		if #globalActors < count then
			maxUnits = #globalActors
		else
			maxUnits = count
		end
		for i = 1, maxUnits, 1 do
			actors[#actors + 1] = globalActors[i]
		end
	end
	return actors
end
-- InsertNodUnits coop part
InsertNodUnits = function()
	Media.PlaySpeechNotification(player, "Reinforce")
	Reinforcements.Reinforce(player, NodUnits, { UnitsEntry.Location, UnitsRally.Location }, 15)
	Reinforcements.Reinforce(player, { "mcv" }, { McvEntry.Location, McvRally.Location })
	Media.PlaySpeechNotification(player1, "Reinforce")
	Reinforcements.Reinforce(player1, NodUnits1, { UnitsEntry.Location, UnitsRally.Location }, 15)
end
-- End of InsertNodUnits coop part
OnAnyDamaged = function(actors, func)
	Utils.Do(actors, function(actor)
		Trigger.OnDamaged(actor, func)
	end)
end
-- CheckForBase coop part
CheckForBase = function(player)
	local buildings = 0

	Utils.Do(NodBaseBuildings, function(name)
		if #player.GetActorsByType(name) > 0 then
			buildings = buildings + 1
		end
	end)

	return buildings == #NodBaseBuildings
end

CheckForBase1 = function(player1)
	local buildings = 0

	Utils.Do(NodBaseBuildings, function(name)
		if #player1.GetActorsByType(name) > 0 then
			buildings = buildings + 1
		end
	end)

	return buildings == #NodBaseBuildings1
end
-- End of CheckForBase coop part
DfndTriggerFunction = function()
	local list = enemy.GetGroundAttackers()
	Utils.Do(list, function(unit)
		IdleHunt(unit)
	end)
end

Atk2TriggerFunction = function()
	local MyActors = getActors(enemy, { ['e1'] = 3 })
	Utils.Do(MyActors, function(actor)
		Atk2Movement(actor)
	end)
end

Atk3TriggerFunction = function()
	if not Atk3TriggerSwitch then
		Atk3TriggerSwitch = true
		MyActors = getActors(enemy, { ['e1'] = 4 })
		Utils.Do(MyActors, function(actor)
			Atk3Movement(actor)
		end)
	end
end

Atk5TriggerFunction = function()
	local MyActors = getActors(enemy, { ['e1'] = 3 })
	Utils.Do(MyActors, function(actor)
		Atk2Movement(actor)
	end)
end

Atk6TriggerFunction = function()
	local MyActors = getActors(enemy, { ['e1'] = 4 })
	Utils.Do(MyActors, function(actor)
		Atk3Movement(actor)
	end)
end

Atk7TriggerFunction = function()
	local MyActors = getActors(enemy, { ['e1'] = 3 })
	Utils.Do(MyActors, function(actor)
		Atk4Movement(actor)
	end)
end

Pat1TriggerFunction = function()
	local MyActors = getActors(enemy, { ['e1'] = 3 })
	Utils.Do(MyActors, function(actor)
		Pat1Movement(actor)
	end)
end

Atk1Movement = function(unit)
	Utils.Do(Atk1Waypoints, function(waypoint)
		unit.AttackMove(waypoint.Location)
	end)
	IdleHunt(unit)
end

Atk2Movement = function(unit)
	Utils.Do(Atk2Waypoints, function(waypoint)
		unit.AttackMove(waypoint.Location)
	end)
	IdleHunt(unit)
end

Atk3Movement = function(unit)
	Utils.Do(Atk3Waypoints, function(waypoint)
		unit.AttackMove(waypoint.Location)
	end)
	IdleHunt(unit)
end

Atk4Movement = function(unit)
	Utils.Do(Atk4Waypoints, function(waypoint)
		unit.AttackMove(waypoint.Location)
	end)
	IdleHunt(unit)
end

Pat1Movement = function(unit)
	Utils.Do(Pat1Waypoints, function(waypoint)
		unit.Move(waypoint.Location)
	end)
	IdleHunt(unit)
end
-- Lost actions to be done
CoopLost = function()
	Trigger.AfterDelay(DateTime.Seconds(1), function()
		enemy.MarkCompletedObjective(GDIObjective)
		player.MarkFailedObjective(NodObjective2)
		player1.MarkFailedObjective(NodObjective2)
	end)
	Trigger.AfterDelay(DateTime.Seconds(7), function()
		Media.PlayMovieFullscreen("deskill.vqa")
	end)
end
-- The objectives to be added
AddObjectives = function()
	NodObjective1 = player.AddPrimaryObjective("Build a base."), player1.AddPrimaryObjective("Build a base.")
	NodObjective2 = player.AddPrimaryObjective("Destroy the GDI base."), player1.AddPrimaryObjective("Destroy the GDI base.")
	GDIObjective = enemy.AddPrimaryObjective("Kill all enemies.")
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

	OnAnyDamaged(Atk3ActorTriggerActivator, Atk3TriggerFunction)
	Trigger.OnAllRemovedFromWorld(DfndActorTriggerActivator, DfndTriggerFunction)

	Trigger.AfterDelay(Atk2TriggerFunctionTime, Atk2TriggerFunction)
	Trigger.AfterDelay(Atk5TriggerFunctionTime, Atk5TriggerFunction)
	Trigger.AfterDelay(Atk6TriggerFunctionTime, Atk6TriggerFunction)
	Trigger.AfterDelay(Atk7TriggerFunctionTime, Atk7TriggerFunction)
	Trigger.AfterDelay(Pat1TriggerFunctionTime, Pat1TriggerFunction)

	Trigger.OnEnteredFootprint(Atk1CellTriggerActivator, function(a, id)
		if a.Owner == player or player1 then
			MyActors = getActors(enemy, { ['e1'] = 5 })
			Utils.Do(MyActors, function(actor)
				Atk1Movement(actor)
			end)
			Trigger.RemoveFootprintTrigger(id)
		end
	end)

	Trigger.OnEnteredFootprint(Atk4CellTriggerActivator, function(a, id)
		if a.Owner == player or player1 then
			MyActors = getActors(enemy, { ['e1'] = 3 } )
			Utils.Do(MyActors, function(actor)
				Atk2Movement(actor)
			end)
			Trigger.RemoveFootprintTrigger(id)
		end
	end)
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
		Media.PlayMovieFullscreen("nod2.vqa")
	end)

	Trigger.AfterDelay(DateTime.Seconds(1), function()
		Media.PlayMovieFullscreen("seige.vqa")
	end)
-- End of intro movies
	Trigger.AfterDelay(2, getStartUnits)

end

Tick = function()
-- Lost
	if DateTime.GameTime > DateTime.Seconds(7) and player.HasNoRequiredUnits() and player1.HasNoRequiredUnits() and DateTime.GameTime > 1 and not player.MarkFailedObjective(NodObjective2) and not player1.MarkFailedObjective(NodObjective2) then
		CoopLost()
	end
	if DateTime.GameTime > DateTime.Seconds(7) and not player.IsObjectiveCompleted(NodObjective1) and not player1.IsObjectiveCompleted(NodObjective1) and CheckForBase(player) and CheckForBase1(player1) then
		player.MarkCompletedObjective(NodObjective1)
		player1.MarkCompletedObjective(NodObjective1)
	end
-- All this LUA is too much to bear, oh how much i hope for a GUI!!!
-- Win
	if DateTime.GameTime > DateTime.Seconds(7) and DateTime.GameTime % DateTime.Seconds(3) == 0 and player.IsObjectiveCompleted(NodObjective1) and player1.IsObjectiveCompleted(NodObjective1) and not player.IsObjectiveCompleted(NodObjective2) and not player1.IsObjectiveCompleted(NodObjective2) and enemy.HasNoRequiredUnits() then
		player.MarkCompletedObjective(NodObjective2)
		player1.MarkCompletedObjective(NodObjective2)
		enemy.MarkFailedObjective(GDIObjective)
		Media.PlayMovieFullscreen("airstrk.vqa")
	end
-- end of win\lost
	if DateTime.GameTime % DateTime.Seconds(3) == 0 and Barracks.IsInWorld and Barracks.Owner == enemy then
		checkProduction(enemy)
	end
end

checkProduction = function(player)
	local Units = Utils.Where(Map.ActorsInWorld, function(actor)
		return actor.Owner == player and actor.Type == UnitToRebuild
	end)

	if #Units < GDIStartUnits then
		local unitsToProduce = GDIStartUnits - #Units
		if Barracks.IsInWorld and unitsToProduce > 0 then
			local UnitsType = { }
			for i = 1, unitsToProduce, 1 do
				UnitsType[i] = UnitToRebuild
			end
			Barracks.Build(UnitsType)
		end
	end
end

getStartUnits = function()
	local Units = Utils.Where(Map.ActorsInWorld, function(actor)
		return actor.Owner == enemy
	end)
	Utils.Do(Units, function(unit)
		if unit.Type == UnitToRebuild then
			GDIStartUnits = GDIStartUnits + 1
		end
	end)
end

IdleHunt = function(unit)
	if not unit.IsDead then
		Trigger.OnIdle(unit, unit.Hunt)
	end
end
