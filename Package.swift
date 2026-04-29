// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "min.v5.1.2.6"

let frameworks = ["libavcodec": "76fa59832f38bb98473fa8e0234817f2213d4dcd3f92e4fc81dbccc7b2242836", "libavdevice": "d495b3b820f11a1ac794de42b5261e73ac6d573a62df9ba9091db45fdaa913ce", "libavfilter": "bb4a92545bd8d95c0cf2dc9b5e6bf5110428fc4fb2347571579172458d51352d", "libavformat": "952669faa0cde7bbb0ab00b78864f1d13c5d26c2200e41a5926837f0f45588d4", "libavutil": "71633aca27aeb3993dc951015c090ef42dfd95ef7833f9a13910a388a52881eb", "libswresample": "e34aed2b38050fdf35e35d79828a7725d0eaaf4fd4201698b895959403b99dbc", "libswscale": "04ff98ab2f6fe603d94c7e2688cc8d69d0f4304f4ac33e3cc551515690363a8c"]
  "ffmpegkit": "2a786433c59eb360afded9fa6a24d9f3a41ad20701eaadd14eb419bdc5248b28",
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
