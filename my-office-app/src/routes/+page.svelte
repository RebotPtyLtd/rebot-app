<script lang="ts">
  import { fetchOffices } from '$lib/api';
  import { authStore } from '$lib/stores/authStore';

  let offices: any[] = $state([]);
  let error: string | null = $state(null);

  // Reactive statement to fetch offices when authenticated
  $effect(async () => {
    console.log('+page.svelte: $authStore.isAuthenticated:', $authStore.isAuthenticated);
    if ($authStore.isAuthenticated) {
      console.log('+page.svelte: Authenticated, fetching offices...');
      try {
        const data = await fetchOffices();
        offices = data.offices;
        error = null; // Clear any previous errors on successful fetch
      } catch (err: any) {
        error = err.message;
        console.error('+page.svelte: Error fetching offices:', error);
      }
    } else {
      offices = []; // Clear offices if not authenticated
      error = null; // Clear error if not authenticated
      console.log('+page.svelte: Not authenticated, clearing offices and error.');
    }
  });
</script>

<div class="container mx-auto p-4">
  <h1 class="text-3xl font-bold mb-6 text-primary">Offices</h1>

  {#if error}
    <div role="alert" class="alert alert-error">
      <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
      <span>{error}</span>
    </div>
  {:else if offices.length === 0 && $authStore.isAuthenticated}
    <div class="flex items-center justify-center space-x-2">
      <span class="loading loading-spinner loading-lg text-primary"></span>
      <p class="text-lg text-neutral">Loading offices...</p>
    </div>
  {:else if offices.length === 0 && !$authStore.isAuthenticated}
    <div role="alert" class="alert alert-info">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="stroke-current shrink-0 w-6 h-6"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
      <span>Please log in to view offices.</span>
    </div>
  {:else}
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {#each offices as office}
        <div class="card bg-base-100 shadow-xl image-full">
          <figure><img src="https://daisyui.com/images/stock/photo-1606107557195-0e29a4b5b4aa.jpg" alt="Office" /></figure>
          <div class="card-body">
            <h2 class="card-title text-primary-content">{office.name}</h2>
            <p class="text-primary-content">{office.address}</p>
            <p class="text-primary-content text-sm">Max items per user: {office.settings.maxItemsPerUser}</p>
            <div class="card-actions justify-end">
              <button class="btn btn-primary">View Details</button>
            </div>
          </div>
        </div>
      {/each}
    </div>
  {/if}
</div>
