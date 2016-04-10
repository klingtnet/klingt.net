{
    "date": "2015-01-04",
    "description": "How to setup a processing 2 project in IntelliJ Idea 14.",
    "slug": "processing-2-in-intellij-idea-14",
    "tags": "intellij, idea, processing, java, grischa lichtenberger, raster noton, max4live, cycling74, ableton",
    "title": "Processing 2 in IntelliJ Idea 14"
}

Inspired by some live shows of [Grischa
Lichtenberger](http://grischa-lichtenberger.com/) that I saw recently
and from the [max4live
datamatrix](http://www.maxforlive.com/library/device/2665/datamatrix)
device, I wanted to do some visual stuff. I had the idea to create a
browser based audio visualization app using [d3](http://d3js.org/) since
a few weeks but you can't access the monitor audio stream (which
contains the audio that is playedback at the moment) from within the
browser. At least all I could access was the microphone stream. This is
why I gave processing a second chance. But creating processing sketches
using the integrated editor is quite a hassle, so I decided to use
[IntelliJ Idea](https://www.jetbrains.com/idea/). Because there is no
tutorial out there that describes how to setup a processing environment
in Idea, I am ready to change this.

Setup a project
===============

Create a new Java project without additional libraries and frameworks
and choose any name you want, in my case `processing-example`.

![image](/imgs/processing-idea_new_project.png)

The next thing to do is to import processing `core` library. If you
haven't installed processing you can get it from the [official
website](https://processing.org/download/?processing),
[github](https://github.com/processing/processing) or using the package
manager of your choice.

Import processing
-----------------

Open the project structure dialog `File → Project Structure ...` or
press `Ctrl+Alt+Shift+S`, go to `Libraries` and add a new Java library
using the `+` button. If you don't know where processing is installed on
your system, use `locate processing/core` or
`find / -type d -iname "processing" 2> /dev/null`. Now add the
`core.jar` file from the `core/library` subfolder of you processing
installation directory.

![image](/imgs/processing-idea_core_jar.png)

Create a new package, e.g. `net.klingt.example` and a new Java Class
inside that package named `ProcessingExample`. Now you have to import
the processing core library by writing the following import statement:
`import processing.core.*;`. Maybe IntelliJ will remove the line as soon
as you press enter, because it assumes that you aren't using anything
from it and therefore it *optimizes* the import. To disable this
behaviour go to `File → Settings` or press `Ctrl+Alt+S` and in the
following dialog disable `Optimize imports on the fly` under
`Editor → General → Auto Import` [^1].

![image](/imgs/processing-idea_imports.png)

Create an example class
-----------------------

Your main class has to extend `PApplet` and has to implement the `setup`
and `draw` method. It should look something like this:

```java
package net.klingt.example;

import processing.core.*;

public class ProcessingExample extends PApplet {

    public void setup() {
        size(400,400);
        background(0);
    }

    public void draw() {
        stroke(255);
        if (mousePressed) {
            line(mouseX,mouseY,pmouseX,pmouseY);
        }
    }
}
```

This simple applet draws your mouse cursor path when the left mouse
button is pressed. I took it from the [eclipse setup
instructions](https://processing.org/tutorials/eclipse/) on the
processing tutorials.

Before you can run the applet you have to create a run configuration. To
do this open `Run → Make Configurations ...` and add a new *Applet*
configuration with the `ProcessingExample` class as *Applet class*.

![image](/imgs/processing-idea_run_config.png)

Voila, you applet should start when you press the *play* button or
`Shift+F10`!

![image](/imgs/processing-idea_applet.png)

To run your processing sketch as *Application* instead of an *Applet*
you have to implement a `main` method. You can add the method to your
existing class or create a seperate `Main` class like I do.

```java
package net.klingt.example;

import processing.core.PApplet;

public class Main {
    public static void main(String args[]) {
        // full-screen mode can be activated via parameters to PApplets main method.
        PApplet.main(new String[] {"net.klingt.example.ProcessingExample"});
    }
}
```

Now you can run you sketch as *Application* by pressing `Shift+F10` in
your `Main` class.

For further details read the *eclipse setup instructions* that I've
linked above or take a look at Daniel Shiffmans [Learning
Processing](http://www.learningprocessing.com/) website.

**Update**

You can reuse the project as Idae project template using
`Tools → Save Project as Template ...`.

[^1]: You can optimize the imports manually either by pressing
    `Ctrl+Alt+O` or by using `Code → Optimize Imports ...`.
