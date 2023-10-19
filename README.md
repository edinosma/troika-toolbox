# troika-toolbox: MATLAB scripts for analyzing Troika SPT data
[![DOI](https://zenodo.org/badge/706878719.svg)](https://zenodo.org/doi/10.5281/zenodo.10019823)

A small set of programs dedicated to analyzing [Troika's](https://github.com/LandesLab/Troika-Single-particle-tracking) `trjR` variables.

### What's in the box
#### `~`
| Name | Description |
|:--------:|:-----------:|
|`troikaEnum`|Find when a track starts, ends, and how long it lasted for.|
|`troikaPrecision`|Calculate Troika's precision in the context of your camera.|

#### `functions/`
| Name | Description |
|:--------:|:-----------:|
|`traj_firstframe`|Removes all tracks present since the first frame.|
|`traj_sorter`|Separates "fast" and "slow" tracks.|
|`traj_filt`|Get tracks that last `x` frames or greater. Also interpolate between lost frames of tracking.|

#### `graphs/`
| Name | Description |
|:--------:|:-----------:|
|`displacements`|Plot the displacement of tracks vs. time-lag.|
|`trackEvolutions`|Plot how tracks change over time.|
|`vanHove`|Generate a van Hove correlation graph.|
