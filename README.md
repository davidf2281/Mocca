[![Build Status](https://travis-ci.org/davidf2281/Mocca.svg?branch=main)](https://travis-ci.org/davidf2281/Mocca)

# Mocca - A More Controllable Camera App for iOS

Mocca - the **MO**re **C**ontrollable **C**amera **A**pp - is a minimalist stills-only iOS camera, designed for folk accustomed to manual photography that like to have more predictable control than the stock iOS camera app affords. You set the focus/exposure point yourself and — unlike the stock iOS app — it stays there rather than resetting itself on a whim just as you're about to hit the shutter button.

Mocca is very much a work in progress, but the main branch is always in a useable state. It's currently very simple indeed (just a camera preview, shutter button and a tap-to-set focus/exposure reticle) but entirely functional.

#### About the code
With the exception of a bit of Objective-C in the unit tests, Mocca is written entirely in Swift, using the new declarative SwiftUI framework and based on the MVVM (model-view-viewmodel) design pattern, which suits SwiftUI well.

#### Upcoming features
* Physical-camera selection for multiple-camera devices
* Exposure compensation
