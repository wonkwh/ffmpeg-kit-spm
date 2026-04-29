// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "min.v5.1.2.6"

let frameworks = ["libavcodec": "78d60180f73b0a5b40f45ffe8ae9145ca49914728319105d90b972f88a00b3a3", "libavdevice": "2812f8a3f8e040d155146d9d31818bf620a2b8e4bd6e4e5b3860fe3976d23a79", "libavfilter": "6cd3c20ca42ffc1c70708a0f5afca570aaf8097494030806a1dc694a5a6cb0d8", "libavformat": "73c0445c4d0e6ae6321a4456392127aafc34894170df682467022de4e521bd2e", "libavutil": "4fc196304747a648010fd571853427588f018d8ee27f2b5f78195215f79d02b9", "libswresample": "46aa417a39e0846cd9320ae00356efbb4213642eabf69cd3564a93be147ad22a", "libswscale": "d7d3687db3f9ebdf0e80df936bb6836702109ab48f8f4acb7d0012b7296e81c9"]
  "libavcodec": "ef57c2a96c365e07552e53d9359e0588bc4ab8b28f378cec8603f489a2bf1b99",
  "libavdevice": "249c7eb01ed2f5ffd7d0c1f4c48a1a8ed4bad3bc5e3e94331396149e6d6a63a8",
  "libavfilter": "c2c76167560aa419bde9846ea2afd378302684fddafb9996cfadb68034307727",
  "libavformat": "895162425e8dcded28c3be4530d98567cbdc1f4ff8120480a875edd3d3164f49",
  "libavutil": "5f93be14e84339f5e8031fecb738ceacd2a493c7dba5074e6b0f12bf768072f0",
  "libswresample": "aa4454a1856fff017ae29ea9d2df845c455a17499dc3856c1b3a7efe1862190f",
  "libswscale": "51159c86dea0bbb80e133a49e454f27f88ac01f84d8f906883ef6a5ee414ab0e"
]

func xcframework(_ package: Dictionary<String, String>.Element) -> Target {
    let url = "https://github.com/wonkwh/ffmpeg-kit-spm/releases/download/\(release)/\(package.key).xcframework.zip"
    return .binaryTarget(name: package.key, url: url, checksum: package.value)
}

let linkerSettings: [LinkerSetting] = [
    .linkedFramework("AudioToolbox", .when(platforms: [.macOS, .iOS, .macCatalyst, .tvOS])),
    .linkedFramework("AVFoundation", .when(platforms: [.macOS, .iOS, .macCatalyst])),
    .linkedFramework("CoreMedia", .when(platforms: [.macOS])),
    .linkedFramework("OpenGL", .when(platforms: [.macOS])),
    .linkedFramework("VideoToolbox", .when(platforms: [.macOS, .iOS, .macCatalyst, .tvOS])),
    .linkedLibrary("z"),
    .linkedLibrary("lzma"),
    .linkedLibrary("bz2"),
    .linkedLibrary("iconv")
]

let libAVFrameworks = frameworks.filter({ $0.key != "ffmpegkit" })

let package = Package(
    name: "ffmpeg-kit-spm",
    platforms: [.iOS(.v12), .macOS(.v10_15), .tvOS(.v11), .watchOS(.v7)],
    products: [
        .library(
            name: "FFmpeg-Kit",
            type: .dynamic,
            targets: ["FFmpeg-Kit", "ffmpegkit"]),
        .library(
            name: "FFmpeg",
            type: .dynamic,
            targets: ["FFmpeg"] + libAVFrameworks.map { $0.key }),
    ] + libAVFrameworks.map { .library(name: $0.key, targets: [$0.key]) },
    dependencies: [],
    targets: [
        .target(
            name: "FFmpeg-Kit",
            dependencies: frameworks.map { .byName(name: $0.key) },
            linkerSettings: linkerSettings),
        .target(
            name: "FFmpeg",
            dependencies: libAVFrameworks.map { .byName(name: $0.key) },
            linkerSettings: linkerSettings),
    ] + frameworks.map { xcframework($0) }
)
