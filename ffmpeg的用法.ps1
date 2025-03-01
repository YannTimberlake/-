#此方法需配合2文件使用
ffmpeg.exe -loglevel quiet -f concat  -safe 0  -i files.txt -vcodec copy -acodec copy output.mp4


