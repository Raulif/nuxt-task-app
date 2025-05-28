<script lang="ts" setup>
  import { AppDeleteButton } from '#components';

  const {
    data: tasks,
    error,
    status,
  } = await useFetch('/api/tasks', { lazy: true });

  const onDelete = (id: number) => {
    const atIndex = tasks.value?.findIndex((t) => t.id === id);

    if (typeof atIndex === 'number' && atIndex > -1) {
      tasks.value?.splice(atIndex, 1);
    }
  };
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
  <div v-else>
    <TransitionGroup
      name="list"
      tag="div"
    >
      <article
        v-for="task in tasks"
        :key="task.id"
      >
        {{ task.title }}
        <div class="button-container">
          <AppDeleteButton
            :id="task.id"
            :onDelete="onDelete"
          />
          <NuxtLink
            role="button"
            :to="{ name: 'tasks-id', params: { id: task.id } }"
          >
            Go to
          </NuxtLink>
        </div>
      </article>
    </TransitionGroup>
  </div>
</template>
