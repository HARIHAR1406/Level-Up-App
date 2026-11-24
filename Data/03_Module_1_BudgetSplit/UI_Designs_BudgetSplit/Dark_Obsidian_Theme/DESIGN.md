---
name: Obsidian Ledger
colors:
  surface: '#10141a'
  surface-dim: '#10141a'
  surface-bright: '#353940'
  surface-container-lowest: '#0a0e14'
  surface-container-low: '#181c22'
  surface-container: '#1c2026'
  surface-container-high: '#262a31'
  surface-container-highest: '#31353c'
  on-surface: '#dfe2eb'
  on-surface-variant: '#c2c6d5'
  inverse-surface: '#dfe2eb'
  inverse-on-surface: '#2d3137'
  outline: '#8c909e'
  outline-variant: '#424753'
  surface-tint: '#acc7ff'
  primary: '#acc7ff'
  on-primary: '#002f68'
  primary-container: '#508ff8'
  on-primary-container: '#00285b'
  inverse-primary: '#005bbf'
  secondary: '#60dda2'
  on-secondary: '#003823'
  secondary-container: '#12a56f'
  on-secondary-container: '#00311e'
  tertiary: '#ffb3b0'
  on-tertiary: '#670211'
  tertiary-container: '#ea6767'
  on-tertiary-container: '#5b000d'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#d7e2ff'
  primary-fixed-dim: '#acc7ff'
  on-primary-fixed: '#001a40'
  on-primary-fixed-variant: '#004492'
  secondary-fixed: '#7efabd'
  secondary-fixed-dim: '#60dda2'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005234'
  tertiary-fixed: '#ffdad8'
  tertiary-fixed-dim: '#ffb3b0'
  on-tertiary-fixed: '#410006'
  on-tertiary-fixed-variant: '#881d24'
  background: '#10141a'
  on-background: '#dfe2eb'
  surface-variant: '#31353c'
typography:
  headline-lg:
    fontFamily: DM Sans
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: DM Sans
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: DM Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0em
  body-lg:
    fontFamily: DM Sans
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
    letterSpacing: 0em
  body-md:
    fontFamily: DM Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
    letterSpacing: 0em
  label-numeric-lg:
    fontFamily: Space Mono
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.03em
  label-numeric-md:
    fontFamily: Space Mono
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 26px
    letterSpacing: -0.02em
  label-numeric-sm:
    fontFamily: Space Mono
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 18px
    letterSpacing: 0em
  label-ui:
    fontFamily: DM Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-micro:
    fontFamily: DM Sans
    fontSize: 10px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.04em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.25rem
  space-xl: 1.75rem
---

## Brand & Style

This design system delivers a tactile, dark-first mobile financial operating environment tailored for progressive web applications (PWAs). The design philosophy sits at the intersection of modern utilitarian minimalism and high-density financial tool design.

The experience evokes computational precision, effortless agency, and fiscal control. Interfaces prioritize maximum information clarity within tight structural constraints, preventing visual fatigue during intensive budgeting and expense-splitting sessions. Ambient noise is eliminated in favor of clean mathematical layouts, high-contrast numeric legibility, and physical surface feedback that mimics tactile high-end consumer hardware.

## Colors

The system uses a strictly orchestrated dark palette engineered for deep screen contrasts and battery preservation in mobile OLED environments.

- **Primary Canvas (`#0D1117`)**: Base canvas underpinning the entire viewport. Never overlaid directly with elevated text; all active elements rest on structural layers.
- **Card Surface (`#161B27`)**: Primary elevation layer for interactive modules, list groups, and overview cards.
- **Input Surface (`#1E2535`)**: Sunken, high-affordance container tint for interactive form elements, text areas, and filter chips.
- **Structural Border (`#2A3148`)**: Subtle 1px boundary layer applied across cards, dividers, bottom sheet rims, and field borders to define separation without stark contrast.
- **Accents**:
  - `Accent Blue (#4F8EF7)`: Used for primary navigation states, active step indicators, and primary action buttons.
  - `Accent Green (#56D49A)`: Reserved exclusively for positive balances, split shares settled, and budget savings surpluses.
  - `Danger Red (#F06B6B)`: Reserved for debts owed, negative deltas, destructive actions, and balance deficits.
- **Typography Hierarchy**:
  - `Primary Text (#E6E9F4)`: High-legibility off-white for headers, values, and direct data points.
  - `Secondary Text (#7E879E)`: Neutral slate for secondary descriptions, metadata, and timestamps.
  - `Tertiary Text (#4A526A)`: Deep slate for inactive placeholders, field borders in passive states, and non-interactive micro-labels.

## Typography

The type system separates computational figures from descriptive copy by utilizing dual typographic engines:

1. **DM Sans** guides user navigation, descriptive context, field inputs, and section labels. Tight tracking on titles balances horizontal compression on mobile displays.
2. **Space Mono** handles all mathematical figures, currency symbols (`₹`), ratios, calculation strings, and percentage outputs. The monospaced rhythm ensures fluctuating digits do not cause layout jank or misaligned decimal points in expense tables.

Numbers must never be rendered in proportional sans-serif when nested within ledgers, split lists, or summary cards. Currency tokens sit inline with numerals without extra spacing (`₹4,850.00`).

## Layout & Spacing

The viewport architecture is locked to a mobile-first paradigm optimized for phone widths (nominal `390px` to max container constraint `430px`). When rendered on tablet or desktop screens, the container remains horizontally centered with a fixed ceiling of `430px`, flanked by the base background canvas (`#0D1117`).

- **Vertical Grid**: Strict 4px vertical baseline unit (`0.25rem`). All paddings and height allocations scale as multiples of 4.
- **Horizontal Boundaries**: Edge gutters are locked to `1rem` (16px) to maximize screen real estate while keeping touch elements within safe thumb reach.
- **Vertical Hierarchy**:
  - Sticky header fixed at `70px` height (incorporating system status bar considerations with CSS `env(safe-area-inset-top)`).
  - Bottom actions anchor above `env(safe-area-inset-bottom)` with a mandatory `0.75rem` floating separation from screen boundaries.
  - Compact vertical stacking keeps critical balances visible above the fold on viewport heights of `844px`.

## Elevation & Depth

Visual hierarchy uses physical-plane nesting, subtle borders, and dark ambient occlusion:

- **Level 0 (Canvas Base)**: `#0D1117`. Flat background with zero elevation.
- **Level 1 (Card Containers)**: `#161B27`. Elevated surface framed by a solid `1px` border of `#2A3148`. Shadows are omitted or limited to ultra-low ambient diffusion: `0 4px 20px rgba(0, 0, 0, 0.4)`.
- **Level 2 (Sunken Fields & Chips)**: `#1E2535`. Recessed into cards or headers with an inner or crisp `1px` border of `#2A3148`.
- **Level 3 (Floating Elements & Toasts)**: `#161B27` or `#1E2535` with higher contrast boundary strokes (`#4F8EF7` or `#2A3148`) elevated by `0 8px 32px rgba(0, 0, 0, 0.65)`.
- **Level 4 (Modals & Bottom Sheets)**: Card surface (`#161B27`) rising from screen bottom, bounded at the top rim by `1px solid #2A3148`, placed over a dark wash overlay (`rgba(5, 7, 10, 0.75)`) using hardware-accelerated `backdrop-filter: blur(8px)`.

## Shapes

The design system employs consistent radii hierarchy across mobile containers:

- **Cards & Primary Modules**: Styled using `1rem` (16px) corner radiuses to establish soft yet structured focal areas.
- **Interactive Controls (Inputs, Form Rows, Standard Buttons)**: Sized with `0.5rem` to `0.75rem` (8px–12px) corners for crisp target delineation.
- **Bottom Sheets**: Asymmetric radius of `22px` on top-left and top-right corners; bottom corners remain flush with screen edges.
- **Chips, Pills, & Toasts**: Fully circular/pill shapes (`9999px`) to visually separate transient and status-oriented components from structural cards.

## Components

### Header Bar
- **Height**: Fixed at `70px` sticky top container, utilizing glass backing (`rgba(13, 17, 23, 0.85)` + `backdrop-filter: blur(12px)`).
- **Branding**: App display name rendered in DM Sans Semi-Bold at `22px` (`#E6E9F4`).
- **Offline Indicator**: Compact pill badge (padding `2px 8px`, border-radius `9999px`) composed of a `6px` circular pulse dot with secondary copy at `10px` (`#7E879E`), mounted right-aligned.

### Buttons & Touch Targets
- **Target Footprint**: Minimum absolute bounding box of `40x40px` (or `44x44px` for primary calls-to-action).
- **Primary CTA**: Solid `#4F8EF7`, text `#0D1117` or `#FFFFFF` (DM Sans Semi-Bold `14px`), radius `12px`, padding `12px 20px`.
- **Ghost / Action Icon Buttons**: `#161B27` surface with `1px solid #2A3148`, icon centered, minimum dimensions `40x40px`.

### Input Fields & Calculation Strips
- **Surface**: `#1E2535` with `1px solid #2A3148`. Focus state illuminates border to `#4F8EF7`.
- **Numeric Fields**: Space Mono font, size `20px` to `24px`. Prefix currency icon fixed in `#7E879E`.
- **Height**: Standard inputs maintain a continuous height of `48px` to ensure effortless mobile tapping.

### Cards & Split Ledgers
- **Container**: `#161B27` background, `1px solid #2A3148`, border-radius `16px`, padding `16px`.
- **Row Elements**: Within cards, line-item rows maintain `48px` vertical spacing with a bottom boundary of `1px solid rgba(42, 49, 72, 0.5)`. Monospaced amounts align strictly right.

### Percentage Allocation Bars
- **Track**: `#1E2535`, height `6px` to `8px`, fully rounded (`9999px`).
- **Fill**: Segmented color tracks using `#4F8EF7`, `#56D49A`, and auxiliary tint channels to visually communicate group expense distributions. Transition durations set to `300ms ease-out`.

### Bottom Sheets
- **Structure**: Slides from bottom, top corners curved to `22px`. Background `#161B27`, topped with a `36x4px` drag handle indicator pill in `#2A3148` centered `8px` below top edge.
- **Overlay**: Backdrop blurred `rgba(5, 7, 10, 0.75)`.

### Toast Notifications
- **Design**: Floating horizontal pill positioned `16px` above the bottom safe area.
- **Dimensions**: Max width `320px`, centered. Background `#1E2535`, border `1px solid #2A3148`.
- **Content**: Left-aligned icon/indicator dot, `12px` typography in `#E6E9F4`, elevation shadow `0 8px 24px rgba(0,0,0,0.5)`.