# media-converter
Docker container for batch converting media files.

Based on Ubuntu:18.04. Includes FFmpeg and ImageMagick with a shell script wrapper to handle batch conversion.

# Run examples

## Output
By default converted files will be saved to a directory called "output" in the mounted volume.

To save the files to a different location, mount another volume to the container's "/output" directory:

  `-v /tmp:/output`

In the above example all converted files will be saved to /tmp on the host machine

## Manual mode
Manually specifying converting application means you need to use the argument format of the application.

To do that, set the correct ENV variable during docker run: `-e APPLICATION=<application name>`

See below for examples

### ffmpeg
* Convert all files in current working directory to mp4 using ffmpeg
```
docker run --rm \
    -e APPLICATION=ffmpeg \
    -v $(pwd):/input \
    timjaanson/media-converter \
    -i INPUT_FILE OUTPUT_FILE.mp4
```

* Convert video from the web to mp4 and save it to current working directory as `converted-video.mp4`
```
docker run --rm \
    -e APPLICATION=ffmpeg \
    -e NO_BATCH=1 \
    -v $(pwd):/output \
    timjaanson/media-converter \
    -i http://techslides.com/demos/sample-videos/small.webm /output/converted-video.mp4
```

### ImageMagick
* Convert all files in current working directory to png using ImageMagick's convert binary
```
docker run --rm \
    -e APPLICATION=convert \
    -v $(pwd):/input \
    timjaanson/media-converter \
    INPUT_FILE OUTPUT_FILE.png
```

### Base64 encode
* Convert all files in current working directory to base64 CSS3 url() format using linux cli tools.
```
docker run --rm \
      -e APPLICATION=b64 \
      -v $(pwd):/input \
      timjaanson/media-converter \
      -o css INPUT_FILE OUTPUT_FILE.txt
```

### No application, run it interactively
```
docker run --rm -it \
    -v $(pwd):/input \
    --entrypoint "/bin/bash" \
    timjaanson/media-converter
```

# Environment variables
* `APPLICATION=application name`

Specifying the APPLICATION variable sets which application to use.

All arguments supplied after the name of the docker image are directly passed to the application. See examples under section "Manual mode"


* `NO_BATCH=1`

Disables batch conversion. Meant for single file operations.

With this ENV variable enabled, you need to specify the full path and filename for both input and output files.
See ffmpeg example with NO_BATCH enabled

## Debugging
There's two ENV variables to help with debugging. 
To use either, set the ENV variable to any value when executing docker run.

* `CONVERTER_DEBUG=1`

Enables debug messages


* `CONVERTER_DEBUG_SET_X=1`

Enables `set -x` in the shell script.

This will print all commands to STDOUT before executing.

### Debug example
* Debug enabled ffmpeg example from above
```
docker run --rm \
    -e CONVERTER_DEBUG=1 \
    -e APPLICATION=ffmpeg \
    -v $(pwd):/input \
    timjaanson/media-converter \
    -i INPUT_FILE OUTPUT_FILE.mp4
```

# Building the container yourself
Before building the container, it is recommended to increase `MAKE_FLAGS=-j` value in the Dockerfile to potentially speed up compilation of FFmpeg and ImageMagick. However, this is not necessary.

A safe value would be **\<number of available CPU threads> + 1**, i.e. with 4 available threads: `MAKE_FLAGS="-j 5"`


To actually build the container, use
```
docker build -t timjaanson/media-converter .
```
when at the root of the project repository

# ARM support
This container also works on ARM based devices like a Raspberry PI.

Currently there aren't any available pre-built ARM images, so you need to build the container yourself.
See the section "Building the container yourself" for more info.
