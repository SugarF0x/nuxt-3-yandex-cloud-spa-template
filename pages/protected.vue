<script setup lang="ts">
definePageMeta({ middleware: ['auth'] })
const { signOut } = useAuth()
</script>

<template>
  <h1>protected page</h1>
  <button @click="signOut()">sign out</button>
</template>
