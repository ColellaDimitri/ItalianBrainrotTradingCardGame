import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig(({ command, mode }) => {
    const base = '/'

    return {
        base,
        server: {
            port: 8080,
            strictPort: true,
            proxy: {
                [`${base}api`]: {
                    target: 'http://localhost:8081',
                    changeOrigin: true,
                }
            }
        },
        plugins: [vue()]
    }
})
