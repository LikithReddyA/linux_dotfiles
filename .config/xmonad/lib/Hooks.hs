module Hooks (myStartupHook) where

import XMonad
import XMonad.Util.SpawnOnce

myStartupHook :: X ()
myStartupHook = do
    spawn "feh --bg-scale ~/Downloads/linux.jpeg"
    spawn "polybar mybar &"
    spawnOnce "picom"
    spawnOnce "xsetroot -cursor_name left_ptr"
