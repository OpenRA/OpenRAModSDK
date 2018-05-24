Light = 1.000
ColorR = 1.000
ColorG = 1.000
ColorB = 1.000
TimeOfDay = 10.50

WorldLoaded = function()
	neutral = Player.GetPlayer("Neutral")

	-- Pick the starting hour
	Hour10h()
	
	if neutral.HasPrerequisites( { "MapEffects" } ) then
		-- The "Clock"
		AddHour()

		-- The Repeat script
		Repeat()
	end
end

AddHour = function()
	if (TimeOfDay < 23.00) then
		TimeOfDay = TimeOfDay + 00.50
		Trigger.AfterDelay(DateTime.Seconds(30), function()
			AddHour()
		end)

	else
		TimeOfDay = 23.00 - 23.00
		Trigger.AfterDelay(DateTime.Seconds(30), function()
			AddHour()
		end)
	end
end

Hour0 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 00.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.050)
		Light = (0.450)
	end
end

Hour0h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 00.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.100)
		Light = (0.400)
	end
end


Hour1 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 01.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.150)
		Light = (0.400)
	end
end

Hour1h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 01.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.200)
		Light = (0.400)
	end
end


Hour2 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 02.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.250)
		Light = (0.400)
	end
end

Hour2h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 02.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.300)
		Light = (0.400)
	end
end


Hour3 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 03.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.350)
		Light = (0.400)
--		Lighting.Blue = 1.250
	end
end

Hour3h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 03.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.400)
		Light = (0.350)
	end
end


Hour4 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 04.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.250)
		Light = (0.400)
--		Light = (1.050)
--		Lighting.Blue = 1.500
	end
end

Hour4h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 04.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.500)
		Light = (0.450)
	end
end


Hour5 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 05.00) then
		ColorR = (1.050)
		ColorG = (1.000)
		ColorB = (1.550)
		Light = (0.500)
	end
end

Hour5h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 05.50) then
		ColorR = (1.100)
		ColorG = (1.000)
		ColorB = (1.600)
		Light = (0.550)
	end
end


Hour6 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 06.00) then
		ColorR = (1.150)
		ColorG = (1.000)
		ColorB = (1.550)
		Light = (0.550)
	end
end

Hour6h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 06.50) then
		ColorR = (1.200)
		ColorG = (1.000)
		ColorB = (1.400)
		Light = (0.600)
	end
end


Hour7 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 07.00) then
		ColorR = (1.150)
		ColorG = (1.000)
		ColorB = (1.350)
		Light = (0.650)
	end
end

Hour7h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 07.50) then
		ColorR = (1.100)
		ColorG = (1.000)
		ColorB = (1.200)
		Light = (0.700)
	end
end


Hour8 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 08.00) then
		ColorR = (1.050)
		ColorG = (1.000)
		ColorB = (1.150)
		Light = (0.750)
	end
end

Hour8h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 08.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.100)
		Light = (0.800)
	end
end


Hour9 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 09.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.050)
		Light = (0.850)
	end
end

Hour9h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 09.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (0.900)
	end
end


Hour10 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 10.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (0.950)
	end
end

Hour10h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 10.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.000)
	end
end


Hour11 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 11.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.050)
	end
end

Hour11h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 11.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.100)
	end
end


Hour12 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 12.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.150)
	end
end

Hour12h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 12.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.150)
	end
end


Hour13 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 13.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.200)
	end
end

Hour13h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 13.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.200)
	end
end


Hour14 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 14.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.200)
	end
end

Hour14h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 14.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.200)
	end
end


Hour15 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 15.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.200)
	end
end

Hour15h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 15.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.200)
	end
end


Hour16 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 16.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.150)
	end
end

Hour16h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 16.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.100)
	end
end


Hour17 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 17.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.050)
	end
end

Hour17h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 17.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.000)
	end
end


Hour18 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 18.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (1.000)
	end
end

Hour18h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 18.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (0.950)
	end
end


Hour19 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 19.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (0.900)
	end
end

Hour19h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 19.50) then
		ColorR = (1.050)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (0.850)
	end
end


Hour20 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 20.00) then
		ColorR = (1.100)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (0.800)
	end
end

Hour20h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 20.50) then
		ColorR = (1.150)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (0.750)
	end
end


Hour21 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 21.00) then
		ColorR = (1.200)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (0.700)
	end
end

Hour21h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 21.50) then
		ColorR = (1.150)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (0.650)
	end
end


Hour22 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 22.00) then
		ColorR = (1.100)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (0.600)
	end
end

Hour22h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 22.50) then
		ColorR = (1.050)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (0.550)
	end
end


Hour23 = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 23.00) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (0.500)
	end
end

Hour23h = function()
	Lighting.Ambient = Light
	Lighting.Red = ColorR
	Lighting.Green = ColorG
	Lighting.Blue = ColorB
	if (TimeOfDay == 23.50) then
		ColorR = (1.000)
		ColorG = (1.000)
		ColorB = (1.000)
		Light = (0.500)
	end
end


Repeat = function()
	Trigger.AfterDelay(DateTime.Seconds(1), function()
-- full hours
		Hour0()
		Hour1()
		Hour2()
		Hour3()
		Hour4()
		Hour5()
		Hour6()
		Hour7()
		Hour8()
		Hour9()
		Hour10()
		Hour11()
		Hour12()
		Hour13()
		Hour14()
		Hour15()
		Hour16()
		Hour17()
		Hour18()
		Hour19()
		Hour20()
		Hour21()
		Hour22()
		Hour23()
-- half hours
		Hour0h()
		Hour1h()
		Hour2h()
		Hour3h()
		Hour4h()
		Hour5h()
		Hour6h()
		Hour7h()
		Hour8h()
		Hour9h()
		Hour10h()
		Hour11h()
		Hour12h()
		Hour13h()
		Hour14h()
		Hour15h()
		Hour16h()
		Hour17h()
		Hour18h()
		Hour19h()
		Hour20h()
		Hour21h()
		Hour22h()
		Hour23h()
		Repeat()
	end)
end
