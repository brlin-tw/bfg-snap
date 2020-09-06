# Unofficial Snap Packaging for BFG Repo-Cleaner
<!--
	Use the Staticaly service for easy access to in-repo pictures:
	https://www.staticaly.com/
-->
![(Placeholder) Icon of BFG Repo-Cleaner](https://cdn.statically.io/gh/Lin-Buo-Ren/bfg-snap/183812e9/snap/gui/bfg.png "(Placeholder) Icon of BFG Repo-Cleaner")

**This is the unofficial snap for BFG Repo-Cleaner**, *"Removes large or troublesome blobs like git-filter-branch does, but faster"*. It works on Ubuntu, Fedora, Debian, and other major Linux distributions.

[![bfg-repo-cleaner](https://snapcraft.io//bfg-repo-cleaner/badge.svg)](https://snapcraft.io/bfg-repo-cleaner)[![bfg-repo-cleaner](https://snapcraft.io//bfg-repo-cleaner/trending.svg?name=0)](https://snapcraft.io/bfg-repo-cleaner)

![Screenshot of the Snapped Application](https://cdn.statically.io/gh/Lin-Buo-Ren/bfg-snap/183812e9/snap/local/screenshots/bfg-help-carbon.png "Screenshot of the Snapped Application")

Published for <img src="http://anything.codes/slack-emoji-for-techies/emoji/tux.png" align="top" width="24" /> with 💝 by Snapcrafters

## Installation
([Don't have snapd installed?](https://snapcraft.io/docs/core/install))

### In a Terminal
    # Install the snap #
    sudo snap install --channel=beta bfg-repo-cleaner
    #sudo snap install bfg-repo-cleaner
    
    # Connect the snap to optional security confinement interfaces #
    ## For accessing files under /media ##
    sudo snap connect bfg-repo-cleaner:removable-media
    
    # Launch the application #
    bfg
    snap run bfg # If you have another existing installation

### The Graphical Way
[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/bfg-repo-cleaner)

<!-- Uncomment when you have test results
## What is Working
* [A list of functionallities that are verified working]

## What is NOT Working...yet 
Check out the [issue tracker](https://github.com/Lin-Buo-Ren/bfg-snap/issues) for known issues.
-->

## Support
* Report issues regarding using this snap to the issue tracker:  
  <https://github.com/Lin-Buo-Ren/bfg-snap/issues>
* You may also post on the Snapcraft Forum, under the `snap` topic category:  
  <https://forum.snapcraft.io/c/snap>
