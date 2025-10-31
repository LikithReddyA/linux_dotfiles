import XMonad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import System.IO

import XMonad.Hooks.EwmhDesktops

-- Custom modules
import Workspace (myWorkspaces)
import Hooks (myStartupHook)
import Layouts (myLayoutHook)
import Keys (myKeys,myTerminal,superMask)
import ManageHooks (myManageHook)


main = do
     xmonad $ docks . ewmhFullscreen . ewmh $ def
        { terminal = myTerminal
        , modMask = superMask
        , workspaces = myWorkspaces
        , borderWidth = 2
        , layoutHook = myLayoutHook
        , startupHook = myStartupHook
        , manageHook = myManageHook <+> manageDocks
        }
        `additionalKeysP` myKeys
