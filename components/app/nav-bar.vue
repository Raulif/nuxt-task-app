<template>
  <nav class="container">
    <ul>
      <li>
        <NuxtLink to="/"><strong>Task App</strong></NuxtLink>
      </li>
    </ul>
    <ul>
      <li>
        <NuxtLink :to="{ name: 'create' }">Crate Task</NuxtLink>
      </li>
    </ul>
  </nav>
</template>
