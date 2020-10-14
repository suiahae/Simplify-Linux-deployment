https://github.com/Almamu/linux-wallpaperengine

lz4-devel-1.9.1-2.fc32
SDL_mixer-devel-1.2.12-19.fc32 SDL2_mixer-devel-2.0.4-5.fc32.x86_64
freeglut-devel-3.2.1-3.fc32.x86_64


---

Cannot initialize SDL audio system: Mixer not built with MP3 support

https://github.com/Almamu/linux-wallpaperengine/issues/10#issuecomment-606631096
mpg123-devel

Mixer not built with Ogg Vorbis support

~~libogg-devel~~
libvorbis-devel

Mixer not built with FLAC support 

flac-devel

```
hg clone http://hg.libsdl.org/SDL_mixer/
hg checkout SDL-1.2
sudo apt install libmpg123-dev
mkdir build
cd build
../configure
make
sudo make install
```

---

https://github.com/Almamu/linux-wallpaperengine/issues/16#issuecomment-629167606

>I've done some testing on a Fedora 32 clean installation and the only way to get it to link properly is compiling Irrlicht manually. It seems that the library shipped with Fedora has some issues (and this has been happening since Fedora 25 *at least*). Do they have any way of contacting the package maintainer for Fedora so whoever is taking care of it can look into it and solve it? I don't know how Fedora handles this kind of situations tbh...
>
>Compiling irrlicht is actually pretty simple, just download the source code, go into the source/Irrlicht folder and run `make sharedlib`, then you can install it with `make install`, but make sure you've removed the irrlicht and irrlicht-devel packages. The version shipped with Fedora is the same as the one in their website, so there should be no issue replacing it.
>http://downloads.sourceforge.net/irrlicht/irrlicht-1.8.4.zip
>
>Another option would be to statically-link the compiled version (instead of installing a sharedlib in the system, so it can be kept up to date by the package manager and only wallpaperengine uses the custom-built one), but this will require changes in the CMake to ensure it's done properly.
>
>I know this is less than ideal, but I can't really figure out exactly what's wrong with it.

libXxf86vm-devel.x86_64
