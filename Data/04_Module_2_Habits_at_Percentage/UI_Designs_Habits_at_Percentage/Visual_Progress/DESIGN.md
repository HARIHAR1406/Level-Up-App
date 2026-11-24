---
name: Calibrated Precision
colors:
  surface: '#f9f9ff'
  surface-dim: '#d3daef'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f1f3ff'
  surface-container: '#e9edff'
  surface-container-high: '#e1e8fd'
  surface-container-highest: '#dce2f7'
  on-surface: '#141b2b'
  on-surface-variant: '#464555'
  inverse-surface: '#293040'
  inverse-on-surface: '#edf0ff'
  outline: '#777587'
  outline-variant: '#c7c4d8'
  surface-tint: '#4f44e2'
  primary: '#4d41df'
  on-primary: '#ffffff'
  primary-container: '#675df9'
  on-primary-container: '#fffbff'
  inverse-primary: '#c4c0ff'
  secondary: '#5b5e6a'
  on-secondary: '#ffffff'
  secondary-container: '#dddfee'
  on-secondary-container: '#5f626f'
  tertiary: '#914800'
  on-tertiary: '#ffffff'
  tertiary-container: '#b65c00'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e3dfff'
  primary-fixed-dim: '#c4c0ff'
  on-primary-fixed: '#100069'
  on-primary-fixed-variant: '#3622ca'
  secondary-fixed: '#e0e2f0'
  secondary-fixed-dim: '#c3c6d4'
  on-secondary-fixed: '#181b26'
  on-secondary-fixed-variant: '#434652'
  tertiary-fixed: '#ffdcc6'
  tertiary-fixed-dim: '#ffb785'
  on-tertiary-fixed: '#301400'
  on-tertiary-fixed-variant: '#713700'
  background: '#f9f9ff'
  on-background: '#141b2b'
  surface-variant: '#dce2f7'
typography:
  display:
    fontFamily: DM Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 38px
  headline-lg:
    fontFamily: DM Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 30px
  headline-md:
    fontFamily: DM Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 26px
  headline-sm:
    fontFamily: DM Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
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
  label-md:
    fontFamily: DM Sans
    fontSize: 13px
    fontWeight: '500'
    lineHeight: 18px
  label-sm:
    fontFamily: DM Sans
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
  metric-display:
    fontFamily: JetBrains Mono
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 40px
  metric-lg:
    fontFamily: JetBrains Mono
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 24px
  metric-md:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 18px
  metric-sm:
    fontFamily: JetBrains Mono
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 0.75rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

## Brand & Style

The design system establishes a high-clarity, disciplined productivity environment crafted specifically for progressive web applications (PWA). The brand essence embodies calculated personal progress, self-accountability, and serene focus. The UI avoids gamified clutter, cartoonish illustrations, gratuitous blurs, and loud marketing patterns, positioning itself as a reliable daily instrument of execution.

### Design Movement & Ethos
- **Movement:** Modern Functional Minimalism with High-Information Density.
- **Tone:** Methodical, frictionless, quiet, and deliberate.
- **Principles:**
  - **Data Integrity Over Ornamentation:** Visual hierarchies rely strictly on crisp spatial cadence, typography contrast, and structural boundaries rather than heavy gradients or decorative drop shadows.
  - **Numerical Honesty:** Progress is expressed through precise percentage weights, discrete mathematical fractions, and real-time computation rather than vague badges.
  - **Tactile Ergonomics:** Designed from the bottom up for single-hand mobile interactions, preserving standard safe-area bounds and critical touch zones within thumb reach.

## Colors

The color system operates under a dual-mode surface tier optimized for long-term daily readability. Functional category tags utilize a distinct, immutable chromatic spectrum to support instant subconscious scanning.

### Semantic Core (Light Theme - Default)
- **Canvas Base:** `#F7F8FA`
- **Surface Elevation 1 (Cards):** `#FFFFFF`
- **Surface Elevation 2 (Muted / Segmented Tracks):** `#F0F2F5`
- **Structural Border:** `#E4E7EC`
- **Primary Text:** `#111827`
- **Secondary Text:** `#6B7280`
- **Placeholder & Inactive Text:** `#9CA3AF`
- **Primary Accent:** `#6C63FF`
- **Accent Soft Surface:** `#EEF0FF`
- **Success:** `#22C55E`
- **Danger:** `#EF4444`

### Semantic Core (Dark Theme)
- **Canvas Base:** `#0F1117`
- **Surface Elevation 1 (Cards):** `#1A1D27`
- **Surface Elevation 2 (Muted / Segmented Tracks):** `#242736`
- **Structural Border:** `#2E3245`
- **Primary Text:** `#F3F4F6`
- **Secondary Text:** `#9CA3AF`
- **Placeholder & Inactive Text:** `#6B7280`
- **Primary Accent:** `#7C75FF`
- **Accent Soft Surface:** `#1E1D3A`
- **Success:** `#22C55E`
- **Danger:** `#EF4444`

### Immutable Category Color Matrix
Category indicators strictly apply these hex values for category badges, habit progress pips, and visual chart slices:
1. **Health & Fitness:** `#EF4444`
2. **Study & Learning:** `#3B82F6`
3. **Work & Career:** `#8B5CF6`
4. **Morning Routine:** `#F59E0B`
5. **Evening Routine:** `#F97316`
6. **Meditation:** `#14B8A6`
7. **Nutrition & Diet:** `#22C55E`
8. **Sleep & Rest:** `#6366F1`
9. **Reading & Books:** `#A16207`
10. **Finance:** `#84CC16`
11. **Social & Family:** `#EC4899`
12. **Creativity:** `#F43F5E`
13. **Sports:** `#06B6D4`
14. **Hygiene:** `#64748B`
15. **Hydration:** `#0EA5E9`
16. **Journaling:** `#D97706`
17. **Digital Detox:** `#4ADE80`
18. **Skill Development:** `#A855F7`
19. **Gratitude & Positivity:** `#EAB308`
20. **Weekend Planning:** `#FB7185`

## Typography

The type system creates an intentional dual rhythm:
1. **DM Sans** serves as the primary humanist structural sans-serif for UI labels, titles, standard controls, and contextual guidelines. It brings warmth, readability, and modern restraint.
2. **Monospaced Metric Font** (configured with tabular numeral characteristics) handles strictly mathematical entities: cumulative percentages, habit weights (e.g., `+15%`), count-up counters, active time windows (e.g., `06:00 - 08:30`), and performance delta stats. This prevents visual layout jitter during dynamic state recalculations.

### Strict Application Guidelines
- Never use the monospaced metric font for body copy or standard labels.
- Never use heavy drop-shadows or outlines on text layers.
- Metric display values must include trailing percent signs rendered at identical baseline height with 1px space buffer.

## Layout & Spacing

The layout is engineered around a 4px atomic unit system, tuned specifically for a portrait mobile viewport (baseline target: 390px × 844px), with a strict max-width constraint of 430px centered horizontally on wide-viewport devices or tablets.

### Layout Geometry
- **Outer Canvas Padding:** Consistent `20px` (`1.25rem`) horizontal margins on left and right borders.
- **Top Safe Zone:** Respects system dynamic islands, notch, and status bar with a minimum top padding of `16px` past safe area bounds.
- **Bottom Navigation Surface:** Exactly `64px` in fixed component height, elevated above native device home-indicator safe area (`env(safe-area-inset-bottom)`).
- **Primary Grid:** Single-column modular feed. Inner elements within cards use an 8px grid gap for micro-elements, and 12px or 16px vertical distance between distinct functional modules.

### Responsive Behaviors
- **Mobile (<430px):** Full viewport width with 20px edge margin.
- **Desktop/Tablet (>430px):** Content container pins rigidly to 430px maximum width, centered with a subtle background contrast wrapper to emulate an app frame.

## Elevation & Depth

Visual separation relies on flat, tonal stacking and structural borders rather than blur-based skeuomorphism or deep ambient drop shadows. This preserves high screen efficiency and prevents performance degradation on mobile web engines.

### Depth Tiers
- **Tier 0 (Background Canvas):** Base application ground (`#F7F8FA` Light / `#0F1117` Dark).
- **Tier 1 (Surface Cards & Structural Containers):** Raised interactable layer (`#FFFFFF` Light / `#1A1D27` Dark) paired with a 1px solid structural border (`#E4E7EC` Light / `#2E3245` Dark). Drop shadows are minimal or absent; an ultra-soft ambient shadow (`0 1px 3px rgba(0, 0, 0, 0.04)`) is permitted solely in light mode for physical boundary grounding.
- **Tier 2 (Sticky Headers & Overlays):** Elevated cards, contextual action drawers, and sticky headers apply `1px` crisp border dividers and solid surface backgrounds to eliminate visual bleeding.
- **Tier 3 (Floating Action & Modals):** Bottom sheet dialogs and priority action cards utilize a structured border, crisp 16px corner radius, and a restrained dimming scrim (`rgba(17, 24, 39, 0.4)` Light / `rgba(0, 0, 0, 0.7)` Dark).

## Shapes

The design system uses a strict hierarchy of corner radii to indicate surface containment and input affordance:

- **Cards & Primary Modules:** Fixed `16px` border radius (`rounded-2xl`). This establishes a comfortable, modern silhouette for habit cards, metric summaries, and visual progress groupings.
- **Form Inputs & Text Fields:** Fixed `10px` border radius. Distinct from large container cards, offering a tighter geometric container for direct interaction.
- **Buttons & Control Targets:** Standard action buttons use `10px` radius to match input fields, maintaining visual coherence across form flows.
- **Chips, Category Tags & Progress Pips:** Fully pill-shaped (`9999px`) to immediately convey meta-tagging and toggle status.

## Components

### Habit Item Card
- **Structure:** Surface card (`#FFFFFF` Light / `#1A1D27` Dark), 16px border radius, 1px solid border (`#E4E7EC` Light / `#2E3245` Dark). 16px inner padding.
- **Elements:**
  - **Left Accent Indicator:** 4px wide rounded vertical strip keyed directly to the habit's category color.
  - **Title & Schedule:** Headline-sm in primary text, with active schedule/window in body-sm secondary text directly underneath.
  - **Weight Pill:** Monospace metric-md badge indicating weight (e.g., `25%`) resting in muted surface pill container.
  - **Completion Toggle:** A custom circular touch target (minimum 44px hitbox, 24px visual ring). When completed, transitions cleanly into solid Success (`#22C55E`) fill with white checkmark glyph.

### Percentage Progress Header & Daily Gauge
- **Hero Tracker:** Centralized visual summary displaying cumulative achieved percentage (e.g., `85%`) formatted with display-size metric font.
- **Progress Track:** 8px height horizontal rounded rail (`#F0F2F5` Light / `#242736` Dark). The active fill features a solid Primary Accent or Success indicator, smoothly interpolating width without bouncy elastic transitions.

### Fixed Bottom Navigation Bar
- **Dimensions:** 64px physical bar height + device home indicator padding.
- **Layout:** 3 dedicated tab slots spaced equally across the horizontal plane:
  1. **Action (Checklist):** Daily habit completion and quick checks.
  2. **Create (Plus):** Center or entry point for adding/configuring habits, weights, and timeframes.
  3. **Visual (Chart/Pie):** Percentage distributions, weight calibrations, and completion history.
- **Aesthetic:** Solid surface (`#FFFFFF` Light / `#1A1D27` Dark) with a continuous 1px top border. Inactive icons: secondary text tone (`#6B7280`). Active icon and text: Primary Accent (`#6C63FF` Light / `#7C75FF` Dark).

### Buttons & Interactive Controls
- **Primary Button:** Height 48px, 10px corner radius. Background: Primary Accent, Text: `#FFFFFF` bold label-md. Full width on mobile form views.
- **Secondary / Ghost Button:** Height 48px, 10px corner radius. Background: transparent, 1px border matching structural border color, Text: primary text.
- **Tap States:** Active states scale down subtly (`scale(0.98)`) with zero decorative glow.

### Form Inputs & Weight Sliders
- **Text Inputs:** Height 46px, 10px corner radius, 12px horizontal padding. Border: 1px `#E4E7EC` (focus: `#6C63FF`).
- **Percentage Allocation Slider:** Custom slider thumb (24px circular, elevated) along a segmented bar that enforces habit weights summing to 100%.

### Chips & Category Selectors
- **Badge Format:** 24px height, 8px horizontal padding, pill-shaped. Background uses a 10% opacity tint of the respective category color, with label text rendered in the full-saturation category hue for optimal legibility.