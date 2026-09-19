# Sangil outdoor redesign

## Baseline and architecture

The original app had seven Swift files: app entry, Home-only root, four static mountains, a model, card and detail views. Favorites were ephemeral detail state; images had no fallback. iOS deployment target remains 26.2. Existing catalog content, asset names, app entry and synchronized Xcode source group are preserved. No dependencies were added.

The root now owns an Observation-based AdventureStore and injects it into four independent NavigationStacks. Views are organized by feature, with theme and reusable components separated. UserDefaults stores favorites by stable asset ID, personal hike records, an active session, profile name, monthly goal and the demo toggle. Derived totals, challenges and badges share the same record source.

## Screens

- Home: photographic hero, departure reminder, horizontal recommendations, difficulty and regional navigation, editorial popularity list, goal, challenges, recent records and route recommendation.
- Explore: name/region/course search, composable region/difficulty/elevation filters, editorial recommendation/popularity sorting, empty-state reset, shared favorites.
- Detail: image or procedural mountain artwork, route metrics, introduction, features, season, tips and pinned start/resume action.
- Activity: cumulative statistics, month goal, locale-aware monthly calendar, records, visited mountains, challenges and resume session.
- Profile: editable name, derived level and badges, favorite/completed collections, goals, challenges and settings.
- Hiking: persisted start timestamp, elapsed timer, manual distance/ascent entry, completion and confirmed cancellation. No GPS tracking is represented as implemented.

## Design

AppColors centralizes near-black, charcoal surfaces, lime, yellow, cyan and text colors. AppTypography provides display, title, number and eyebrow roles. Flat panels, ranked rows, modest corner radii, large photography and typographic contrast avoid a uniform card stack. SF Symbols, native navigation and native tab behavior are retained. Dark appearance is intentional.

MountainArtwork uses an existing asset first, optional AsyncImage second, then layered Canvas mountain silhouettes and a gradient. Remote failures retain the fallback.

## Demo and data limitations

Three example records are enabled by default and explicitly identified on Home, Activity and Profile. Settings can remove them from all aggregates without touching personal data. Route distances, elevation gains, difficulty, duration, season and recommendation/popularity order are illustrative static content, not live trail intelligence. Weather is a preparation reminder, not a fabricated reading. Challenges cover mountains actually present in the catalog. A completed record does not constitute verified summit certification.

## Images

Existing: bukhansan, gwanaksan, hallasan. seoraksan currently has an empty image set; add a photo. Add jirisaan and dobongsan image sets. The spelling jirisaan intentionally matches the requested key. Use properly licensed, high-resolution landscape photography. AppIcon is still empty and needs a production icon before distribution.

## Validation

- Debug iOS Simulator build via Xcode 26.3 / iOS 26.2 SDK, signing disabled.
- Debug macOS build also passes, signing disabled. Navigation-bar styling/title visibility and decimal-keyboard modifiers are conditionally applied on iOS/visionOS; macOS retains native navigation and keyboard behavior.
- Launched on iPhone 17 Pro simulator (iOS 26.3); Home screenshot inspected.
- Tests/AdventureStoreChecks.swift verifies unique mountain IDs, stable demo identities, favorite persistence, settings, active-session restoration, completion, duplicate-completion prevention, aggregates, persistence and demo isolation.
- The standalone check is outside the synchronized app source group; compile it with Mountain.swift, MountainData.swift and AdventureStore.swift using the macOS SDK, then run the resulting executable. It uses an isolated temporary UserDefaults suite and removes it on exit.
- No full automated UI traversal, physical-device, accessibility audit, Release archive or App Store distribution validation has been performed.

## Next production steps

Verified course/closure/reservation data; location permission and GPS recording with background recovery; account sync and data export/deletion; live weather; verified summit challenges; production imagery and icon; Korean/English localization; comprehensive VoiceOver/Dynamic Type and device testing; privacy disclosures and distribution configuration.


## Real catalog update (2026-09-19)

The app now bundles 50 mountains selected from the Korea Forest Service 100-mountain list, with official decimal elevations, locations and individual source links. This supersedes the initial six-mountain illustrative catalog described above. Original six IDs remain stable for stored favorites and records.

Each mountain has its own locally bundled photograph and author/license/source information in the detail view. Some images show associated park scenery, temples, trails or aerial terrain rather than a summit; captions identify these subjects. All 50 images were inspected together. See PHOTO_CREDITS.md and CatalogSources/catalog.json for the exact sources and asset checksums. Previously used photos are preserved in LegacyAssets and are no longer bundled.

Route distance, ascent, duration and difficulty are not established by the list source, so illustrative route values are removed. Unknown values stay nil, with explicit UI text and an official information link. Demo personal activity remains independently marked and switchable. Altitude filters and real elevation/name sorting replace the previous unsourced difficulty quick chips and popularity ordering; the difficulty filter remains available for future verified course data.

`python3 Scripts/import_mountains.py` validates the checked-in manifest/assets and regenerates MountainData.swift and PHOTO_CREDITS.md. Use `--download` only to restore missing assets; changed downloaded bytes require a source review before updating the stored checksum. The importer never substitutes random imagery or creates synthetic photos.
