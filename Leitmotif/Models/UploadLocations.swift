import Foundation

enum UploadLocation {
    case celeste
    case oneshot
    case hatintime
    case guiltygear
    case miku
    case misc
    case splatoon
    case touhou
    case vocaloid
}

let locationIds: [UploadLocation: String] = [
    .celeste: "celeste",
    .oneshot: "oneshot",
    .hatintime: "hatintime",
    .guiltygear: "guiltygear",
    .miku: "miku",
    .misc: "misc",
    .splatoon: "splatoon",
    .touhou: "touhou",
    .vocaloid: "vocaloid"
]

struct TaggedLocation: Identifiable {
    let name: String
    let tag: UploadLocation
    let id = UUID()
}

let taggedLocations = [
    TaggedLocation(name: "Celeste", tag: .celeste),
    TaggedLocation(name: "OneShot", tag: .oneshot),
    TaggedLocation(name: "A Hat in Time", tag: .hatintime),
    TaggedLocation(name: "Guilty Gear", tag: .guiltygear),
    TaggedLocation(name: "Miku", tag: .miku),
    TaggedLocation(name: "Miscellaneous", tag: .misc),
    TaggedLocation(name: "Splatoon", tag: .splatoon),
    TaggedLocation(name: "Touhou", tag: .touhou),
    TaggedLocation(name: "Vocaloid", tag: .vocaloid)
]
