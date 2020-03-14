# media-converter
Docker container for batch converting media files.

Based on jrottenberg/ffmpeg Docker container. Includes ffmpeg and ImageMagick with a shell script wrapper to handle batch conversion.

# Run examples

## Manual
Manually specifying converting application means you need to use the argument format of the application.
You need to specify the application by setting the correct env variable value during docker run: `-e APPLICATION=&lt;application name&gt;`

### ffmpeg
* Convert all files in current working directory to mp4 using ffmpeg
```
docker run --rm -it \
    -e APPLICATION=ffmpeg \
    -v $(pwd):/input \
    timjaanson/media-converter \
    -i INPUT_FILE OUTPUT_FILE.mp4
```

### ImageMagick
* Convert all files in current working directory to png using ImageMagick's convert binary
```
docker run --rm -it \
    -e APPLICATION=convert \
    -v $(pwd):/input \
    timjaanson/media-converter \
    INPUT_FILE OUTPUT_FILE.png
```
