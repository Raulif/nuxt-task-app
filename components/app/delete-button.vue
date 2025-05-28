<script lang="ts" setup>
const {id, onDelete} = defineProps({id: Number, onDelete: Function})

async function onSubmit() {
  const result = await $fetch(`/api/tasks/${id}`, {
    method: 'DELETE'
  })

  if (result.length && result[0].id === id) {
    onDelete && onDelete(id)
  }
} 
</script>

<template>
  <form @submit.prevent="onSubmit">
    <button :disabled="!id" class="outline">Delete</button>
  </form>
</template>