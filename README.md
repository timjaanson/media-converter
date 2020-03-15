# media-converter
Docker container for batch converting media files.

Based on jrottenberg/ffmpeg Docker container. Includes ffmpeg and ImageMagick with a shell script wrapper to handle batch conversion.

# Run examples

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

### No application, run it interactively
```
docker run --rm -it \
    -v $(pwd):/input \
    --entrypoint "/bin/bash" \
    timjaanson/media-converter
```

# Environment variables
* APPLICATION
Specifying the APPLICATION variable sets which application to use.

All arguments supplied after the name of the docker image are directly passed to the application.

* NO_BATCH
Disables batch conversion. Meant for single file operations.

With this ENV variable enabled, you need to specify the full path and filename for both input and output files.
See ffmpeg example with NO_BATCH enabled

## Debugging
There's two ENV variables to help with debugging. 
To use either, set the ENV variable to any value when executing `docker run`.

* CONVERTER_DEBUG=1
Enables debug messages

* CONVERTER_DEBUG_SET_X=1
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