import { createApp } from 'vue'
import App from './App.vue'
import Login from './Login.vue'
import { router } from './router'

createApp(App).use(router).mount('#app')