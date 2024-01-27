import XMonad
import XMonad.Actions.Navigation2D
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns
import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce
import XMonad.Util.Ungrab

myLayout = avoidStruts(tiled ||| Mirror tiled ||| Full ||| threeCol)
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled = Tall nmaster delta ratio
    nmaster = 1 -- Default number of windows in the master pane
    ratio = 1 / 2 -- Default proportion of screen occupied by master pane
    delta = 3 / 100 -- Percent of screen to increment by when resizing panes

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

myConfig =
  navigation2DP
    def
    ("k", "h", "j", "l")
    [ ("M-", windowGo),
      ("M-S-", windowSwap)
    ]
    False
    $ def
      { modMask = mod4Mask, -- Rebind Mod to the Super key
        layoutHook = myLayout,
        focusFollowsMouse = False,
        terminal = "alacritty",
        startupHook = myStartupHook,
        manageHook = myManageHook
      }
      `additionalKeysP` [ ("M-i", spawn "i3lock"),
                          ("M-b", spawn "firefox"),
                          ("M-q", kill),
                          ("M-r", spawn "rofi -normal-window -show combi"),
                          ("M-e", spawn "rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}' -normal-window"),
                          ("M-m", spawn "code"),
                          ("M-<Return>", spawn "alacritty"),
                          ("M-x", restart "xmonad" True)
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
