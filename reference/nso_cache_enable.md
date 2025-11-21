# Enable or configure caching

Caches table lists and codebooks on disk to speed up repeated calls.
Optionally set a time-to-live (TTL) for cache entries.

## Usage

``` r
nso_cache_enable(dir = NULL, ttl = NULL)
```

## Arguments

- dir:

  Directory for cache; defaults to user cache dir.

- ttl:

  Optional TTL in seconds for cached entries (applies to the disk
  cache). If `NULL`, entries persist until cleared.

## Value

Cache directory path (invisibly).
