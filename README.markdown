# What is defaultapp?

defaultapp is a very small application designed to do one thing: read and change default applications for URL schemes on OS X.  It is written in Objective-C and utilizes OS X's LaunchServices software.

Too often, I'm writing a script and would like to know or change the default application for a given URL scheme.  However, to my knowledge, Apple doesn't provide any way to easily do that from the command line.  Some people have turned to the bridges in Ruby and Python as well as legacy Carbon support in Perl to approximate this.  Although these work (although the Perl stuff may be getting a bit long in the tooth), it doesn't always work across every platform.  Some versions of OS X may not have the bridge installed by default (although with 10.5 and 10.6, this is becoming less of a problem).  Still, defaultapp was written as a simple way to get that information across all versions of OS X without requiring the hackiness of scripting language bridges.

## How to use defaultapp

defaultapp was written to be as simple as possible.  For instance, to merely retrieve the default application for a url scheme, simply pass the scheme as the first argument (`defaultapp mailto`).  In order to set the default application, provide the scheme and the preferred application name (`default ftp Transmit`).  Thta's it.

## Compiling on 10.4-

I'm running Snow Leopard (10.6) and not looking back.  However, I was in a position in which I needed defaultapp to run on a series of computers that were all running Tiger (10.4).  That's when I learned that Xcode on Snow Leopard does not play well with anything prior to 10.5.  I also learned that it's actually not intuitive at all to target earlier OS versions.  My solution was simply to get to a Leopard (10.5) computer and build defaultapp on it (since Xcode comes ready to build for 10.4).  That's why there are two .xcodeproj files.  One was the original from fiddling around with Xcode on Snow Leopard and then other was when I moved to a Leopard computer and simply redid the entire project in an older version of Xcode.  This compilation worked for Tiger, Leopard, and Snow Leopard, so don't go messing with it unless you're making it better.

Theoretically, these apps should compile for nearly any version of OS X.  Frankly, my memory of any OS prior to the one I'm using is rather blurry and I don't remember Panther (10.3) or Jaguar (10.2) as anything more than a fuzzy memory (and box art).  I seem to remember 10.1 better, but that was when I made the jump to OS X.  I can't remember the parts of the API that have changed or were modified at each step, but this is such a simple app that uses components that I'm fairly certain have been around and haven't changed that it should compile with few minor tweaks.  `stringUsingUTF8String:` may need to be changed to `stringUsingCString:` if you go back early enough, but that's the only thing that comes to mind right now.

## If you like it, lend me a hand

Setting up two computers with Xcode and going through the headache of compiling on Snow Leopard just to find out that it didn't work on Tiger was a headache.  If you know how to make it happen, I'd appreciate it if you'd configure the defaultapp.xcodeproj file and let me know what you did.  I don't think I'll target Tiger often, but I'd like to know how if I'm ever in this situation again.

## Contact information

[Grayson Hansard](mailto:info@fromconcentratesoftware.com)  
[From Concentrate Software](http://www.fromconcentratesoftware.com/)  
[Grayson](http://twitter.com/Grayson) @ [Twitter](http://twitter.com)