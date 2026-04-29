# FFmpegKit SPM

> [!WARNING]  
> Since the upstream [FFmpegKit](https://github.com/arthenica/ffmpeg-kit) project has been retired, this one has been retired as well.

This is a Swift Package Manager compatible version of [FFmpegKit](https://github.com/arthenica/ffmpeg-kit). 
It distributes and bundles the ffmpeg-kit-https version for iOS, macOS and tvOS as a single xcframework. 

### Installation
Add this repo to as a Swift Package dependency to your project
```
https://github.com/wonkwh/ffmpeg-kit-spm
```

If using this in a swift package, add this repo as a dependency.
```
.package(url: "https://github.com/wonkwh/ffmpeg-kit-spm/", .upToNextMajor(from: "5.1.0"))
```

### Usage

To get started, import this library: `import ffmpegkit` \
_If you are wanting to use the FFmpeg libav c libraries directly: `import FFmpeg`_

See the [FFmpegKit wiki](https://github.com/arthenica/ffmpeg-kit/tree/main/apple#3-using) for more info on integration and usage for FFmpeg. \
_For using FFmpeg directly, see the [FFmpeg documentation](https://trac.ffmpeg.org/wiki/Using%20libav*) here_

### Building
If you would like to build your own xcframework binaries run the `build.sh` script on a macOS machine.

### build issue
다음과 같은 이슈가 나올때
```sh
./bootstrap.conf: line 71: gnulib/gnulib-tool: No such file or directory
./bootstrap: Error: 'bison' version == 2.3 is too old
./bootstrap:        'bison' version >= 2.4 is required
./bootstrap: line 269: gtkdocize: command not found
./bootstrap: Error: 'gtkdocize' not found
```
- bison 의 버전 확인 `bison --version` 
- brew 로 설치된 버전이 안나오면 `echo 'export PATH="/opt/homebrew/opt/bison/bin:$PATH"' >> ~/.zshrc` 후 터미널 재 시작
- gtkdocize command 는 문서화를 위해 필요하므로 실제 사용시는 필요없다 
  - `export GTKDOCIZE=echo` 후 터미널 재시작
