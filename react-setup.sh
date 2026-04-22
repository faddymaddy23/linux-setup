npm create vite@latest

npm install tailwindcss @tailwindcss/vite

npm install -D gulp
npm i -D browser-sync

npm i lucide-react

npm i react-router




Vite Config file:
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";
import path from "path";

// https://vite.dev/config/
export default defineConfig({
    plugins: [react(), tailwindcss()],

    build: {
        outDir: "../build",
        emptyOutDir: true,

        rollupOptions: {
            input: path.resolve(__dirname, "src/main.tsx"),
            output: {
                entryFileNames: "assets/[name].js",
                assetFileNames: "assets/[name].[ext]",
            },
        },
    },

    resolve: {
        alias: {
            "@": path.resolve(__dirname, "./src"),
        },
    },
});




gulpfile.cjs:
const { watch, series } = require("gulp");
const { exec } = require("child_process");
const browserSync = require("browser-sync").create();
const path = require("path");

// Run your existing npm build script
function buildReact(cb) {
    exec("npm run build", (err, stdout, stderr) => {
        console.log(stdout);
        console.error(stderr);
        cb(err);
    });
}

// Reload browser
function reloadBrowser(cb) {
    browserSync.reload();
    cb();
}

// Start BrowserSync server (proxy to local WordPress)
function startBrowserSync(cb) {
    browserSync.init({
        proxy: "http://localhost/react-panel/", // <-- WordPress page
        open: false, // Don't auto-open browser
        notify: false,
        ghostMode: false,
    });
    cb();
}

// Watch for changes in JSX, TSX, and CSS files
function watchReact() {
    watch(
        [
            "src/**/*.{js,jsx,ts,tsx,css}", // JS/TS/CSS in src
            "*.html", // index.html
            "*.css", // root-level CSS files like index.css
            "tailwind.config.js",
        ],
        series(buildReact, reloadBrowser)
    );
}

exports.default = series(buildReact, startBrowserSync, watchReact);
exports.build = buildReact;
