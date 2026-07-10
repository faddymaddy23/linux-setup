# For simple plugins, when inside plugin root folder run
wp i18n make-pot . languages/plugin_name.pot



# For TypeScript plugin

# 1. Run following from react folder
npm install --save-dev @wordpress/i18n

# 2. Update your TypeScript files to use the `__` function from `@wordpress/i18n` for translatable strings. For example:
#    import { __ } from "@wordpress/i18n";
#    {__("How can I help you today?", "wn-lcb")}

# 3. In vite.config.ts, mark @wordpress/i18n as external so the browser uses
#    WordPress's global wp.i18n object (where translations actually get loaded)
#    instead of a separate bundled copy:
#      rollupOptions: {
#        external: ["@wordpress/i18n"],
#        output: {
#          format: "iife",
#          globals: { "@wordpress/i18n": "wp.i18n" },
#          ...
#        }
#      }

# 4. Run following from react folder
npm install --save-dev esbuild
## add tmp-i18n/ to gitignore
npx esbuild $(find src -name '*.ts' -o -name '*.tsx') \
  --jsx=preserve \
  --format=esm \
  --outdir=tmp-i18n \
  --outbase=public/react/src \
  --allow-overwrite

# 5. Then run following from plugin root folder
WP_CLI_PHP_ARGS='-d memory_limit=4G' wp i18n make-pot . languages/plugin_name.pot --exclude=node_modules,public/dist

# 6. Delete the throwaway folder
rm -rf tmp-i18n

# 7. Create a .po per language from the .pot, and fill in translations
cp languages/plugin_name.pot languages/wn-lcb-fr_FR.po
# ...translate strings in wn-lcb-fr_FR.po (e.g. via Poedit)...

# 8. Generate the JSON WordPress reads at runtime
wp i18n make-json languages --no-purge

# 9. Rename the generated json to match your exact script handle
#    (WordPress checks this filename pattern before its md5-hash fallback)
mv languages/wn-lcb-fr_FR-<hash>.json languages/wn-lcb-fr_FR-<plugin_name>-app-js.json


# Translation functions:

__( text, domain ) - default choice
<h1>{__("How can I help you today?", "wn-lcb")}</h1>


_x( text, context, domain ) — use when the same English word could need different translations depending on where its used
# "Close" as in closing a modal
<button>{_x("Close", "chat window action", "wn-lcb")}</button>
# "Close" meaning nearby — same English word, different translation in many languages
<span>{_x("Close", "proximity, e.g. nearby location", "wn-lcb")}</span>


_n( single, plural, number, domain ) — use whenever a count is involved
import { __, _n, sprintf } from "@wordpress/i18n";
<p>
  {sprintf(
    _n("%d message", "%d messages", messageCount, "wn-lcb"),
    messageCount
  )}
</p>


_nx( single, plural, number, context, domain ) — combine both: plural forms and disambiguating context.
<p>
  {sprintf(
    _nx("%d reply", "%d replies", replyCount, "chat thread replies", "wn-lcb"),
    replyCount
  )}
</p>
