<script lang="ts">
  import { page } from '$app/stores';
  import { onMount } from 'svelte';
  import { goto } from '$app/navigation';
  import { fetchOfficeUsers, fetchItems } from '$lib/api';

  let office: any = null;
  let users: any[] = [];
  let items: any[] = [];
  let loading = true;
  let error: string | null = null;
  let activeTab = 'overview';

  $: officeId = $page.params.id;

  onMount(() => {
    loadOfficeData();
  });

  async function loadOfficeData() {
    try {
      loading = true;
      error = null;
      
      // Load office details, users, and items
      const [usersData, itemsData] = await Promise.all([
        fetchOfficeUsers(parseInt(officeId)),
        fetchItems(parseInt(officeId))
      ]);
      
      users = usersData.users || [];
      items = itemsData.items || [];
      
      // Mock office data since we don't have a specific endpoint
      office = {
        id: parseInt(officeId),
        name: `Office ${officeId}`,
        address: `Address for Office ${officeId}`,
        settings: {
          allowPublicComments: true,
          maxItemsPerUser: 100,
          timezone: 'America/New_York'
        }
      };
    } catch (e: any) {
      console.error('Failed to load office data:', e);
      error = e.message;
    } finally {
      loading = false;
    }
  }

  function goBack() {
    goto('/');
  }
</script>

<div class="min-h-screen bg-base-200">
  <!-- Header -->
  <div class="bg-base-100 shadow-lg">
    <div class="container mx-auto px-4 py-6">
      <div class="flex items-center gap-4">
        <button class="btn btn-ghost" on:click={goBack}>
          <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
          </svg>
          Back
        </button>
        <div>
          <h1 class="text-3xl font-bold text-primary">{office?.name || 'Loading...'}</h1>
          <p class="text-sm opacity-70">{office?.address}</p>
        </div>
      </div>
    </div>
  </div>

  <!-- Content -->
  <div class="container mx-auto px-4 py-8">
    {#if loading}
      <div class="flex justify-center py-8">
        <span class="loading loading-spinner loading-lg"></span>
      </div>
    {:else if error}
      <div class="alert alert-error">
        <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <span>Error loading office data: {error}</span>
      </div>
    {:else}
      <!-- Tabs -->
      <div class="tabs tabs-boxed mb-6">
        <button 
          class="tab {activeTab === 'overview' ? 'tab-active' : ''}" 
          on:click={() => activeTab = 'overview'}
        >
          Overview
        </button>
        <button 
          class="tab {activeTab === 'users' ? 'tab-active' : ''}" 
          on:click={() => activeTab = 'users'}
        >
          Users ({users.length})
        </button>
        <button 
          class="tab {activeTab === 'items' ? 'tab-active' : ''}" 
          on:click={() => activeTab = 'items'}
        >
          Items ({items.length})
        </button>
      </div>

      <!-- Tab Content -->
      {#if activeTab === 'overview'}
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <!-- Office Details -->
          <div class="card bg-base-100 shadow-lg">
            <div class="card-body">
              <h2 class="card-title">Office Information</h2>
              <div class="space-y-4">
                <div>
                  <label class="label">
                    <span class="label-text font-semibold">Name</span>
                  </label>
                  <p>{office.name}</p>
                </div>
                <div>
                  <label class="label">
                    <span class="label-text font-semibold">Address</span>
                  </label>
                  <p>{office.address}</p>
                </div>
                <div>
                  <label class="label">
                    <span class="label-text font-semibold">Timezone</span>
                  </label>
                  <p>{office.settings.timezone}</p>
                </div>
                <div>
                  <label class="label">
                    <span class="label-text font-semibold">Max Items Per User</span>
                  </label>
                  <p>{office.settings.maxItemsPerUser}</p>
                </div>
                <div>
                  <label class="label">
                    <span class="label-text font-semibold">Public Comments</span>
                  </label>
                  <p>{office.settings.allowPublicComments ? 'Allowed' : 'Not Allowed'}</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Stats -->
          <div class="card bg-base-100 shadow-lg">
            <div class="card-body">
              <h2 class="card-title">Statistics</h2>
              <div class="stats stats-vertical">
                <div class="stat">
                  <div class="stat-title">Total Users</div>
                  <div class="stat-value text-primary">{users.length}</div>
                </div>
                <div class="stat">
                  <div class="stat-title">Total Items</div>
                  <div class="stat-value text-secondary">{items.length}</div>
                </div>
                <div class="stat">
                  <div class="stat-title">Active</div>
                  <div class="stat-value text-success">Yes</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      {:else if activeTab === 'users'}
        <div class="card bg-base-100 shadow-lg">
          <div class="card-body">
            <h2 class="card-title">Office Users</h2>
            {#if users.length === 0}
              <p class="text-center py-8 opacity-70">No users found for this office.</p>
            {:else}
              <div class="overflow-x-auto">
                <table class="table table-zebra">
                  <thead>
                    <tr>
                      <th>Name</th>
                      <th>Email</th>
                      <th>Role</th>
                      <th>Created</th>
                    </tr>
                  </thead>
                  <tbody>
                    {#each users as user}
                      <tr>
                        <td>{user.firstName} {user.lastName}</td>
                        <td>{user.email}</td>
                        <td>
                          <span class="badge badge-{user.role === 'OfficeAdmin' ? 'primary' : 'outline'}">
                            {user.role}
                          </span>
                        </td>
                        <td>{new Date(user.createdAt).toLocaleDateString()}</td>
                      </tr>
                    {/each}
                  </tbody>
                </table>
              </div>
            {/if}
          </div>
        </div>
      {:else if activeTab === 'items'}
        <div class="card bg-base-100 shadow-lg">
          <div class="card-body">
            <h2 class="card-title">Office Items</h2>
            {#if items.length === 0}
              <p class="text-center py-8 opacity-70">No items found for this office.</p>
            {:else}
              <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {#each items as item}
                  <div class="card bg-base-200">
                    <div class="card-body">
                      <h3 class="card-title text-lg">{item.name}</h3>
                      <p class="text-sm opacity-70">{item.description}</p>
                      <div class="flex flex-wrap gap-2 mt-2">
                        <span class="badge badge-outline">{item.category}</span>
                        <span class="badge badge-{item.status === 'available' ? 'success' : 'warning'}">
                          {item.status}
                        </span>
                      </div>
                    </div>
                  </div>
                {/each}
              </div>
            {/if}
          </div>
        </div>
      {/if}
    {/if}
  </div>
</div> 