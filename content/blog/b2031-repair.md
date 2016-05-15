+++
date = "2016-05-09T12:41:01+02:00"
title = "Fix Buzzing Sound in Behringer B2031A Studio Monitor"
+++

Some weeks ago, one of my [B2031A](http://www.music-group.com/Categories/Behringer/Loudspeaker-Systems/Studio-Monitors/B2031A/p/P0252)'s started to make strange noises after running more than half an hour and the speaker popped very loud when I switched it off an on within short time.
It was not the type of [high-pitched digital noise](https://www.youtube.com/watch?v=GbNyINuo-Uw) where you can hear your mouse cursor moving on the display, because the monitors or computers cheap power supply is injecting a lot of noise in the ground wire.
By the way, this can be fixed with a proper [DI-Unit](https://en.wikipedia.org/wiki/DI_unit). I'm using [this one](http://www.thomann.de/de/art_dti.htm) to isolate my computer from the amplifier.
However, one speaker was making buzzing sounds that got louder until the tweeter has shut off.
The source of the issue could be anything, but the speakers are already more than 10 years old, and failing electrolytic capacitors are a common problem for amplifiers and power supplies, so I decided to take a look and replace them if necessary.

Here is a list of tools and materials that you need to replace the capacitors:

- A philips screwdriver
- a small wrench (to remove the lock nut from the op-amp, a small plier will work, too)
- A soldering iron
- A desoldering pump is highly recommended
- (1mm) solder wire
- Thermal paste (to repaste the op-amps)
- Two 6.800µF 50V capacitors

I've used [TDK/Epcos B41231](https://www.buerklin.com/de/elektrolytkondensator/p/13d6024), but they've other dimensions than the original ones (22x50mm instead of 25x40mm). I would try to get one with the same size because I had to improvise a bit to make them fit.

**DISCLAIMER**: If you are not a trained electrician then don't try to repair any electrical device that needs more than [extra-low voltage](https://en.wikipedia.org/wiki/Extra-low_voltage) to operate because you risk getting a lethal electric shock.
I will not be responsible for damage to equipment, blown parts or personal injury that may result from the use of these instructions.

The disassembly was quite easy:

- Unscrew the amplifier case, starting with the outer screws and then remove the three dome headed screws
- Disconnect all cables from the board (they only fit in one direction which makes reconnecting very easy)
- Unscrew the op-amps from the heat sink

![Behringer B2031 amplifier board front](/imgs/b2031a_amp_board_front.jpg)

The main capacitors seem to be fine on the first look but, but there was almost no electrolyte left inside.
Empty capacitors will make a rattling sound when you shake them.

Another modification that I would have liked to do is to lower the threshold level of the auto power circuit.
The factory default setting is way too high, so the speaker always shuts off on silent passages.
Unfortunately, the resistor that is responsible for the auto power level is an SMD model and I don't have the appropriate tools to replace them.
Anyone else can try to replace the 47 ohms `R83`, that is located near `IC11`, to one with a lower resistance.
I can't provide a link to the schematics, but you can find them easily using google.

![Behringer B2031 amplifier board back side](/imgs/b2031a_amp_board_back.jpg)

The 22x50mm replacement capacitors where a little bit to tall to fit inside the case, so I had to improvise a bit.
My hacky solution was to solder some wires between them and the board.
Nonetheless, the speaker works fine and the buzzing noise is gone.

![Behringer B2031 amplifier board fixed](/imgs/b2031a_amp_fixed.jpg)
