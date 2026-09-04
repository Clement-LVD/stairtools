# Initialize an empty stair plotting scene

A scene is a pair of data.frames (`segments`, `labels`) that
`scene_add_*()` functions append to. Each row carries a `role`, used to
look up style only at plot time.

## Usage

``` r
scene_build()
```

## Value

A `stair_scene`: a list with empty `segments` and `labels` data.frames.
