# troika-toolbox: MATLAB scripts for analyzing Troika SPT data
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

#### `graphs/`
| Name | Description |
|:--------:|:-----------:|
|`displacements`|Plot the displacement of tracks vs. time-lag.|
|`trackEvolutions`|Plot how tracks change over time.|
|`vanHove`|Generate a van Hove correlation graph.|