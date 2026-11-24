---
name: Level Up Mainframe
colors:
  surface: '#0a1325'
  surface-dim: '#0a1325'
  surface-bright: '#30394d'
  surface-container-lowest: '#050e20'
  surface-container-low: '#121b2e'
  surface-container: '#161f32'
  surface-container-high: '#212a3d'
  surface-container-highest: '#2c3548'
  on-surface: '#d9e2fc'
  on-surface-variant: '#c2c6d5'
  inverse-surface: '#d9e2fc'
  inverse-on-surface: '#273044'
  outline: '#8c909e'
  outline-variant: '#424753'
  surface-tint: '#acc7ff'
  primary: '#acc7ff'
  on-primary: '#002f68'
  primary-container: '#508ff8'
  on-primary-container: '#00285b'
  inverse-primary: '#005bbf'
  secondary: '#c4c0ff'
  on-secondary: '#2000a4'
  secondary-container: '#3926cc'
  on-secondary-container: '#b4b0ff'
  tertiary: '#60dda2'
  on-tertiary: '#003823'
  tertiary-container: '#12a56f'
  on-tertiary-container: '#00311e'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#d7e2ff'
  primary-fixed-dim: '#acc7ff'
  on-primary-fixed: '#001a40'
  on-primary-fixed-variant: '#004492'
  secondary-fixed: '#e3dfff'
  secondary-fixed-dim: '#c4c0ff'
  on-secondary-fixed: '#110068'
  on-secondary-fixed-variant: '#3722ca'
  tertiary-fixed: '#7efabd'
  tertiary-fixed-dim: '#60dda2'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005234'
  background: '#0a1325'
  on-background: '#d9e2fc'
  surface-variant: '#2c3548'
typography:
  headline-xl:
    fontFamily: DM Sans
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.03em
  headline-xl-mobile:
    fontFamily: DM Sans
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 38px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: DM Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: DM Sans
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.015em
  title-sm:
    fontFamily: DM Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: DM Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: DM Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: DM Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  code-badge:
    fontFamily: JetBrains Mono
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.05em
  label-mono:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system establishes a high-performance, modular switchboard aesthetic for personal command centers and operational hubs. Built around the ethos of precision, quiet utility, and direct tactile feedback, the design language merges modern brutalist clarity with refined dark-console minimalism.

Targeted at power users, builders, and self-optimizers managing finances, routines, and tooling in high density, the interface evokes focus, deterministic feedback, and effortless structural command. Key identity accents (BudgetSplit Blue/Green, Habits Indigo) punch through an architectural, low-noise chassis to provide immediate app-domain context without visual fatigue.

## Colors

The palette relies on deep console backdrops punctuated by luminous signal accents. Every accent communicates domain specificity or system feedback rather than decoration.

### Dark Mode (Default)
- **Base Canvas:** `#0D1117`
- **Surface / Panels:** `#161B27`
- **Border / Structural Lines:** `#2A3148`
- **Text Primary:** `#E6E9F4`
- **Text Muted:** `#7E879E`

### Light Mode
- **Base Canvas:** `#F2F4FB`
- **Surface / Panels:** `#FFFFFF`
- **Secondary Surface:** `#E9EDFF`
- **Border / Structural Lines:** `#C7C4D8`
- **Text Primary:** `#141B2B`
- **Text Muted:** `#5B5E6A`

### Domain & System Accents
- **BudgetSplit Primary:** `#4F8EF7` (Light: `#0059BA`)
- **BudgetSplit Inflow / Success:** `#56D49A` (Light: `#006C47`)
- **Habits Engine:** `#675DF9` (Light: `#4D41DF`)
- **Alert / Destructive:** `#F06B6B` (Light: `#D93838`)

## Typography

The type system pairs **DM Sans** for primary human-scale communication and interface scaffolding with **JetBrains Mono** for status flags, data streams, and hardware-inspired switchboard badges.

Headings leverage tight negative letter-spacing for athletic density. Data badges and status indicators run uppercase monospaced text to emphasize automated telemetry, operational states, and system integrity.

## Layout & Spacing

The spatial architecture operates on a rigorous 4px baseline increment (multiples of `0.25rem`). 

- **Grid Architecture:** 12-column fluid grid system on desktop (`min-width: 1024px`) with 16px (`1rem`) gutters and 24px (`1.5rem`) margins. Tablet views (`768px - 1023px`) shift to 6 columns. Mobile layouts run a single or 2-column dock.
- **Mainframe Switchboard Panels:** Primary interactive switchboards enforce an outer wrapper padding of `1.75rem` (28px) to visually reinforce their encapsulated console behavior.
- **Horizontal & Vertical Gaps:** Standard operational clusters align using `space-xs` (4px) to `space-sm` (8px). Major data cards and operational zones divide along `space-lg` (24px) intervals.

## Elevation & Depth

This design system avoids traditional hazy dropshadows. Depth is derived from distinct background tonal containment, hair-line boundary borders, and active photon glows.

1. **Base-to-Surface Tiering:** The background sits on `#0D1117`. Primary modular switchboards rest on `#161B27`, circumscribed with a single 1px stroke of `#2A3148`.
2. **Layered Insets:** Input fields, telemetry trays, and secondary module cavities use negative depth—filling with `#0D1117` and a 1px border.
3. **Module Glows:** Active indicators and circular launch modules omit drop shadows in favor of focused, colored radial halos:
   - *Budget Blue Module Glow:* `0 0 24px -4px rgba(79, 142, 247, 0.45)`
   - *Habits Indigo Module Glow:* `0 0 24px -4px rgba(103, 93, 249, 0.45)`
   - *System Green Glow:* `0 0 20px -4px rgba(86, 212, 154, 0.4)`

## Shapes

The design system incorporates geometric hierarchy to contrast modular instruments against macro containers:

- **Switchboard Containers:** Bound with an exact **28px (`1.75rem`)** outer radius, creating smooth structural encapsulation for primary application docks.
- **Circular Module Buttons:** Perfect circles (`border-radius: 9999px`) used strictly for primary tool launchers, status toggles, and module accelerators.
- **Cards, Panels & Data Wells:** Follow the core token level `rounded-lg` (16px) or `rounded` (8px) for standard UI cards, keeping interior corners cohesive against the 28px macro frame.
- **Status Pills:** Fully rounded (`rounded-full`) pill format for micro mono labels.

## Components

### Circular Module Buttons
Primary interaction triggers within the switchboard. Circular dimensions (48px, 56px, 64px), filled with `#161B27` and bordered by `#2A3148` at rest. On hover and active states, the border takes on the feature accent color accompanied by its matching module glow (`0 0 24px -4px var(--accent-alpha)`).

### Switchboard Shell
Large-format hub containers featuring a `28px` corner radius, `#161B27` fill, 1px `#2A3148` boundary, and internal structural grouping bays. Switchboards house module launcher grids and real-time state telemetry.

### Status Badges & Chips
Monospaced micro-chips utilizing `JetBrains Mono` at `11px`. Bounded by `rounded-full`, 1px borders, and low-opacity contextual tints:
- *Budget Inflow:* Border `#56D49A`, Background `rgba(86, 212, 154, 0.1)`, Text `#56D49A`
- *Habit Streak:* Border `#675DF9`, Background `rgba(103, 93, 249, 0.12)`, Text `#E6E9F4`
- *Fault / Error:* Border `#F06B6B`, Background `rgba(240, 107, 107, 0.12)`, Text `#F06B6B`

### Input Fields & Controls
Inputs use deep inset styling: background `#0D1117`, border 1px `#2A3148`, border-radius `8px`, typography `14px DM Sans`. On focus, the border shifts crisply to `#4F8EF7` without offset rings. Checkboxes and radio switches use 2px rounded corners and circular geometries respectively, activating with crisp accent fills and white glyphs.

### Telemetry Lists & Module Cards
Cards maintain `#161B27` surfaces, crisp divider lines (`1px solid #2A3148`), and strict 4px grid paddings. Row elements provide subtle background highlights to `#1C2333` on pointer hover.