import { defineConfig } from 'vite';

export default defineConfig({
  optimizeDeps: {
    exclude: ['fs', 'path', 'os'],
  },
  resolve: {
    alias: {
      fs: 'rollup-plugin-node-polyfills/polyfills/fs',
      path: 'rollup-plugin-node-polyfills/polyfills/path',
      os: 'rollup-plugin-node-polyfills/polyfills/os',
    },
  },
});
