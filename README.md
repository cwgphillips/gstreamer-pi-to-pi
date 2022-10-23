# gstreamer-pi-to-pi
Use GStreamer to stream video from a Pi Zero 2 W with a Pi Zero Camera to second Pi


##


## To Stream to web page
In one terminal, run a server using python 

```
python3 -m http.server 8080
```

In a second terminal, (in the same directory as the python server is ran from), run the pipline in `video_stream_to_web_page.sh` which contains the following pipeline:
```
gst-launch-1.0 -v v4l2src device="/dev/video0" ! \
  videoconvert ! clockoverlay ! \
  videoscale ! video/x-raw,width=640, height=360 ! \
  x264enc bitrate=256 ! video/x-h264,profile=\"high\" ! \
  mpegtsmux ! \
  hlssink playlist-root=http://192.168.1.240:8080 location=segment_%05d.ts target-duration=5 max-files=5
```

Then on any device, go to: http://192.168.1.240:8080/
