# RetroArch configuration

These files can sit happily in the retroarch config directory so you can freely
update without overriding them.

To use, just tell RetroArch to append this config.

    retroarch --appendconfig=/path/to/custom.cfg

### On Gamepads

If the gamepad is not detected, it should be sufficient to plonk a `.cfg` from
[the default list](https://github.com/libretro/retroarch-joypad-autoconfig)
into the `autoconfig` directory.

You might like to edit controls.cfg. I have found no way to not make it
dependent on the gamepad that is being used. Wish there was some way to bind it
using retropad abstraction...
