<script>
	import '../app.css';
	import { onMount } from 'svelte';
	import { token, user } from '$lib/stores';
	import { fetchCurrentUser } from '$lib/api';
	import { goto } from '$app/navigation';

	onMount(async () => {
		if ($token && !$user) {
			try {
				const data = await fetchCurrentUser();
				user.set(data);
			} catch {
				token.set('');
			}
		}
	});

	const logout = () => {
		token.set('');
		user.set(null);
		goto('/login');
	};
</script>

<nav class="flex gap-4 bg-gray-100 p-4">
	{#if $user}
		<a href="/">Offices</a>
		<a href="/users">Users</a>
		<button on:click={logout} class="text-blue-600">Logout</button>
	{/if}
</nav>

<slot />
