# `tide_pwd`

[Fish](https://fishshell.com/) plugin providing [Tide](https://github.com/IlanCosman/tide)'s pwd-formatting as a standalone function.

## Installation

Using [Fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install bachorp/tide_pwd
```

## Configuration

Please consult the corresponding [Tide docs](https://github.com/IlanCosman/tide/wiki/Configuration#pwd).

Note that in contrast to the Tide, the default `tide_pwd_markers` list contains only `.git`.

## Usage

To determine how aggressively path components shall be truncated, an integer soft limit on the width of the output using the parameter `--softlimit` (short `-w`) must be passed.

Additionally, there is an optional flag `--plain` (short `-p`) to disable ANSI coloring.
