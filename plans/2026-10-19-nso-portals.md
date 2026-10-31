# NSO data and metadata implementation plan

**Goal:** Deliver the actionable improvements from the portal review while preserving existing query contracts and source attribution.

**Architecture:** Retain PXWeb data functions. Add structured provenance and value-status access to their results, common service request helpers, typed metadata records, an explicit portal client, and reviewed indicator templates. Use source-qualified identifiers and preserve unknown or inconsistent source fields. Geometry remains in mongolmaps.

**Validation:** Write and run failing regression tests before changing behavior. Verify each component, then run the complete offline suite, targeted live checks, documentation checks, lint, coverage, and package build/check. Inspect all changes and generated outputs.

## Tasks

1. Transport and configuration: coordinate requests across processes; apply conservative request intervals to initial requests, retries, and cookie seeding; validate options; expose cached PXWeb server configuration and enforce the query cell limit. The source manual identifies maxValues as a metadata-listing limit rather than a POST selection constraint.
2. Shared service helpers: construct validated URLs and parse typed JSON responses through the existing offline/error boundary.
3. PXWeb response integrity: retain nonnumeric raw symbols and statuses, reject unexpected content shapes, preserve stable periods, and combine split requests without losing metadata or status rows.
4. Provenance: add table information, provenance, citation, and JSON manifest export/reload; collect metadata for single and batch fetches and retain failure manifests.
5. Government metadata: implement source-qualified discovery, detail records, related records, forms, and versioned classification codes; preserve raw values, calendar dates, years, access states, and quality flags.
6. Indicators and portal data: add reviewed common PXWeb query templates, live portal indicator discovery, explicit portal data retrieval, code/label/status normalization, and provenance. Expose uncertain mappings explicitly.
7. Discovery: add catalog status/build metadata and live search; preserve offline behavior and prevent incomplete refreshes from replacing complete catalog snapshots.
8. Analytical checks: report mixed units, duplicated observation keys, unresolved symbols, incomplete periods, and overlapping geography where evidence supports the check.
9. Delivery: add bilingual guides, examples, release notes and reference entries; add an explicit live service canary; remove disallowed attribution references; regenerate documentation; complete quality gates and final independent review.

## Boundaries

Public metadata describes source systems and collection fields; it does not establish permission to retrieve underlying respondent records. Portal interfaces remain experimental while their public contract is unversioned. OLAP support begins with documented capability discovery and an explicit unsupported-query condition where a stable public interface cannot be verified; no undocumented access or invented mappings.

## Progress

- [x] Transport/configuration and shared helpers
- [x] Parsing and provenance
- [x] Typed metadata and classifications
- [x] Indicators and portal client
- [x] Catalog freshness and analytical checks
- [x] Documentation, live checks, complete verification, attribution audit, review

## Verified 2026-10-23

* Complete offline suite: 859 passing expectations, no failures or warnings;
  17 live tests deliberately skipped and one dependency-absence test inapplicable.
* Coverage: 92.79%, above the repository's 80% gate. Package lint is clean.
* Full package build/check with vignettes: zero errors and warnings; one existing
  incoming-feasibility note for the `Remotes` field.
* Public PXWeb, metadata, portal aggregate series, and datamart discovery canary
  passed. Real PXWeb and portal provenance exports survived JSON roundtrips.
* Separate processes and a loopback server verified shared request spacing,
  actual retries and redirects, failed-request recovery, bounded lock waits,
  and offline behavior. Every measured request interval exceeded one second.
* README and website rendered successfully with pinned documentation tools.
  Reference regeneration is idempotent; the bilingual guide builds offline.
* Content, filename, image-metadata, compressed-data, and commit-metadata audits
  found no prohibited references. Source dataset attribution remains intact.
* Independent reviews completed; all confirmed findings were fixed with
  regression tests written and run before the corresponding behavior changes.

The working changes remain on `feature/nso-metadata-and-portal`; no commit,
remote push, release, or website publication was performed.
