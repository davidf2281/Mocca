[![Build Status](https://travis-ci.org/davidf2281/Mocca.svg?branch=main)](https://travis-ci.org/davidf2281/Mocca) 
[![codecov](https://codecov.io/gh/davidf2281/Mocca/branch/main/graph/badge.svg?token=svyGm6gMC0)](undefined)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
# Mocca - a More Controllable Camera App for iOS

Mocca - the **MO**re **C**ontrollable **C**amera **A**pp - is a minimalist stills-only iOS camera. Its design goal is to appeal to those accustomed to manual photography who often want more predictable control than the stock iOS camera app affords. With Mocca you must set the focus/exposure point yourself and — unlike the stock iOS app — it stays where you put it, instead of resetting itself on a whim just as you're about to hit the shutter button.

Mocca is very much a work in progress, but the main branch is always in a useable state. It's currently very simple indeed (just a camera preview, shutter button and a tap-to-set focus/exposure reticle), but entirely functional.

#### About the code
With the exception of a bit of Objective-C in the unit tests, Mocca is written entirely in Swift, using the new declarative SwiftUI framework and based on the MVVM (model-view-viewmodel) design pattern, which suits SwiftUI well.

An important goal of Mocca is a clean, highly testable codebase: new features will be added only when existing features have sufficient test coverage to be confident of moving forward.

#### Upcoming features
* Physical-camera selection for multiple-camera devices
* Exposure compensation
