<script>
	import { onMount } from 'svelte';
	import { fetchOffices } from '$lib/api';
	import { user } from '$lib/stores';
	import { goto } from '$app/navigation';

	let offices = [];
	let error = null;

	onMount(async () => {
		if (!$user) {
			goto('/login');
			return;
		}
		try {
			const data = await fetchOffices();
			offices = data.offices;
			if ($user.role === 'OfficeAdmin') {
				offices = offices.filter((o) => o.id === $user.officeId);
			}
		} catch (err) {
			error = err.message;
		}
	});
</script>

<main class="p-6">
	<h1 class="mb-4 text-2xl font-bold">Offices</h1>

	{#if error}
		<p class="text-red-600">{error}</p>
	{:else if offices.length === 0}
		<p>Loading...</p>
	{:else}
		<ul class="space-y-4">
			{#each offices as office (office.id)}
				<li class="rounded-xl bg-white p-4 shadow">
					<a href={`/offices/${office.id}/items`} class="text-lg font-semibold">{office.name}</a>
					<p class="text-sm text-gray-600">{office.address}</p>
					<p class="text-xs text-gray-400">Max items per user: {office.settings.maxItemsPerUser}</p>
				</li>
			{/each}
		</ul>
	{/if}
</main>
