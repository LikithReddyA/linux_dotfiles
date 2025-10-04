-- | Layouts.hs
-- Defines the layout hook used in XMonad configuration.
-- Provides a clean, modular, and composable layout system.

module Layouts (myLayoutHook) where

------------------------------------------------------------
-- Standard Imports
------------------------------------------------------------

import XMonad (Window)
import XMonad.Layout ((|||), Choose, Full(..))
import XMonad.Hooks.ManageDocks (AvoidStruts, avoidStruts)

-- Core layout modules
import XMonad.Layout.Decoration (Decoration, DefaultShrinker)
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.Tabbed (TabbedDecoration)
import XMonad.Layout.TwoPane (TwoPane(..))
import XMonad.Layout.Grid (Grid(..))
import XMonad.Layout.Simplest
import XMonad.Layout.SubLayouts
import XMonad.Layout.Fullscreen

------------------------------------------------------------
-- Extra Layout Modifiers
------------------------------------------------------------

import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Layout.WindowNavigation
import XMonad.Layout.NoBorders
import XMonad.Layout.LimitWindows (LimitWindows, limitWindows)
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName

------------------------------------------------------------
-- Infix Operators for Readability
------------------------------------------------------------

-- Infix alias for layout modifier chaining
infixr 1 :$
type (:$) = ModifiedLayout

-- Compose multiple layout modifiers in a nested fashion
type (:.) x y z = x :$ (y :$ z)

-- Infix alias for combining alternative layouts
infixr 2 :|||
type (:|||) = Choose

------------------------------------------------------------
-- Spacing Utilities
------------------------------------------------------------

-- | Adds uniform spacing around windows
mySpacing :: Integer -> l a -> ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- | Like mySpacing, but removes spacing when only one window is present
mySpacing' :: Integer -> l a -> ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

------------------------------------------------------------
-- Layout Type Aliases
------------------------------------------------------------

-- | The complete layout stack wrapped in ShowWName modifier
type MyLayoutHook a =
  ModifiedLayout ShowWName
    ((AvoidStruts :$ (TallLayout :||| TwoTabbedPane :||| Grid)) :||| FullscreenLayout) a

-- | A TwoPane layout with tabbed sublayouts
type TwoTabbedPane = SubTabbed TwoPane

-- | Applies tab decoration and sublayout support
type SubTabbed l =
  (Decoration TabbedDecoration DefaultShrinker :. Sublayout Simplest) l

-- | A tall layout with spacing, smart borders, sublayouts, etc.
type TallLayout =
  ModifiedLayout Rename
    (ModifiedLayout LimitWindows
      (ModifiedLayout SmartBorder
        (ModifiedLayout WindowNavigation
          (ModifiedLayout (Sublayout Simplest)
            (ModifiedLayout Spacing ResizableTall)))))

-- | Fullscreen layout type alias
type FullscreenLayout = FullscreenFull :$ Full

------------------------------------------------------------
-- ShowWName Configuration
------------------------------------------------------------

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
  { swn_font              = "xft:Ubuntu:bold:size=60"
  , swn_fade              = 1.0
  , swn_bgcolor           = "#1c1f24"
  , swn_color             = "#ffffff"
  }
------------------------------------------------------------
-- Layout Hook Exported to Main
------------------------------------------------------------

myLayoutHook :: MyLayoutHook Window
myLayoutHook =
  showWName' myShowWNameTheme
    $ (avoidStruts (tall ||| twoTabbedPane ||| Grid))
      ||| fullscreenFull Full

------------------------------------------------------------
-- Layout Definitions
------------------------------------------------------------

-- | A custom resizable tall layout with smart features
tall :: TallLayout Window
tall =
  renamed [Replace "tall"]          -- Name the layout
    $ limitWindows 5               -- Max 5 windows shown at once
    $ smartBorders                 -- Hide borders when unnecessary
    $ windowNavigation             -- Directional window movement
    $ subLayout [] Simplest        -- Support nested layouts
    $ mySpacing' 8                  -- 8px window gaps
    $ ResizableTall 1 (3/100) (1/2) [] -- Core tall layout config

twoTabbedPane :: TwoTabbedPane Window
twoTabbedPane = subTabbed $ TwoPane (1 / 55) (1 / 2)
