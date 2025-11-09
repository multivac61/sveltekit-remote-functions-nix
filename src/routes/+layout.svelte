<script lang="ts">
	import favicon from '$lib/assets/favicon.svg';
	import '../app.css';

	let { children } = $props();
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
</svelte:head>

<div class="layout">
	<header>
		<a href="/">🔥 Svelte Tricks</a>
		<a href="/admin" class="secondary">⚙️ Admin</a>
	</header>

	<main>
		{@render children()}
	</main>

	<footer>{new Date().getFullYear()} &copy; Svelte Tricks</footer>
</div>
