<script setup lang="ts">
const { signIn, data, signOut } = useAuth()

const username = ref('')
const password = ref('')
</script>

<template>
  <pre>{{ JSON.stringify(data, null, 2) }}</pre>
  <form @submit.prevent="signIn('credentials', { username, password })">
    <input v-model="username" type="text">
    <input v-model="password" type="password">
    <button type="submit">submit</button>
  </form>
  <button @click="signOut()">sign out</button>
</template>
