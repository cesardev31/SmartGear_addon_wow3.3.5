# SmartGear (WoW WotLK 3.3.5a)

An all-in-one, ultra-lightweight Gear Analyzer and Character Panel enhancer for World of Warcraft: Wrath of the Lich King (Patch 3.3.5a).

![SmartGear Preview](https://via.placeholder.com/800x400.png?text=SmartGear+Preview)

## Features

- **"All-In-One" Character Panel Overlays:**
  View essential gear info directly on your equipped items in the Character window (`C`):
  - **Quality Borders:** Colored glowing borders that match item rarity (Uncommon/Rare/Epic/Legendary).
  - **Item Level (iLvl):** See the exact item level on the top-right of the slot.
  - **Real-time Durability:** See the current durability percentage beneath the item icon. Turns red if it drops below 30%.
  - **Warning Indicators:** A red notification dot appears if an item is missing a gem or an enchant.

- **Intelligent Tooltip Comparisons:**
  Hover over any piece of gear to see an instant upgrade/downgrade calculation:
  - Detects your active talent specialization automatically.
  - Calculates a unique `SmartGear Score` based on custom stat-weights tailored for all 10 classes and their 3 talent trees.
  - Displays a clean `▲ Upgrade +15` or `▼ Downgrade -11` relative to what you currently have equipped.
  - Smart logic for Rings and Trinkets (always compares against the weakest of the two equipped items).

- **Full Localization (English & Spanish):**
  Automatically detects if you are playing on an `esES`/`esMX` or `enUS`/`enGB` client and translates all UI elements, tooltips, warnings, and socket-scanning logic accordingly without any setup required.

- **Ultra Lightweight:**
  Built exactly for 3.3.5a with zero external library dependencies (No Ace3). The entire addon is under 40 KB in size and lazy-loads purely on hover and equipment changes, ensuring 0% impact on your framerate.

## Installation

1. Download the latest release or clone this repository.
2. Extract the folder and ensure it is named exactly `SmartGear`.
3. Move the `SmartGear` folder into your WoW installation path:  
   `World of Warcraft 3.3.5a\Interface\AddOns\SmartGear`
4. Launch the game, click the "AddOns" button on the character select screen, and ensure `SmartGear` is checked.

## Slash Commands

You can use `/sg` or `/smartgear` in the chat frame:

- `/sg scan` - Forces a manual rescan of your talents and equipped gear.
- `/sg spec` - Prints your currently detected talent tree.
- `/sg warnings` - Prints a summary of all your currently equipped items that are missing gems or enchants.

## Customizing Stat Weights

You can easily adjust the stat weights used for scoring items. Open `talents.lua` in any text editor and edit the numbers inside the `SmartGear.STAT_WEIGHTS` tables to match your exact best-in-slot theorycrafting priorities.

## License

This project is open-source and free to use.

## Author

Created by Cesar.
