# troika-toolbox: MATLAB scripts for analyzing Troika SPT data
[![DOI](https://zenodo.org/badge/706878719.svg)](https://zenodo.org/doi/10.5281/zenodo.10019823)

A small set of programs dedicated to analyzing [Troika's](https://github.com/LandesLab/Troika-Single-particle-tracking) `trjR` variables.

### What's in the box
#### `~`
| Name | Description |
|:--------:|:-----------:|
|`troikaEnum`|Find when a track starts, ends, and how long it lasted for.|
|`troikaPrecision`|Calculate Troika's precision in the context of your camera.|
|`trjR_separator`|Separates combined trjR files into parts with the same number of trajectories.|

#### `converters/`
| Name | Description |
|:--------:|:-----------:|
|`toMsdanalyzer`|Convert `trjR`s into tracks for [msdanalyzer](https://github.com/tinevez/msdanalyzer).|
|`toTrack_analysis`|Convert `trjR`s into tracks for [track_analysis](https://github.com/andrewx101/track_analysis).|

#### `functions/`
| Name | Description |
|:--------:|:-----------:|
|`traj_filt`|Get tracks that last `x` frames or greater. Also interpolate between lost frames of tracking.|
|`traj_firstframe`|Removes all tracks present since the first frame.|
|`traj_sorter`|Separates "fast" and "slow" tracks.|

#### `graphs/`
| Name | Description |
|:--------:|:-----------:|
|`displacements`|Plot the displacement of tracks vs. time-lag.|
|`trackEvolutions`|Plot how tracks change over time.|
|`vanHove`|Plot and fit a van Hove correlation graph.|
|`fitRec`|Plot the reconstructed van Hove correlation graph from Track Analysis.|

#### `msd/`
N/A