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

## Examples

``` r
# Enable caching in a temporary directory (for demo purposes)
cache_dir <- nso_cache_enable(dir = tempdir())

# Check status
nso_cache_status()
#> $enabled
#> [1] TRUE
#> 
#> $dir
#> [1] "/tmp/RtmpXS9XqZ"
#> 
#> $has_cache
#> [1] TRUE
#> 

# Disable when done
nso_cache_disable()
```
