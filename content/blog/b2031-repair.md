+++
date = "2016-05-09T12:41:01+02:00"
title = "Fix Buzzing Sound in Behringer B2031A Studio Monitor"
+++

One of my [B2031A](http://www.music-group.com/Categories/Behringer/Loudspeaker-Systems/Studio-Monitors/B2031A/p/P0252)'s started some weeks ago to make strange noises after running more than half an hour and the speaker popped very loud when I switched it off an on within short time.
It was not the type of digital noise where you can hear your mouse moving on the display because the monitors or computers cheap power supply is injecting a lot of noise in the ground wire.
This can be fixed with a proper [DI-Unit](https://en.wikipedia.org/wiki/DI_unit), I'm using [this one](http://www.thomann.de/de/art_dti.htm) to isolate my computer from the amplifier.
Instead, one speaker was making buzzing sounds that got louder until the tweeter has shut off.
The source of the issue could be anything, but the speakers are already more than 10 years old, and failing electrolytic capacitors are a common problem for amplifiers and power supplies, so I decided to take a look and replace them if necessary.

Here is a list of tools and materials that you need to replace the capacitors:

- A philips screwdriver
- a small wrench (to remove the lock nut from the op-amp, a small plier will work, too)
- A soldering iron
- A desoldering pump is highly recommended
- (1mm) solder wire
- Thermal paste (to repaste the amplifiers)
- Two 6.800µF 50V capacitors

I've used [TDK/Epcos B41231](https://www.buerklin.com/de/elektrolytkondensator/p/13d6024), but they've other dimensions than the original ones (22x50mm instead of 25x40mm). I would try to get one with the same size because I had to improvise a bit to make them fit.

**DISCLAIMER**: Don't try to repair any electrical device that works needs more than [extra-low voltage](https://en.wikipedia.org/wiki/Extra-low_voltage) to operate because you can **die** from electric shock.
I will not be responsible for damage to equipment, blown parts or personal injury that may result from the use of this material.

The disassembly was quite easy:

- Unscrew the amplifier case, starting with the outer screws and then remove the three dome headed screws
- Disconnect all cables from the board (they only fit in one direction which makes connecting very easy)
- Unscrew the op-amps from the heat sink

![Behringer B2031 amplifier board front](/imgs/b2031a_amp_board_front.jpg)

The main capacitors seem to be fine on the first look but, but there was almost no electrolyte left inside. You can check this by hearing some rattling sound when you shake them.

![Behringer B2031 amplifier board back side](/imgs/b2031a_amp_board_back.jpg)

To make the auto power circuit more sensible you have to change `RXX` (near `IC11`) to one with a lower resistance, less than `50R`. I can't provide a link to the schematics, but you can find them easily using google.Unfortunately, the resistors are SMD models and I don't have the tools to replace them, so you've to tried it for your self.


![Behringer B2031 amplifier board fixed](/imgs/b2031a_amp_fixed.jpg)
