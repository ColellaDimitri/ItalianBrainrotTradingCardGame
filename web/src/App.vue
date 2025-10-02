<template>
  <main class="container">
    <h1>Vue + Node + Postgres</h1>
    <form @submit.prevent="add" class="row">
      <input v-model="title" placeholder="Nouveau todo" />
      <button>Ajouter</button>
    </form>
    <ul>
      <li v-for="t in todos" :key="t.id">{{ t.nom }} <small v-if="t.done">(fait)</small></li>
    </ul>
  </main>
</template>

<script setup>
import { ref, onMounted } from 'vue'

import { useRouter } from 'vue-router'
const router = useRouter()


const todos = ref([])
const title = ref('')

const apiBaseUrl = (import.meta.env.VITE_API_BASE_URL || '/api').replace(/\/$/, '')


const load = async () => {
  const r = await fetch(`${apiBaseUrl}/api/v1/cards`)
  todos.value = await r.json()
}

const add = async () => {
  if (!title.value) return
  await fetch(`${apiBaseUrl}/api/v1/cards`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ title: title.value })
  })
  title.value = ''
  await load()
}

function logout() {
  localStorage.removeItem('token')
  router.replace('/login')
}

onMounted(load)
</script>

<style scoped>
.container { max-width: 720px; margin: 40px auto; font-family: system-ui; }
.row { margin: 16px 0; display: flex; gap: 8px; }
input { flex: 1; padding: 8px; }
</style>