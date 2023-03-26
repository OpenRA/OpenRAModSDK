#region Copyright & License Information
/*
 * Copyright (c) The OpenRA Developers and Contributors
 * This file is part of OpenRA, which is free software. It is made
 * available to you under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of
 * the License, or (at your option) any later version. For more
 * information, see COPYING.
 */
#endregion

using OpenRA.Graphics;
using OpenRA.Mods.Common.Traits;
using OpenRA.Primitives;
using OpenRA.Traits;

namespace OpenRA.Mods.Example.Rendering
{
	[TraitLocation(SystemActors.World | SystemActors.EditorWorld)]
	[Desc("Create a color picker palette from another palette.")]
	public class ColorPickerColorShiftInfo : TraitInfo
	{
		[PaletteReference]
		[FieldLoader.RequireAttribute]
		[Desc("The name of the palette to base off.")]
		public readonly string BasePalette = "";

		[Desc("Hues between this and MaxHue will be shifted.")]
		public readonly float MinHue = 0.83f;

		[Desc("Hues between MinHue and this will be shifted.")]
		public readonly float MaxHue = 0.84f;

		[Desc("Hue reference for the color shift.")]
		public readonly float ReferenceHue = 0.835f;

		[Desc("Saturation reference for the color shift.")]
		public readonly float ReferenceSaturation = 1;

		public override object Create(ActorInitializer init) { return new ColorPickerColorShift(this); }
	}

	public class ColorPickerColorShift : ILoadsPalettes, ITickRender
	{
		readonly ColorPickerColorShiftInfo info;
		readonly ColorPickerManagerInfo colorManager;
		Color color;

		public ColorPickerColorShift(ColorPickerColorShiftInfo info)
		{
			colorManager = Game.ModData.DefaultRules.Actors[SystemActors.World].TraitInfo<ColorPickerManagerInfo>();
			this.info = info;
		}

		void ILoadsPalettes.LoadPalettes(WorldRenderer worldRenderer)
		{
			color = colorManager.Color;
			var (_, hue, saturation, _) = color.ToAhsv();

			worldRenderer.SetPaletteColorShift(
				info.BasePalette,
				hue - info.ReferenceHue,
				saturation - info.ReferenceSaturation,
				info.MinHue,
				info.MaxHue);
		}

		void ITickRender.TickRender(WorldRenderer worldRenderer, Actor self)
		{
			if (color == colorManager.Color)
				return;

			color = colorManager.Color;
			var (_, hue, saturation, _) = color.ToAhsv();

			worldRenderer.SetPaletteColorShift(
				info.BasePalette,
				hue - info.ReferenceHue,
				saturation - info.ReferenceSaturation,
				info.MinHue,
				info.MaxHue);
		}
	}
}
