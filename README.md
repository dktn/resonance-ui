# Resonance Atom UI theme - resonance-ui package

A minimal UI.
Compact, distraction free, configurable.
Best with [resonance-syntax](https://github.com/dktn/resonance-syntax).

## Features

* Compact size:
    - Tree View can show large projects trees on the screen (small height of entries)
    - Many tabs can fit on the screen and still look clear
    - Most of the icons from 'file-icons' packages are adjusted to compact version
* Distraction free:
    - Hiding unused files with visible git statuses
    - Frame boxes are mostly not displayed
    - Minimap in SublimeText style, not showing highlight until mouse is over it
* Simple tabs behavior:
    - Tab activation do not change its size and layout
    - Tab icons change to 'dirty' icon when a file is unsaved
    - Tab icons change to 'close' icon when a mouse is over a tab
* Colors: dark / low contrast, compatible with 'resonance-syntax'
* Changed default Haskell icon color from 'file-icons' package to green, I just didn't like default magenta

## Configuration

* Theme colors
* Various sizes (tree view line height, tab height)
* Hiding unused files with visible git statuses
* Auto-reloading on settings change
* Patch for file-icons package making icons more compact (this is off by default, because the 'file-icons' must be present before turning it on)

![](https://raw.githubusercontent.com/dktn/resonance-ui/master/resonance-theme.png)

## Credits

* [Polymorph UI](https://atom.io/themes/polymorph-ui) - general structure and styles
* [Climate Atom Theme](https://atom.io/themes/climate-ui) - distraction free mode

#### Addons used in screenshots
* [minimap](https://atom.io/packages/minimap)
* [file-icons](https://atom.io/packages/file-icons)
* [resonance-syntax](https://github.com/dktn/resonance-syntax)
