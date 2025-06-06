# worldspawn

## configuring

note: change `Release` to `Debug` for debug builds.

note: the "Unix Makefiles" generator is required due to a [CMake limitation regarding `IMPLICIT_DEPENDS`](https://cmake.org/cmake/help/latest/command/add_custom_command.html).

```sh
cmake -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -Bbuild -S.
```

## building

it is advised to follow these steps in this order. once you are done, the
compiled game will be in the repo in the `game` folder.

```sh
# map compiler tools
cmake --build build --target qbsp vis light

# asset tools
cmake --build build --target iqmtool fteqcc

# engine and required plugins
cmake --build build --target fteqw plug_jolt plug_hl2

# dedicated server
cmake --build build --target fteqw-sv

# copy librequake assets
cmake --build build --target librequake

# game assets
cmake --build build --target maps models

# game code
cmake --build build --target quakec
```
