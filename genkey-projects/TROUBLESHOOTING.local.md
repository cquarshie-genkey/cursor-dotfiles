# Local troubleshooting log

Living notes for local/runtime issues that are easy to misread as code bugs. Shared across all GenKey projects on this machine. Add a new entry at the top when something is diagnosed and fixed.

This file is machine-local and excluded from git.

## How to add an entry

Copy the template below. Keep the **symptom** as the heading so the next person can search the log file or error text. Tag the **Project** so entries stay findable across repos.

```markdown
## YYYY-MM-DD — short symptom

**Project:** eod-module / carp-module / spire-consoles / …
**Symptom:** what you saw (paste the key exception line).
**Root cause:** what was actually wrong.
**Fix:** what resolved it (paths, config, commands).
**Not the cause:** lookalikes we ruled out.
```

---

## 2026-09-04 — Application startup failed: `baseSPiRESessionManagement` NPE

**Project:** eod-module
**Symptom:** Tomcat/Spring deploy dies with:

```
Error creating bean with name 'webMVCConfig'
  → Could not autowire field: RequestInterceptor
    → Error creating bean with name 'requestInterceptor'
      → Could not autowire field: BaseSPiRESessionManagement
        → Error creating bean with name 'baseSPiRESessionManagement': Invocation of init method failed
          → java.lang.NullPointerException
```

**Root cause:** `@PostConstruct` on `BaseSPiRESessionManagement` calls `PopulateSecTables.start()`, which always does `roleSetupHelper.get("SYSTEM_ADMINISTRATION").add("*")`. That map is built only from `tenant.roles`. Live EOD config was missing `spireUI\props\spire-application.properties`, so `tenant.roles` fell back to the code default `HOUSEHOLD_MANAGEMENT`. `get("SYSTEM_ADMINISTRATION")` was null.

**Fix:** Restore `spireUI\props` (at least `spire-application.properties`) under `c:\genkey_internal\3\ext\EOD\` from `c:\genkey_internal\3\ext\EOD-current-valid\spireUI\props\`. The valid file includes `tenant.roles=SYSTEM_ADMINISTRATION,...`. Redeploy after the copy.

**Not the cause:** `WebMVCConfig` / `RequestInterceptor` wiring, Hibernate `schema "spire_mmg" does not exist` noise, or a Java change in the EOD module.

**Code:** `web/base-modules/spire-base-module/src/main/java/com/genkey/spireui/base/app/sec/PopulateSecTables.java` (line 85).
