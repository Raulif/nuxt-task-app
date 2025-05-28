<template>
	<div>
		<AppNavBar />
		<main class="container">
			<slot />
		</main>
	</div>
</template>

<style>
.error {
	color: red;
}
.success {
	color: green;
}
.button-container {
	display: flex;
	justify-content: flex-end;
	gap: 16px;
}

.list-enter-active,
.list-leave-active {
  transition: all 0.5s ease;
}
.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateX(300px);
}
.list-leave-active {
  position: absolute;
	width: 100%;
}
</style>