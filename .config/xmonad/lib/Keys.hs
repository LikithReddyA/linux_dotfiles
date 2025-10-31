module Keys (myKeys,myTerminal,superMask) where

import XMonad
import XMonad.Util.EZConfig (mkKeymap)
import XMonad.Util.NamedScratchpad
import qualified XMonad.Actions.Search as S

    -- Prompt
import XMonad.Prompt
import XMonad.Prompt.Man
import XMonad.Prompt.XMonad

import ManageHooks (myScratchpads)

--Terminal
myTerminal = "kitty"

-- Browser
myBrowser = "qutebrowser"

-- My Editor
myEditor = myTerminal ++ " -e nvim"

--Mod Key 
superMask :: KeyMask
superMask = mod4Mask

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:bold:size=12"


------------------------------------------------------------------------
-- XPROMPT SETTINGS
------------------------------------------------------------------------
dtXPConfig :: XPConfig
dtXPConfig = def
          {
            font = myFont
          , position = Top
            -- position            = CenteredAt { xpCenterY = 0.3, xpWidth = 0.3 }
          , bgColor             = "#292d3e"
          , fgColor             = "#d0d0d0"
          , bgHLight            = "#c792ea"
          , fgHLight            = "#000000"
          , borderColor         = "#535974"
          , promptBorderWidth   = 0
          , height              = 20
          , historySize         = 256
          , historyFilter       = id
          , defaultText         = []
          , showCompletionOnTab = False
          -- , searchPredicate     = isPrefixOf
          -- , searchPredicate     = fuzzyMatch
          , alwaysHighlight     = True
          , maxComplRows        = Nothing      -- set to Just 5 for 5 rows
          }

-- The same config above minus the autocomplete feature which is annoying
-- on certain Xprompts, like the search engine prompts.
dtXPConfig' :: XPConfig
dtXPConfig' = dtXPConfig
      { autoComplete        = Nothing
--       , autoComplete        = Just 100000  -- set Just 100000 for .1 sec
      }

----------------------------------------------------
------------------- Search Engines List ------------
----------------------------------------------------

searchList :: [(String, S.SearchEngine)]
searchList = [("a", S.aur)
             , ("g", S.google)
             , ("y", S.youtube)
             ]

-- A list of all of the standard Xmonad prompts and a key press assigned to them.
-- These are used in conjunction with keybinding I set later in the config.
promptList :: [(String, XPConfig -> X ())]
promptList = [ ("m", manPrompt)          -- manpages prompt
             , ("x", xmonadPrompt)       -- xmonad prompt
             ]
----------------------------------------------------

myKeys :: [(String, X ())]
myKeys =
  [ ("M-<Return>", spawn myTerminal)
  , ("M-S-<Return>", spawn "rofi -show run")
  , ("M-b", spawn myBrowser)
  , ("M-e", spawn myEditor)
  , ("C-q",spawn "~/.local/bin/power-menu.sh")
  , ("M-/", namedScratchpadAction myScratchpads "terminal" )
  ]
  -- Search commands
  ++ [("M-s " ++ k, S.promptSearchBrowser dtXPConfig myBrowser f) | (k,f) <- searchList ]
  ++ [("M-p " ++ k, f dtXPConfig') | (k,f) <- promptList ]
