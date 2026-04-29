// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "min.v5.1.2.14"

let frameworks = ["libavcodec": "7713d8527f4e9628499ef208e8ee20db21f07d387e701207242981de7d59378e", "libavdevice": "591023da4b2cf94584120750250833659420f35e78a7107c96b7e5f86fbeb403", "libavfilter": "9b7643e719fd18d4dc071f39349e2b888c6bce4e6f215a573bfb8df1fbfbfe0c", "libavformat": "77303e735d85fb2fc8b00bdebdc9f89014b884a274621a11a7f820af031a884f", "libavutil": "f36913abf278b7ae38ab655799f880aa9c591a4040d789871370c0d5fb0ddad1", "libswresample": "9ad2bd36002ffd3bd5ba72e909c809ccf568f24128c7fe4b07667fb810eb752b", "libswscale": "c06cbd6ce7548978181e197f3343625496aaf6aeb43eaf00029200a660e0a3b5"]

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
