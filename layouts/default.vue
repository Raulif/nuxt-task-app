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
}
</style>