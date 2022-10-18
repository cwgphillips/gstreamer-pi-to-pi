gst-launch-1.0 -v udpsrc port=5200 ! \
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
		glimagesink
