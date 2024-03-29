import Data.Map qualified as M
import XMonad
import XMonad.Core
import XMonad.Actions.MouseResize
import XMonad.Actions.Navigation2D
import XMonad.Config.Xfce
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.BorderResize
import XMonad.Layout.DecorationMadness
import XMonad.Layout.Dishes
import XMonad.Layout.MagicFocus
import XMonad.Layout.Magnifier
import XMonad.Layout.MosaicAlt
import XMonad.Layout.MultiColumns
import XMonad.Layout.ResizableTile
import XMonad.Layout.Square
import XMonad.Layout.ThreeColumns
import XMonad.Layout.WindowArranger
import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce
import XMonad.Util.Ungrab
import XMonad.Actions.CycleWS

-- Note: Use Mod+Space to switch between layouts
myLayout =
  avoidStruts $
    mouseResize $
      windowArrange
        ( emptyBSP -- divide by 2 for each new windows
            ||| Full -- fullscreen curren window
            ||| MosaicAlt M.empty -- equal width for each window
            ||| magnifier (MosaicAlt M.empty)
        )

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "xsetroot -cursor_name left_ptr"
  spawnOnce "feh --bg-fill --no-fehbg /etc/background.png"
  spawnOnce "trayer --monitor primary --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x5f5f5f --iconspacing 10 --height 25"
  spawnOnce "nm-applet --sm-disable"
  spawnOnce "volctl"

myManageHook :: ManageHook
myManageHook =
  composeAll
    [ className =? "Rofi" --> doFloat,
      isDialog --> doFloat
    ]

defaultTerminal :: String
defaultTerminal = "kitty"

myConfig =
  navigation2DP
    ( def
        { layoutNavigation =
            [ ("Full", centerNavigation),
              ("Magnifier MosaicAlt", centerNavigation)
            ]
        }
    )
    ("k", "h", "j", "l")
    [ ("M-", windowGo),
      ("M-S-", windowToScreen)
    ]
    True
    $ xfceConfig
      { modMask = mod4Mask, -- Rebind Mod to the Super key
        layoutHook = myLayout,
        focusFollowsMouse = False,
        terminal = defaultTerminal,
        startupHook = myStartupHook,
        manageHook = myManageHook,
        borderWidth = 4,
        focusedBorderColor = "#efff00"
      }
      `additionalKeysP` [ ("M-i", spawn "i3lock"),
                          ("M-b", spawn "firefox"),
                          ("M-q", kill),
                          ("M-r", spawn "rofi -normal-window -show combi"),
                          ("M-e", spawn "rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}' -normal-window"),
                          ("M-m", spawn "code"),
                          ("M-<Return>", spawn defaultTerminal),
                          ("M-x", restart "xmonad" True),

                          ("M1-<Tab>", windowGo R True),
                          ("M1-S-<Tab>", windowGo L True),

                          -- mod + Page_up/Page_down for navigating non empty workspace
                          ("M-<Page_Down>", moveTo Next (hiddenWS :&: Not emptyWS)),
                          ("M-<Page_Up>", moveTo Prev (hiddenWS :&: Not emptyWS)),

                          -- mod + up/down for navigating empty workspace when trying to find a blank one
                          ("M-<Down>", moveTo Next (hiddenWS :&: emptyWS)),
                          ("M-<Up>", moveTo Prev (hiddenWS :&: emptyWS))
                        ]

myXmobarPP :: PP
myXmobarPP =
  def
    { ppSep = magenta " • ",
      ppTitleSanitize = xmobarStrip,
      ppCurrent = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2,
      ppHidden = white . wrap " " "",
      ppHiddenNoWindows = lowWhite . wrap " " "",
      ppUrgent = red . wrap (yellow "!") (yellow "!"),
      ppOrder = \[ws, l, _, wins] -> [ws, l, wins],
      ppExtras = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused = wrap (white "[") (white "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue . ppWindow

    -- \| Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta = xmobarColor "#ff79c6" ""
    blue = xmobarColor "#bd93f9" ""
    white = xmobarColor "#f8f8f2" ""
    yellow = xmobarColor "#f1fa8c" ""
    red = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

main :: IO ()
main = do
  getDirectories
    >>= launch
      ( ( ewmhFullscreen
            . ewmh
            . docks
            . withSB (statusBarProp "xmobar /etc/xmobar.hs" (pure myXmobarPP))
        )
          myConfig
      )
