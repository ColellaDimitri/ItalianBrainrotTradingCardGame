<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const username = ref('')
const password = ref('')
const router = useRouter()
const route = useRoute()

async function login() {
  // TODO: appeler l’API, vérifier les identifiants, récupérer un token
  localStorage.setItem('token', 'demo123')

  // Si on venait d’une page protégée, on y retourne
  const redirect = route.query.redirect || '/app'
  router.replace(redirect)
}
</script>
