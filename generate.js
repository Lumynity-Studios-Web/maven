const fs = require("fs");
const path = require("path");

const IGNORE = [".git", "node_modules", ".github", "generate.js", "GenMavenArtifact.bat"];

function pad(str, len) {
    return str.length >= len ? str : str + " ".repeat(len - str.length);
}

function formatDate(mtime) {
    const date = new Date(mtime);
    const day = String(date.getDate()).padStart(2, "0");
    const month = date.toLocaleString("en", { month: "short" });
    const year = date.getFullYear();
    const hh = String(date.getHours()).padStart(2, "0");
    const mm = String(date.getMinutes()).padStart(2, "0");
    return `${day}-${month}-${year} ${hh}:${mm}`;
}

function formatSize(bytes) {
    if (bytes < 1024) return bytes + "";
    if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(0) + "K";
    return (bytes / (1024 * 1024)).toFixed(0) + "M";
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
        const paddedName = pad(href, 50);
        const dateStr = pad(date, 17);
        const sizeStr = size.padStart(6);
        return `<a href="${href}">${paddedName}</a>${dateStr}${sizeStr}`;
    });

    const backLink = displayPath !== "/" ? `<a href="../">../</a>\n` : "";

    const html =
`<html>
<head><title>Index of ${displayPath}</title></head>
<style>pre { display: block; font-family: inherit; unicode-bidi: isolate; white-space: pre; margin-block: 1em 1em; margin-inline: 0px; }</style>
<body bgcolor="white">
<h1>Index of ${displayPath}</h1><hr><pre>${backLink}${lines.join("\n")}
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