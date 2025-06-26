<script>
  import { onMount } from 'svelte';
  import { fetchOffices } from '$lib/api';

  let offices = [];
  let error = null;

  onMount(async () => {
    try {
      const data = await fetchOffices();
      offices = data.offices;
    } catch (err) {
      error = err.message;
    }
  });
</script>

<main class="p-6">
  <h1 class="text-2xl font-bold mb-4">Offices</h1>

  {#if error}
    <p class="text-red-600">{error}</p>
  {:else if offices.length === 0}
    <p>Loading...</p>
  {:else}
    <ul class="space-y-4">
      {#each offices as office}
        <li class="p-4 bg-white rounded-xl shadow">
          <h2 class="text-lg font-semibold">{office.name}</h2>
          <p class="text-sm text-gray-600">{office.address}</p>
          <p class="text-xs text-gray-400">Max items per user: {office.settings.maxItemsPerUser}</p>
        </li>
      {/each}
    </ul>
  {/if}
</main>
