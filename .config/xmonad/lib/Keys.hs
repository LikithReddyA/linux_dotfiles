module Keys (myKeys,myTerminal,superMask) where

import XMonad
import XMonad.Util.EZConfig (mkKeymap)

--Terminal
myTerminal = "alacritty"

-- Browser
myBrowser = "qutebrowser"

-- My Editor
myEditor = "alacritty -e nvim"

--Mod Key 
superMask :: KeyMask
superMask = mod4Mask

myKeys :: [(String, X ())]
myKeys =
  [ ("M-<Return>", spawn myTerminal)
  , ("M-p", spawn "rofi -show run")
  , ("M-b", spawn myBrowser)
  , ("M-e", spawn myEditor)
  , ("C-q",spawn "~/.local/bin/power-menu.sh")
  ]
