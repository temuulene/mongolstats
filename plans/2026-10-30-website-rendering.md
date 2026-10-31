# Website rendering and Mongolian landing page

## Findings

- Five illustrated tutorials test an obsolete pkgdown option. Their chunks do
  not execute when the website disables optional live reference examples.
- Earlier page/link checks do not distinguish a tutorial with figures from a
  tutorial containing only its source code and the package logo.
- The English home page contains duplicated English and Mongolian prose.
- The development package version otherwise places new builds under docs/dev,
  leaving the published root pages unchanged.

## Implementation

- Use pkgdown's supported IN_PKGDOWN environment context for tutorial execution,
  with package-check suppression taking precedence.
- Keep live reference examples disabled independently of article rendering.
- Publish the current documentation at the root, retaining its actual version.
- Keep the English landing page in English and add a Mongolian landing page at
  /mn/, with reciprocal language links and clearly labelled English guides.
- Render the Mongolian landing page with the same pkgdown theme, translated
  navigation, source credits, and two examples with Mongolian plot labels.
- Include the Mongolian page in the sitemap and keep favicon paths relative so
  they work under both language routes.
- Check actual figure files, dimensions, article figure counts, language routes,
  and local links before every website deployment.

## Verification

The regression first produced five missing-figure failures. All 18 rendering and
site-validator assertions now pass. The full website contains 38 plots across
the two home pages and six illustrated articles. All plots load in the browser,
have descriptive alternative text, and fit the content column. Local references
pass across 78 HTML pages; the mobile Mongolian menu and language links work.

Package checks report zero errors and warnings. The incoming note identifies the
development version and the Mongolian URL, which becomes available on deployment.
Lint passes. GitHub checks and the website preview must pass before merging and
publishing, followed by live-page and image verification.
