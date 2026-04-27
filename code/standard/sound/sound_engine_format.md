# NES Sound Engine Format

This document describes the music and sound format used by the engine, including command encoding, channel behavior, and supporting systems such as volume envelopes and noise generation.

---

## Overview

The sound system supports:

* **Music**

  * Square 1
  * Square 2
  * Triangle
  * Noise (drum-like sounds)
* **Sound Effects (SFX)**

Music is encoded in a compact byte-based format, where most notes (pitch + duration) are represented in a single byte.

---

## Note Encoding

For commands `$00–$AF`, the **high nibble** defines note duration and the **low nibble** defines pitch relative to the current reference note.

### Durations

| Range   | Duration       | Ticks |
| ------- | -------------- | ----- |
| $00–$0F | Dotted Whole   | 144   |
| $10–$1F | Whole          | 96    |
| $20–$2F | Dotted Half    | 72    |
| $30–$3F | Half           | 48    |
| $40–$4F | Dotted Quarter | 36    |
| $50–$5F | Quarter        | 24    |
| $60–$6F | Dotted Eighth  | 18    |
| $70–$7F | Eighth         | 12    |
| $80–$8F | Triplet        | 8     |
| $90–$9F | Sixteenth      | 6     |
| $A0–$AF | Thirty-second  | 3     |

### Pitch (Low Nibble)

| Value | Meaning                             |
| ----- | ----------------------------------- |
| $0–$D | Relative note offset from reference |
| $E    | Rest                                |
| $F    | Prolong previous note               |

---

## Reference Note

**Command:** `$B0`
**Argument:** 1 byte (note + octave)

Sets the base note for subsequent relative pitches.

Example:

```asm id="n1"
.db $B0, Music.Bb + Music.O3
```

Notes are defined as:

* `Music.A`, `Music.Bb`, ..., `Music.G`, `Music.Ab`
* Octaves: `Music.O1` through `Music.O7`

---

## Core Commands

### Volume Envelope

**Command:** `$B1`
**Argument:** 1 byte (index into envelope table)

Selects a volume envelope from a lookup table.

---

### Duty Cycle (Square Only)

**Command:** `$B2`
**Argument:** bits 6–7 define duty

| Value | Duty  |
| ----- | ----- |
| $00   | 12.5% |
| $40   | 25%   |
| $80   | 50%   |
| $C0   | 75%   |

---

### Tempo

**Command:** `$B3`
**Argument:** 8-bit value

Tempo accumulates each frame; overflow produces a **tick**.
Higher values = faster tempo.

---

### Jump / Relocation

**Command:** `$B4`
**Argument:** 16-bit address

Changes the current music read position.

---

### Octave Shifts

| Command | Effect             |
| ------- | ------------------ |
| $B5–$B8 | Down 4 → 1 octaves |
| $B9–$BC | Up 1 → 4 octaves   |

---

### Unique Code Hook

**Command:** `$BD`
**Argument:** 16-bit address

Executes custom code every tick for the channel.
Runs after normal music processing and can override channel output.

---

### Triangle Channel Control

Triangle has no volume control, so timing is used instead.

#### Shorten Note

**Command:** `$BE`
**Argument:** ticks to subtract from note length

#### Fixed Duration (Staccato)

**Command:** `$BF`
**Argument:** exact audible ticks

---

### Looping

| Command | Description  |
| ------- | ------------ |
| $C0     | Loop level 1 |
| $C1     | Loop level 2 |
| $C2     | Loop level 3 |

Each loop takes a repeat count and allows nested looping.

---

### Exact Note + Duration

**Command:** `$C3`
**Arguments:** note index, tick count

Allows precise pitch and duration control outside normal encoding.

---

## Volume Envelopes

Defined as:

```asm id="n2"
.db LoopOffset, Volume1, Volume2, ..., $10
```

* Entries are **4-bit values**
* `$10` = loop marker
* `LoopOffset` determines loop start position

Notes:

* Envelopes always loop
* Max length: 256 bytes
* Stored in a lookup table referenced by `$B1`

---

## Noise Channel

Noise behaves differently from tonal channels:

* Notes act as **indices into a sample table**
* Each entry points to a **code routine**, not raw data
* These routines write directly to sound registers

This allows procedural drum and noise generation.

---

## Sound Effects (SFX)

* Use the same format as music
* Have **higher priority**
* Override music channels when active

### Priority Order

1. Square / Triangle (music)
2. Noise (drums)
3. Sound Effects (highest)

---

## Special Notes

### Triangle Prolong Behavior

Prolong (`$F`) must appear **before** the note for triangle.

---

### Timing Limitations

* Notes cannot be prolonged beyond 256 ticks
* Use `$C3` for precise long durations

---

## Sound Effect Priority Behavior

Two possible models:

* **First-come priority**
  First SFX occupies the channel until completion

* **Player-priority (preferred)**
  Player-triggered SFX override all others

---

## Engine Updates

### Volume Envelope Change

`$B1` now uses an **8-bit index** instead of a direct address.

A lookup table stores envelope addresses:

```asm id="n3"
Sound.Songs.VolumeEnvelopes:
  .dw Envelope1, Envelope2, ...
```

---

## Summary

This format is designed to:

* Minimize storage (1-byte note encoding)
* Support expressive playback (envelopes, loops, tempo)
* Allow procedural sound (noise channel + code hooks)
* Balance flexibility with performance constraints
