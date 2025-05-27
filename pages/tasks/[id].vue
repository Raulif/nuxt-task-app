<script lang="ts" setup>
import { FetchError } from 'ofetch'

const errorMessage = ref('')
const updating = ref(false)
const route = useRoute()
const { data: task, error, status } = await useFetch(`/api/tasks/${route.params.id}`, {
  lazy: true
})
const title = ref(task.value?.title || '')
const done = ref(task.value?.done || false)
const success = ref(false)
async function onSubmit() {
  success.value = false
  if ((title.value === task.value?.title && done.value === task.value?.done)) {
    errorMessage.value = 'Nothing new to upate'
    return
  }

  try {
    updating.value = true
    const updated = await $fetch(`/api/tasks/${task.value?.id}`, {
      method: 'PUT',
      body: {
        title: title.value || task.value?.title,
        done: done.value,
        id: task.value?.id
      }
    })

    if (updated.id) {
      success.value = true
    }
  } catch (e) {
    const error = e as FetchError
    errorMessage.value = error.statusMessage || 'Unknow error occured when updating Task'

  }
  updating.value = false
}
const nothingChanged = computed(() => title.value === task.value?.title && done.value === task.value?.done)

</script>

<template>

  <article
    v-if="status === 'pending'"
    aria-busy="true"
  />
  <article
    class="error"
    v-else-if="error"
  >
    {{ error.statusMessage }}
  </article>
  <div v-else-if="task">
    <h3>
      {{ task.title }}
    </h3>

    <form @submit.prevent="onSubmit">
      <label>
        Edit Title
        <input
          :disabled="updating"
          name="title"
          v-model="title"
        />
      </label>
      <label>
        Done
        <input
          :disabled="updating"
          type="checkbox"
          name="done"
          v-model="done"
        />
      </label>
      <article
        v-if="updating"
        aria-busy="true"
      />
      <div v-else>
        <article
          class="error"
          v-if="errorMessage"
        >
          {{ errorMessage }}
        </article>
        <div class="button-container">
          <button :disabled="nothingChanged">Update</button>
        </div>
      </div>
    </form>
    <article
      class="success"
      v-if="success"
    >
      Task updated correctly
    </article>
  </div>
</template>