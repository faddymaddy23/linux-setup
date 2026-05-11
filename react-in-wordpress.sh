# Create vite app in a folder inside a plugin
npm create vite@latest react


# Install dependencies
cd react
npm install tailwindcss @tailwindcss/vite
npm install react-router
npm install -D lucide-react
npm install -D gulp


# Update vite config
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";
import path from "path";

// https://vite.dev/config/
export default defineConfig({
    plugins: [react(), tailwindcss()],
    build: {
        outDir: "../dist",
        rollupOptions: {
            input: path.resolve(__dirname, "src/main.jsx"),
            output: {
                // Single bundle for easy WordPress enqueue
                entryFileNames: "wn-lcb-chat.js",
                chunkFileNames: "wn-lcb-chat-[name].js",
                assetFileNames: "wn-lcb-chat.[ext]",
            },
        },
    },
});


# Import tailwind in your main css file
@import "tailwindcss";

# gulpfile.cjs file:
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
    proxy: "http://localhost/woo/lms-chatbot", // <-- WordPress page
    open: false,
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
    series(buildReact, reloadBrowser),
  );
}

exports.default = series(buildReact, startBrowserSync, watchReact);
exports.build = buildReact;

# Add gulp script in package.json

    "watch": "gulp",




# Register the Style and Script in wordpress
$css_path = TUKKURUK_FEATURES_PATH . 'admin/build/main.css';
$js_path  = TUKKURUK_FEATURES_PATH . 'admin/build/main.js';

$css_version = file_exists($css_path) ? filemtime($css_path) : false;
$js_version  = file_exists($js_path) ? filemtime($js_path) : false;

wp_register_style(
    'tukkuruk-features-admin-style',
    TUKKURUK_FEATURES_URL . 'admin/build/main.css',
    array(),
    $css_version
);

wp_register_script(
    'tukkuruk-features-admin-react',
    TUKKURUK_FEATURES_URL . 'admin/build/main.js',
    array(),
    $js_version,
    true
);


# Enqueue the Style and Script where needed
wp_enqueue_style('tukkuruk-features-admin-style');
wp_enqueue_script('tukkuruk-features-admin-react');

