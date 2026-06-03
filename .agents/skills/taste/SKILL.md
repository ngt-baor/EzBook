---
name: taste
description: Improve frontend visual taste, interaction polish, and production UI quality. Use when Codex is asked to build, redesign, restyle, modernize, or visually improve a website, web app, dashboard, landing page, component, game UI, or local frontend screen; also use for UI reviews focused on layout, typography, color, spacing, responsiveness, visual hierarchy, and avoiding generic AI-looking design.
---

# Taste

## Overview

Use this skill to make UI work feel intentional, coherent, and shippable. Preserve the product's function and existing framework patterns while raising visual hierarchy, spacing, responsiveness, and interaction quality.

## Workflow

1. Read the brief and infer the product category, audience, and daily workflow.
2. Inspect the existing UI, assets, CSS, component library, and design conventions before changing files.
3. Identify the weakest visible issues first: hierarchy, density, alignment, spacing, typography, color balance, responsiveness, empty/loading/error states, and interaction feedback.
4. Make scoped edits that improve the experience without breaking behavior or introducing a new design system unless the user asked for a redesign.
5. Verify in a browser or rendered preview when the app can run locally. Check desktop and mobile widths, console errors, overflow, clipped text, and obvious overlap.

## Design Rules

- Build the real usable screen first, not a marketing placeholder, unless the user explicitly asks for a landing page.
- Match the domain: operational tools should be dense, calm, and scannable; editorial or consumer pages can be more expressive; games can be more playful.
- Prefer restrained, deliberate palettes with clear contrast. Avoid one-note hue themes, default purple-blue gradients, decorative blobs, and generic card-heavy layouts.
- Use typography for hierarchy: clear page title, compact section headings, readable body text, and no viewport-width font scaling.
- Keep cards for repeated items, modals, and framed tools. Do not nest cards inside cards or make every section a floating card.
- Use stable dimensions for boards, toolbars, counters, tiles, icon buttons, and fixed-format widgets so hover states and labels do not shift layout.
- Use icons for common actions when an icon is clearer than text. Add tooltips for unfamiliar icon-only controls.
- Include complete interactive states that users expect: hover, focus, active, disabled, selected, empty, loading, and error where relevant.
- Make text fit its container across mobile and desktop. No clipped labels, overlapped controls, or unreadable tiny text.

## Implementation Guidance

- Follow the repo's existing framework, routing, state, styling, and component patterns.
- Prefer editing the smallest set of files that control the visible experience.
- Reuse existing design tokens, CSS variables, shadcn components, icon libraries, and layout primitives when present.
- Add dependencies only when they clearly fit the project and are necessary for the requested outcome.
- For frontend apps, start the dev server after implementation when practical and give the user the local URL.
- After significant UI changes, inspect the rendered page with the browser and fix visible issues before finalizing.

## Review Checklist

- The first viewport communicates the actual product, tool, place, or task.
- Primary workflows are reachable without explanatory in-app text.
- Layout remains coherent at common desktop and mobile sizes.
- Important controls have clear affordance and feedback.
- Color, spacing, and typography feel consistent rather than assembled from defaults.
- There are no visible console errors, blank canvases, broken assets, or overlapping UI elements.
