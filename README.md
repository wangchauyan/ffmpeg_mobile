# ffmpeg for mobile platforms 

ffmpeg_mobile is a repository for building ffmpeg library on Android & iOS platforms. 

### Android platform
Please check the following steps to modify the build-Android.sh 

> 1. mark sure you download the ndk from http://developer.android.com/intl/zh-tw/ndk/downloads/index.html
> 2. The latest version is r11c, but I use r10 to build ffmpeg (3.0, the latest code). I haven't test r11c for buidling latest ffmpeg code. So, if you can't build that, please let me know.
> 3. Download the ndk lib and extract to Android SDK path. 
> 4. Now, make sure you remember the ndk lib path and try to run ./nkd-build to see if you setup already. 

After finishing setup everything, now open the build-Android.sh. You will need to modify some parts of this file. 

> 1. modify export NDK line, change to your ndk lib path. 
> 2. I build on my MBPR, so I will use "darwin-x86_64", but if you use linux system, please change this to linux-x86_64. Or you will build failed. 

### iOS platform 

