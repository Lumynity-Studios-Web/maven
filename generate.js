const fs = require("fs");
const path = require("path");

const IGNORE = [".git", "node_modules", ".github", "generate.js", "GenMavenArtifact.bat"];

function pad(str, len) {
    return str.length >= len ? str : str + " ".repeat(len - str.length);
}

function formatDate(mtime) {
    const d = new Date(mtime);
    const day = String(d.getDate()).padStart(2, "0");
    const month = d.toLocaleString("en", { month: "short" });
    const year = d.getFullYear();
    const hh = String(d.getHours()).padStart(2, "0");
    const mm = String(d.getMinutes()).padStart(2, "0");
    return `${day}-${month}-${year} ${hh}:${mm}`;
}

function formatSize(bytes) {
    if (bytes < 1024) return bytes + "B";
    if (bytes < 1024 ** 2) return (bytes / 1024).toFixed(1) + "KB";
    if (bytes < 1024 ** 3) return (bytes / 1024 ** 2).toFixed(1) + "MB";
    if (bytes < 1024 ** 4) return (bytes / 1024 ** 3).toFixed(1) + "GB";
    return (bytes / 1024 ** 4).toFixed(1) + " TB";
}

function generateIndex(dir) {
    const entries = fs.readdirSync(dir, { withFileTypes: true })
        .filter(e => !IGNORE.includes(e.name) && e.name !== "index.html")
        .sort((a, b) => {
            if (a.isDirectory() !== b.isDirectory()) return a.isDirectory() ? -1 : 1;
            return a.name.localeCompare(b.name);
        });

    const relPath = ("/" + path.relative(".", dir).replace(/\\/g, "/")).replace(/\/$/, "") + "/";
    const displayPath = relPath === "//" ? "/" : relPath;

    const lines = entries.map(e => {
        const isDir = e.isDirectory();
        const href = e.name + (isDir ? "/" : "");
        const stat = isDir ? null : fs.statSync(path.join(dir, e.name));
        const date = isDir ? "-" : formatDate(stat.mtime);
        const size = isDir ? "-" : formatSize(stat.size);
        const padding = " ".repeat(Math.max(1, 50 - href.length));
        const dateStr = pad(date, 17);
        const sizeStr = size.padStart(10);
        return `<a href="${href}">${href}</a>${padding}${dateStr}${sizeStr}`;
    });

    const backLink = displayPath !== "/" ? `<a href="../">../</a>\n` : "";

const html =
`<html>
<head>
<title>${displayPath}</title>
</head>
<body bgcolor="white">
<h2>${displayPath}</h2><hr><pre>${backLink}${lines.join("\n")}
</pre><hr></body>
</html>`;

    fs.writeFileSync(path.join(dir, "index.html"), html);
    console.log(`Generated: ${path.join(dir, "index.html")}`);

    entries.filter(e => e.isDirectory()).forEach(e => {
        generateIndex(path.join(dir, e.name));
    });
}

generateIndex(".");
console.log("Done!");