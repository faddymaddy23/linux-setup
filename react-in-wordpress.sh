# Create vite app in a folder inside a plugin
npm create vite@latest react


# Install dependencies
cd react
npm install tailwindcss @tailwindcss/vite


# Update vite config
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";
import path from "path";

// https://vite.dev/config/
export default defineConfig({
    plugins: [react(), tailwindcss()],
    build: {
        outDir: "../build", // This is relative to your `react` folder
        emptyOutDir: true,
        rollupOptions: {
            input: path.resolve(__dirname, "src/main.jsx"), // app entry point
            output: {
                entryFileNames: "[name].js",
                assetFileNames: "[name].[ext]",
            },
        },
    },
});


# Import tailwind in your main css file
@import "tailwindcss";


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

