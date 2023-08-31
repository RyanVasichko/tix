# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@tailwindcss/ui", to: "https://ga.jspm.io/npm:@tailwindcss/ui@0.7.2/index.js"
pin "@tailwindcss/custom-forms", to: "https://ga.jspm.io/npm:@tailwindcss/custom-forms@0.2.1/src/index.js"
pin "@tailwindcss/typography", to: "https://ga.jspm.io/npm:@tailwindcss/typography@0.2.0/src/index.js"
pin "ansi-styles", to: "https://ga.jspm.io/npm:ansi-styles@4.3.0/index.js"
pin "chalk", to: "https://ga.jspm.io/npm:chalk@4.1.2/source/index.js"
pin "color-convert", to: "https://ga.jspm.io/npm:color-convert@2.0.1/index.js"
pin "color-name", to: "https://ga.jspm.io/npm:color-name@1.1.4/index.js"
pin "css-unit-converter", to: "https://ga.jspm.io/npm:css-unit-converter@1.1.2/index.js"
pin "cssesc", to: "https://ga.jspm.io/npm:cssesc@3.0.0/cssesc.js"
pin "hex-rgb", to: "https://ga.jspm.io/npm:hex-rgb@4.3.0/index.js"
pin "lodash", to: "https://ga.jspm.io/npm:lodash@4.17.21/lodash.js"
pin "lodash/castArray", to: "https://ga.jspm.io/npm:lodash@4.17.21/castArray.js"
pin "lodash/cloneDeep", to: "https://ga.jspm.io/npm:lodash@4.17.21/cloneDeep.js"
pin "lodash/defaults", to: "https://ga.jspm.io/npm:lodash@4.17.21/defaults.js"
pin "lodash/flatMap", to: "https://ga.jspm.io/npm:lodash@4.17.21/flatMap.js"
pin "lodash/fromPairs", to: "https://ga.jspm.io/npm:lodash@4.17.21/fromPairs.js"
pin "lodash/get", to: "https://ga.jspm.io/npm:lodash@4.17.21/get.js"
pin "lodash/isArray", to: "https://ga.jspm.io/npm:lodash@4.17.21/isArray.js"
pin "lodash/isEmpty", to: "https://ga.jspm.io/npm:lodash@4.17.21/isEmpty.js"
pin "lodash/isFunction", to: "https://ga.jspm.io/npm:lodash@4.17.21/isFunction.js"
pin "lodash/isPlainObject", to: "https://ga.jspm.io/npm:lodash@4.17.21/isPlainObject.js"
pin "lodash/isUndefined", to: "https://ga.jspm.io/npm:lodash@4.17.21/isUndefined.js"
pin "lodash/map", to: "https://ga.jspm.io/npm:lodash@4.17.21/map.js"
pin "lodash/merge", to: "https://ga.jspm.io/npm:lodash@4.17.21/merge.js"
pin "lodash/mergeWith", to: "https://ga.jspm.io/npm:lodash@4.17.21/mergeWith.js"
pin "lodash/some", to: "https://ga.jspm.io/npm:lodash@4.17.21/some.js"
pin "lodash/tap", to: "https://ga.jspm.io/npm:lodash@4.17.21/tap.js"
pin "lodash/toPairs", to: "https://ga.jspm.io/npm:lodash@4.17.21/toPairs.js"
pin "lodash/toPath", to: "https://ga.jspm.io/npm:lodash@4.17.21/toPath.js"
pin "mini-svg-data-uri", to: "https://ga.jspm.io/npm:mini-svg-data-uri@1.4.4/index.js"
pin "postcss-selector-parser", to: "https://ga.jspm.io/npm:postcss-selector-parser@6.0.13/dist/index.js"
pin "postcss-value-parser", to: "https://ga.jspm.io/npm:postcss-value-parser@3.3.1/lib/index.js"
pin "process", to: "https://ga.jspm.io/npm:@jspm/core@2.0.1/nodelibs/browser/process-production.js"
pin "reduce-css-calc", to: "https://ga.jspm.io/npm:reduce-css-calc@2.1.8/dist/index.js"
pin "supports-color", to: "https://ga.jspm.io/npm:supports-color@7.2.0/browser.js"
pin "tailwindcss/defaultConfig", to: "https://ga.jspm.io/npm:tailwindcss@1.9.6/defaultConfig.js"
pin "tailwindcss/defaultTheme", to: "https://ga.jspm.io/npm:tailwindcss@1.9.6/defaultTheme.js"
pin "tailwindcss/plugin", to: "https://ga.jspm.io/npm:tailwindcss@1.9.6/plugin.js"
pin "tailwindcss/resolveConfig", to: "https://ga.jspm.io/npm:tailwindcss@1.9.6/resolveConfig.js"
pin "traverse", to: "https://ga.jspm.io/npm:traverse@0.6.7/index.js"
pin "util-deprecate", to: "https://ga.jspm.io/npm:util-deprecate@1.0.2/browser.js"
