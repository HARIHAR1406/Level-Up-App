---
name: Clear Balance
colors:
  surface: '#faf8ff'
  surface-dim: '#d5d9eb'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#e9edff'
  surface-container-high: '#e3e7fa'
  surface-container-highest: '#dee2f4'
  on-surface: '#161b28'
  on-surface-variant: '#424753'
  inverse-surface: '#2b303e'
  inverse-on-surface: '#eef0ff'
  outline: '#727784'
  outline-variant: '#c2c6d5'
  surface-tint: '#005bbf'
  primary: '#0059ba'
  on-primary: '#ffffff'
  primary-container: '#2c72d9'
  on-primary-container: '#fefcff'
  inverse-primary: '#acc7ff'
  secondary: '#006c47'
  on-secondary: '#ffffff'
  secondary-container: '#7bf7ba'
  on-secondary-container: '#00714a'
  tertiary: '#a53337'
  on-tertiary: '#ffffff'
  tertiary-container: '#c64b4d'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
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
  background: '#faf8ff'
  on-background: '#161b28'
  surface-variant: '#dee2f4'
typography:
  display:
    fontFamily: DM Sans
    fontSize: 3rem
    fontWeight: '700'
    lineHeight: 3.5rem
    letterSpacing: -0.02em
  display-mobile:
    fontFamily: DM Sans
    fontSize: 2.25rem
    fontWeight: '700'
    lineHeight: 2.75rem
    letterSpacing: -0.015em
  headline-lg:
    fontFamily: DM Sans
    fontSize: 2rem
    fontWeight: '700'
    lineHeight: 2.5rem
    letterSpacing: -0.015em
  headline-lg-mobile:
    fontFamily: DM Sans
    fontSize: 1.5rem
    fontWeight: '700'
    lineHeight: 2rem
    letterSpacing: -0.01em
  headline-md:
    fontFamily: DM Sans
    fontSize: 1.25rem
    fontWeight: '600'
    lineHeight: 1.75rem
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: DM Sans
    fontSize: 1.125rem
    fontWeight: '600'
    lineHeight: 1.5rem
  body-lg:
    fontFamily: DM Sans
    fontSize: 1.125rem
    fontWeight: '400'
    lineHeight: 1.75rem
  body-md:
    fontFamily: DM Sans
    fontSize: 0.9375rem
    fontWeight: '400'
    lineHeight: 1.5rem
  body-sm:
    fontFamily: DM Sans
    fontSize: 0.8125rem
    fontWeight: '400'
    lineHeight: 1.25rem
  label-md:
    fontFamily: DM Sans
    fontSize: 0.875rem
    fontWeight: '500'
    lineHeight: 1.25rem
  label-sm:
    fontFamily: DM Sans
    fontSize: 0.75rem
    fontWeight: '600'
    lineHeight: 1rem
    letterSpacing: 0.025em
  amount-display:
    fontFamily: JetBrains Mono
    fontSize: 2.5rem
    fontWeight: '600'
    lineHeight: 3rem
    letterSpacing: -0.03em
  amount-display-mobile:
    fontFamily: JetBrains Mono
    fontSize: 1.875rem
    fontWeight: '600'
    lineHeight: 2.25rem
    letterSpacing: -0.02em
  amount-lg:
    fontFamily: JetBrains Mono
    fontSize: 1.25rem
    fontWeight: '500'
    lineHeight: 1.75rem
    letterSpacing: -0.02em
  amount-md:
    fontFamily: JetBrains Mono
    fontSize: 0.9375rem
    fontWeight: '500'
    lineHeight: 1.5rem
    letterSpacing: -0.01em
  amount-sm:
    fontFamily: JetBrains Mono
    fontSize: 0.8125rem
    fontWeight: '500'
    lineHeight: 1.125rem
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-desktop: 1.5rem
  margin: 1rem
  margin-tablet: 2rem
  margin-desktop: 3rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.25rem
  space-2xl: 3rem
---

## Brand & Style
The design system balances financial discipline with interpersonal ease. Designed for collaborative expense tracking, bill splitting, and group budgeting, the visual tone avoids both cold institutional finance and overly playful gamification. It prioritizes clarity, transparency, and cognitive ease, instilling confidence in calculations while keeping social financial dynamics stress-free.

The design movement combines Modern Financial Utility with Soft Tactility: clean white elevation surfaces layered over an airy, cool-tinted canvas (#F2F4FB), structured borders (#E2E8F0), and focused energetic accents for transaction clarity. Spatial balance, clear numerical isolation, and legible typography create a tranquil, trustworthy workspace.

## Colors
The palette relies on deliberate role separation between structural neutral values and semantic status accents:

- **Canvas Background (`#F2F4FB`):** A soft, cool periwinkle-tinted neutral providing contrast against pure white cards without harshness.
- **Card & Modal Surface (`#FFFFFF`):** Crisp pure white used for primary content panels, modals, and raised containers.
- **Input Background (`#F8FAFC`):** Subtle cool off-white inset to indicate editable fields.
- **Primary Text (`#1A1F2C`):** High-contrast, slate-tinted black for primary headers, balances, and critical values.
- **Secondary Text (`#6B7280`):** Muted cool gray for subheadings, timestamps, secondary labels, and metadata.
- **Primary Accent (`#4F8EF7`):** Focused azure blue representing primary actions, interactive controls, and links.
- **Secondary Accent (`#56D49A`):** Fresh mint green reserved for positive cash flow, settled balances, and successful splits.
- **Tertiary / Danger (`#F06B6B`):** Soft coral red reserved for debts owed, negative balances, removal actions, and errors.
- **Structural Border (`#E2E8F0`):** Crisp, subtle boundary divider ensuring containment across surfaces.

## Typography
The system employs a dual-typeface structure to distinguish descriptive context from numeric data:

- **DM Sans:** Carries all human communication—page headings, labels, button directives, descriptions, and user notes. Its geometric clarity creates an open, welcoming interface.
- **JetBrains Mono:** Dedicated strictly to numerical balance displays, currency inputs, split breakdowns, and transaction metrics. The monospaced cadence prevents layout jank during dynamic updates and ensures vertical decimal alignment in expense tables.

Maintain strict letter-spacing rules: titles and high-value currency displays require slight negative tracking to feel cohesive, while sub-labels under 14px use relaxed letter-spacing for glanceable readability.

## Layout & Spacing
The layout follows an 8pt spatial grid built around a structured, fluid container system:

- **Desktop (1024px+):** Max-width canvas of 1280px, utilizing a 12-column fluid grid with 24px gutters and 48px outer margins. Split sidebars (group navigation, balances) occupy 4 columns, while feed and ledger activities span 8 columns.
- **Tablet (768px - 1023px):** 8-column layout with 24px gutters and 32px outer margins. Two-column breakdowns compress smoothly into single primary panels with collapsible secondary data drawers.
- **Mobile (< 768px):** 4-column layout with 16px gutters and 16px edge margins. Multi-column financial tables collapse into individual card-based transaction summaries.

Use `space-sm` (8px) for tightly grouped badge icons and counter labels; `space-md` (16px) for standard component padding and list row separation; and `space-xl` (36px) or `space-2xl` (48px) to demarcate major section divides.

## Elevation & Depth
Elevation in this system uses ambient light and structural boundaries rather than dense shadows:

- **Layer 0 (Canvas):** Flat base surface set at `#F2F4FB`.
- **Layer 1 (Card & Content Blocks):** `#FFFFFF` surfaces enclosed by a 1px solid border of `#E2E8F0` and an ambient shadow of `0 1px 3px rgba(26, 31, 44, 0.04), 0 1px 2px rgba(26, 31, 44, 0.02)`.
- **Layer 2 (Hovered Cards & Dropdowns):** Elevated `#FFFFFF` surfaces with a 1px border of `#E2E8F0` and shadow `0 6px 16px -2px rgba(26, 31, 44, 0.06), 0 2px 6px -1px rgba(26, 31, 44, 0.03)`.
- **Layer 3 (Modals & Slide-overs):** Anchored modal overlays featuring a 1px border of `#E2E8F0` and a diffused shadow of `0 20px 32px -8px rgba(26, 31, 44, 0.12), 0 8px 16px -4px rgba(26, 31, 44, 0.04)`. The backing backdrop filter applies `rgba(26, 31, 44, 0.35)` with an 8px blur.

Shadows are never saturated with pure black; they are lightly tinted with primary slate (`#1A1F2C`) to maintain cohesive color temperature throughout the light environment.

## Shapes
The design adopts roundedness tier 2 (8px base radius), producing a modern and friendly contour that remains compact and structured for financial density:

- **Base Radius (`rounded-md` / 8px):** Applied to buttons, input fields, pill checkboxes, and list items.
- **Large Radius (`rounded-lg` / 16px):** Applied to surface cards, ledger panels, and category summary widgets.
- **Extra-Large Radius (`rounded-xl` / 24px):** Reserved for slide-out sheets, modal dialogues, and desktop layout containers.
- **Fully Rounded (`rounded-full`):** Applied strictly to user avatars, quick-filter badges, active transaction category pills, and numeric notification badges.

## Components

### Buttons
- **Primary:** Filled `#4F8EF7` with white text, font weight 600. Height 42px (mobile 46px), 8px corner radius. On hover: darkened to `#3B7BE8`. On active: subtle scale down (0.99).
- **Secondary / Subtle:** Background `#FFFFFF`, 1px border of `#E2E8F0`, text `#1A1F2C`. On hover: background `#F8FAFC`, border `#CBD5E1`.
- **Destructive:** Background `#F06B6B` with white text for critical confirmations, or soft-state background `rgba(240, 107, 107, 0.12)` with `#F06B6B` text for low-priority deletions.

### Input Fields & Amount Selectors
- **Standard Text Fields:** Background `#F8FAFC`, border 1px solid `#E2E8F0`, text `#1A1F2C`, placeholder `#6B7280`. Focused state switches background to `#FFFFFF`, border to `#4F8EF7`, with an ambient ring `0 0 0 3px rgba(79, 142, 247, 0.18)`.
- **Monetary Amount Inputs:** Left-aligned currency sign in `#6B7280`. Input text in monospaced font at `amount-display` or `amount-lg` scale. Background `#F8FAFC` inside a 16px rounded card wrapper.

### Cards & Ledger Containers
- **Card Styling:** `#FFFFFF` background, 1px solid `#E2E8F0`, 16px corner radius, padding `space-lg` (24px).
- **Balance Card:** Features subtle vertical accent ribbons (3px wide) on the left border: `#56D49A` for positive balance (you are owed) and `#F06B6B` for negative balance (you owe).

### Lists & Transactions
- **Rows:** Divided by a 1px border of `#E2E8F0`. Padding `space-md` top and bottom.
- **Split Breakdown Row:** User avatar (36px, circular), participant name in `body-md` bold, ratio/split shares in `body-sm` (`#6B7280`), and individual amount aligned right in monospaced font.

### Chips & Filter Tags
- Height 32px, `rounded-full`, 1px solid `#E2E8F0`, background `#FFFFFF`, text `#6B7280`.
- **Active State:** Background `#4F8EF7`, text `#FFFFFF`, border transparent.
- **Status Badges (Settled / Pending):** 
  - Settled: Background `rgba(86, 212, 154, 0.15)`, text `#2B8F60`.
  - Owed: Background `rgba(240, 107, 107, 0.15)`, text `#C53B3B`.

### Checkboxes & Toggle Splits
- 20x20px, 6px radius, border 1.5px solid `#E2E8F0`. Checked state fills `#4F8EF7` with white checkmark.
- **Segmented Equal/Unequal Split Switch:** Inset container in `#F8FAFC` with 8px radius; active segment animates with a `#FFFFFF` raised pill card and subtle shadow.