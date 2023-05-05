const path = require("path");
const fs = require("fs");

lib_dir = path.join(__dirname, "Release", "lib").replace(/\\/g, "/");
lib_dir_debug = path.join(__dirname, "Debug", "lib").replace(/\\/g, "/");

module.exports = {
    include_dir: path.join(__dirname, "Release", "include").replace(/\\/g, "/"),
    include_dir_debug: path
        .join(__dirname, "Debug", "include")
        .replace(/\\/g, "/"),

    libs: fs
        .readdirSync(lib_dir)
        .filter((file) => file.endsWith(".lib"))
        .map((file) => path.join(lib_dir, file))
        .join(";")
        .replace(/\\/g, "/"),
    libs_debug: fs
        .readdirSync(lib_dir_debug)
        .filter((file) => file.endsWith(".lib"))
        .map((file) => path.join(lib_dir_debug, file))
        .join(";")
        .replace(/\\/g, "/"),

    dll_dir: "",
    dll_dir_debug: "",
};
