module ManageHooks (myManageHook,myScratchpads) where

import XMonad
import XMonad.StackSet as W
import XMonad.Util.NamedScratchpad
import XMonad.ManageHook

import Data.Monoid
import XMonad.Hooks.ManageHelpers

import Workspace (myWorkspaces)

myScratchpads :: [NamedScratchpad]
myScratchpads = [  NS "terminal" spawnTerm findTerm manageTerm
                ]
  where
    spawnTerm = "kitty --class scratchpad -o background_opacity=1.0"
    findTerm = resource =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l r w h
      where 
        h = 0.9
        w = 0.9
        l = 0.95 - h
        r = 0.95 - w

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
  [ className =? "mpv" --> doShift (myWorkspaces !! 3)
  , className =? "qutebrowser" --> doShift (myWorkspaces !! 1)
  , className =? "Google-chrome" --> doShift (myWorkspaces !! 1)
  , isFullscreen --> doFullFloat
  ] <+> namedScratchpadManageHook myScratchpads
