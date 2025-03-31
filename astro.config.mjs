// @ts-check
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
    output: "static",
    base:"/",
    site: "https://nicoleshoblom.github.io",
    integrations: [mdx()]
});

import mdx from '@astrojs/mdx';
