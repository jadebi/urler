export default defineNuxtConfig({
  compatibilityDate: '2025-01-01',
  devtools: { enabled: true },

  ssr: true,

  nitro: {
    preset: 'static',
  },

  css: [
    '@picocss/pico/css/pico.min.css',
    '~/assets/css/themes/light.css',
    '~/assets/css/themes/dark.css',
    '~/assets/css/themes/emerald.css',
    '~/assets/css/base.css',
  ],

  app: {
    head: {
      title: '🔗 urler',
      meta: [{ name: 'viewport', content: 'width=device-width, initial-scale=1.0' }],
      link: [
        {
          rel: 'stylesheet',
          href: 'https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@3.45.0/dist/tabler-icons.min.css',
        },
      ],
      script: [
        {
          key: 'theme-init',
          innerHTML: `(function(){var s=localStorage.getItem('theme')||'auto';document.documentElement.dataset.theme=s==='auto'?(window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light'):s;})();`,
        },
      ],
      htmlAttrs: { lang: 'en', 'data-theme': 'light' },
    },
  },
})
