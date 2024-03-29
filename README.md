[![build and test](https://github.com/davidf2281/Mocca/actions/workflows/ios.yml/badge.svg)](https://github.com/davidf2281/Mocca/actions/workflows/ios.yml)
[![codecov](https://codecov.io/gh/davidf2281/Mocca/branch/main/graph/badge.svg?token=svyGm6gMC0)](https://codecov.io/gh/davidf2281/Mocca)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
# Mocca - a More Controllable Camera App for iOS

Mocca - the **MO**re **C**ontrollable **C**amera **A**pp - is a minimalist stills-only iOS camera. Its design goal is to appeal to those accustomed to manual photography who often want more predictable control than the stock iOS camera app affords. With Mocca you must set the focus/exposure point yourself and — unlike the stock iOS app — it stays where you put it, instead of resetting itself on a whim just as you're about to hit the shutter button.

Mocca is a work in progress, but the main branch is always in a useable state. It's currently very simple, with a camera preview, shutter button, live histogram and tap-to-set focus/exposure reticle. Drag your finger up or down in the camera preview to adjust exposure compensation.

#### About the code
Mocca is written entirely in Swift + SwiftUI and based on the MVVM pattern. Abstraction of client code from hardware dependency is done chiefly via dependency inversion (the 'D' in SOLID), to push untestable AVFoundation code as far down as possible.

The main goal of Mocca is a clean, highly testable codebase: new features will be added only when existing features have sufficient test coverage.

#### Upcoming features
* Physical-camera selection for multiple-camera devices
