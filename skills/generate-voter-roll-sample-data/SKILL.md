---
name: generate-voter-roll-sample-data
description: >-
  Injects temporary sample voter-roll records into electoral list generation
  (EOD confirmation list / ZEC voter rolls) using the first real DTO as a
  structural template. Use when the user asks for sample voter roll data,
  confirmation voter roll test records, pad electoral list records, or mock
  Location of Residence / voterAddress for PDF display testing.
---

# Generate Voter Roll Sample Data

Temporary **dev-only** injection into list generation so Jasper PDFs/CSVs can be tested with volume and display edge cases. **Remove before commit.**

## When invoked

1. Confirm module (**EOD** vs **ZEC**) and injection point (default below).
2. Confirm **count** (default: `1000` additional records). Ask if unclear.
3. Confirm extras to vary (e.g. Location of Residence, long addresses, last-page count).
4. Inject after the real DTO list is built; keep the `TEMP` comment.
5. Remind the user this must not ship.

## Injection points

| Module | Util | Method | DTO |
|--------|------|--------|-----|
| EOD | `web/eod-module/.../EODElectoralListsUtil.java` | `generateFinalList` | `EODVoterDetailsDto` |
| ZEC | `web/zec-module/.../ZECElectoralListsUtil.java` | after `generateZECVoterDTOList` / list used for the target roll | `ZECVoterDetailsDto` |

Place the block **after** the real list is fetched and the null check, **before** Jasper/file generation.

## Core pattern (required)

```java
// TEMP: sample voter-roll records for display testing — remove before commit
if (!dtoList.isEmpty()) {
  dtoList = new ArrayList<>(dtoList);
  /* DTO */ template = dtoList.get(0);
  // sample* arrays + Random(42)
  int toGenerate = /* count */;
  for (int g = 0; g < toGenerate; g++) {
    /* DTO */ generated = new /* DTO */();
    // copy structural/contextual fields from template
    // set unique personal fields (id, names, etc.)
    dtoList.add(generated);
  }
}
```

Rules:
- Requires **at least one real record** as template (demarcation, image, etc.).
- Use `new ArrayList<>(dtoList)` so the list is mutable.
- Prefer `Random(42)` for repeatable runs.
- Do not invent a parallel search/list path — only pad the existing list.

## EOD field map (`EODVoterDetailsDto`)

**Copy from template:** `districtCode`, `district`, `districtName`, `constituency` (and any other contextual fields already on the template if present).

**Generate uniquely:**
- `id` → `GEN-%06d`
- `surname`, `firstname`, `middlename`
- `occupation`, `regNo` (e.g. `DOM-{districtCodeSansDashes}-%06d`)
- `voterAddress` → **Location of Residence** (see below)

Use Dominica-style name/occupation pools unless the user supplies others.

### Location of Residence (EOD)

Matches `mapEODVoterAddress`: join street and town with `", "`, uppercase:

```text
{STREET AND NUMBER}, {TOWN/VILLAGE}
```

Example: `12 KING GEORGE V ST, ROSEAU`

When the user asks to test Location of Residence display:
- Vary both street and town arrays (do **not** copy only `template.getVoterAddress()`).
- Include a few long streets to exercise wrapping on the PDF.
- Set via `generated.setVoterAddress(street + ", " + town)`.

## ZEC field map (`ZECVoterDetailsDto`)

**Copy from template:** `province`, `constituency`, `localAuthority`, `ward`, `district`, `stationName`, `voterAddress` (unless varying residence), `eligibilityStatus`, `registrationType`, `voterAssignment`, `image`.

**Generate uniquely:** `id`, `publicPersonId`, `surname`, `firstname`, `gender`, `dateOfBirth`, `fatherName`, `motherName`, `placeOfBirth`, `currentStatus`.

Use Zimbabwe-style name/place pools from the user’s snippet when working in ZEC.

For ZEC Location of Residence / address display tests, prefer the real mapped shape from `mapZECVoterAddress`:

```text
{STAND} {STREET_NUMBER} {STREET_NAME} {SUBURB}
```

(uppercase, space-separated) via `setVoterAddress`, rather than leaving it blank.

## Count presets

| Request | `toGenerate` |
|---------|--------------|
| Unspecified | `1000` |
| “Last page / layout” | Exact total the user wants (often replace list with N fixed rows) |
| Stress / volume | User-specified (e.g. `10238`, `100000`) — warn about fill time |

## Fixed short list (optional)

If the user wants a **fixed** small set (e.g. exactly 16 rows, one constituency): clear to a new `ArrayList`, keep template demarcation, fill from a `String[][]` table. Still set `voterAddress` when testing residence display.

## Cleanup

Before any commit/PR: delete the entire `TEMP` block. Do not leave feature flags unless the user explicitly asks for a guarded switch.
