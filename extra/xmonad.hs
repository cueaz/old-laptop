import           XMonad
import           XMonad.Actions.MouseResize
import           XMonad.Actions.Navigation2D
import           XMonad.Config.Desktop
import           XMonad.Layout.BinarySpacePartition
import           XMonad.Layout.BorderResize
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.Gaps
import           XMonad.Layout.Renamed
import           XMonad.Layout.Spacing
import           XMonad.Util.EZConfig

myTerminal = "st -f \"Fira Mono:size=10:dpi=216\" -e tmux"
myModMask = mod4Mask
myBorderWidth = 0
myFocusFollowsMouse = False

myManageHook = composeAll
    [ className =? "mpv" --> doFloat
    ]

myLayoutHook = fullscreenFull $ myBSP ||| Full
  where
    myBSP =
        renamed [Replace "MyBSP"]
        $ mouseResize
        $ borderResize
        $ spacing 8
        $ gaps [(d,160) | d <- [L,R]]
        emptyBSP

myKeys =
    [ ("M-p", spawn "rofi -show run")
    , ("M-S-p", spawn "rofi -show window")
    , ("<XF86AudioLowerVolume>", spawn "amixer set Master 3%- unmute")
    , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 3%+ unmute")
    , ("<XF86AudioMute>", spawn "amixer set Master toggle")
    , ("M-M1-l", sendMessage $ ExpandTowards R)
    , ("M-M1-h", sendMessage $ ExpandTowards L)
    , ("M-M1-j", sendMessage $ ExpandTowards D)
    , ("M-M1-k", sendMessage $ ExpandTowards U)
    , ("M-M1-S-l", sendMessage $ ShrinkFrom R)
    , ("M-M1-S-h", sendMessage $ ShrinkFrom L)
    , ("M-M1-S-j", sendMessage $ ShrinkFrom D)
    , ("M-M1-S-k", sendMessage $ ShrinkFrom U)
    , ("M-r", sendMessage Rotate)
    , ("M-s", sendMessage Swap)
    , ("M-f", sendMessage FocusParent)
    , ("M-x", sendMessage SelectNode)
    , ("M-v", sendMessage MoveNode)
    , ("M-a", sendMessage Balance)
    , ("M-S-a", sendMessage Equalize)
    ]

myNavigation2DConfig = def
    { layoutNavigation = [(l, centerNavigation) | l <- ["MyBSP", "Full"]]
    , unmappedWindowRect = [("Full", singleWindowRect)]
    }

defaults =
    withNavigation2DConfig myNavigation2DConfig
    $ additionalNav2DKeysP
        ("k", "h", "j", "l")
        [("M-", windowGo), ("M-S-", windowSwap)]
        False
    $ fullscreenSupport
    $ desktopConfig
    { terminal = myTerminal
    , modMask = myModMask
    , borderWidth = myBorderWidth
    , focusFollowsMouse = myFocusFollowsMouse
    , manageHook = myManageHook <+> manageHook desktopConfig
    , layoutHook = myLayoutHook
    } `additionalKeysP` myKeys

main = xmonad defaults
