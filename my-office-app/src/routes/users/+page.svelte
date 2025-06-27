<script>
	import { onMount } from 'svelte';
	import { fetchUsers } from '$lib/api';
	import { user } from '$lib/stores';
	import { goto } from '$app/navigation';

	let users = [];
	let error = null;

	onMount(async () => {
		if (!$user) {
			goto('/login');
			return;
		}
		try {
			const data = await fetchUsers();
			users = data.users;
			if ($user.role === 'OfficeAdmin') {
				users = users.filter((u) => u.officeId === $user.officeId);
			}
		} catch (err) {
			error = err.message;
		}
	});
</script>

<main class="p-6">
	<h1 class="mb-4 text-2xl font-bold">Users</h1>

	{#if error}
		<p class="text-red-600">{error}</p>
	{:else if users.length === 0}
		<p>Loading...</p>
	{:else}
		<ul class="space-y-2">
			{#each users as u (u.id)}
				<li class="rounded border p-2">{u.username} - {u.role} (Office {u.officeId})</li>
			{/each}
		</ul>
	{/if}
</main>
