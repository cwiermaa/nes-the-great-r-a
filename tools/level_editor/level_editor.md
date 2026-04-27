# Level Editor

This tool is used to construct level layouts for **The Great RA**, using metatile data created with the metatile editor.

---

## Overview

Levels are composed of:

* **13 rows**
* Each row made of **8×2 metatiles**
* Each 8×2 metatile consists of:

  * **four 2×2 metatiles**
  * associated **attribute data**

### Level Size

* Maximum width: **256 columns** (~64 screens)
* Recommended: significantly smaller sizes
* Full-size levels consume ~3.25 KB of data

---

## Modes

The editor operates in three modes. Press **Select** to cycle between them.

| Mode   | Purpose                       |
| ------ | ----------------------------- |
| Mode 0 | Place 8×2 metatiles           |
| Mode 1 | Select current 8×2 metatile   |
| Mode 2 | Edit 8×2 metatile composition |

---

## Cursor Display

The cursor shows multiple layers of information:

```text id="q6x9xp"
ce
00112233
00112233
al

ct
```

* **ce** – Current 8×2 tile selected for placement
* **0–3** – Visual representation of the tile
* **al** – Tile ID currently placed at the cursor position
* **ct** – ID of the 2×2 tile under the cursor

---

## Controls

### Mode 0 — Place Tiles

* Move cursor with **D-Pad**
* Press **A** to place the current 8×2 tile

Note:

* Color index 0 is rendered as transparent

---

### Mode 1 — Select Tile

* **Up / Down** – increment/decrement tile ID
* **Left / Right** – toggle editing mode:

  * `$1x` (high nibble)
  * `$x1` (low nibble)

Wrap behavior:

* In `$1x` mode, `$0F` wraps to `$10`

---

### Mode 2 — Edit Tile Composition

* **Left / Right** – select one of the four 2×2 tiles within the 8×2 tile
* **Up / Down** – change the selected 2×2 tile ID
* Press **A** – cycle attribute values

---

## Data Storage

Level data is written to the `.SAV` file.

### Level Rows

```text id="q3y9em"
Row 0   $6000–$60FF
Row 1   $6100–$61FF
...
Row 11  $6B00–$6BFF
Row 12  $6C00–$6CFF
```

### Palette

```text id="3mr2b2"
$6D00–$6DFF
```

### Metatile Data (Shared)

```text id="8dz7s9"
8×2 tile definitions  $7400–$77FF
8×2 attributes        $7800–$78FF
```

---

## Importing Level Data

Levels are imported using `.incbin`.

Example:

If a level is **80 columns wide**, include:

```asm id="f4l0w1"
.incbin "row0_data", $6000, $50
.incbin "row1_data", $6100, $50
...
```

Repeat for all 13 rows.

---

## Workflow

1. Create and edit metatiles using the **Metatile Editor**
2. Use the Level Editor to place and arrange tiles
3. Extract level data from the `.SAV` file
4. Import data into the project using `.incbin`

Refer to `metatile_editor.md` for details on creating metatile data.

---

## Notes

* Level data is fully driven by SRAM, enabling rapid iteration without recompilation
* Metatile definitions are shared across levels
* Editor is designed for direct manipulation of runtime data structures
