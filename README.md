# gstreamer-pi-to-pi
Use GStreamer to stream video from a Pi Zero 2 W with a Pi Zero Camera to second Pi

## Capture and Transmit Videos
To capture images from a pi camera and then stream to a UDP sink.
Run the pipline (same pipline in: video_stream_out.sh):
`gst-launch-1.0 -v v4l2src device=/dev/video0 num-buffers=-1 ! video/x-raw, width=640, height=480, framerate=30/1 ! videoconvert ! jpegenc ! rtpjpegpay ! udpsink host=192.168.1.137 port=5200`

## Receive and View Video Stream
To view the video being stramed into a UDP sink by another piplie.
Run the following (same pipline in: video_stream_in_simple.sh):
`gst-launch-1.0 -v udpsrc port=5200 ! \
	application/x-rtp, media=video, clock-rate=90000, payload=96 ! \
	rtpjpegdepay ! \
	jpegdec ! \
	videoconvert ! \
	autovideosink`

You can then play with GStreamer's built in functionality to do things like splitting the image into different windows (which GStreamer refers to as `tee`) and applying different processing to these - processes like edge detection, for example (same pipeline in: video_stream_in_tee_and_edge_detect.sh):
`gst-launch-1.0 -v udpsrc port=5200 ! \
	application/x-rtp, media=video, clock-rate=90000, payload=96 ! \
	rtpjpegdepay ! \
	jpegdec ! \
	videoconvert ! \
	tee name=t1 \
	t1. ! \
		queue ! \
		videoconvert ! \
	autovideosink \
	t1. ! \
		queue ! \
		videoconvert ! \
		glupload ! \
		gleffects_sobel ! \
		videoconvert ! \
		glimagesink`

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
