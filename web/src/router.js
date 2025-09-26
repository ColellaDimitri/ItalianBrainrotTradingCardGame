import { createRouter, createWebHistory } from 'vue-router'
import { isAuthenticated } from './auth'

// Lazy-loading des pages (bonne pratique)
const Login = () => import('./Login.vue')
const AppPage = () => import('./App.vue')

const routes = [
    { path: '/', redirect: '/app' },
    { path: '/login', component: Login, meta: { guestOnly: true } },
    { path: '/app', component: AppPage, meta: { requiresAuth: true } },
]

export const router = createRouter({
    history: createWebHistory(),
    routes,
})

// Garde globale
router.beforeEach((to, from, next) => {
    const authed = isAuthenticated()

    if (to.meta.requiresAuth && !authed) {
        // pas connecté -> redirige vers login en gardant la destination
        return next({ path: '/login', query: { redirect: to.fullPath } })
    }

    if (to.meta.guestOnly && authed) {
        // déjà connecté -> évite de revenir sur /login
        const redirect = to.query.redirect || '/app'
        return next(redirect)
    }

    next()
})
