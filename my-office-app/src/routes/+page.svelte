<script lang="ts">
  import { onMount } from 'svelte';
  import { goto } from '$app/navigation';
  import { browser } from '$app/environment';
  import { authStore } from '$lib/stores/authStore';
  import { logout } from '$lib/auth';
  import { fetchOffices } from '$lib/api';

  let offices: any[] = [];
  let loading = true;
  let error: string | null = null;
  let user: any = null;

  onMount(() => {
    if (browser) {
      const unsubscribe = authStore.subscribe(state => {
        if (!state.isAuthenticated) {
          goto('/login');
        } else {
          user = state.user;
          loadOffices();
        }
      });
      return unsubscribe;
    }
  });

  async function loadOffices() {
    try {
      loading = true;
      error = null;
      const data = await fetchOffices();
      offices = data.offices || [];
    } catch (e: any) {
      console.error('Failed to load offices:', e);
      error = e.message;
    } finally {
      loading = false;
    }
  }

  function handleLogout() {
    logout();
    goto('/login');
  }

  function viewOffice(officeId: number) {
    goto(`/offices/${officeId}`);
  }
</script>

<div class="min-h-screen bg-base-200">
  <!-- Navigation -->
  <div class="navbar bg-base-100 shadow-lg">
    <div class="navbar-start">
      <div class="dropdown">
        <div tabindex="0" role="button" class="btn btn-ghost lg:hidden">
          <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h8m-8 6h16" />
          </svg>
        </div>
        <ul tabindex="0" class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52">
          <li><a href="/">Dashboard</a></li>
          <li><a href="/offices">Offices</a></li>
          <li><a href="/users">Users</a></li>
        </ul>
      </div>
      <a class="btn btn-ghost text-xl">Office Manager</a>
    </div>
    <div class="navbar-center hidden lg:flex">
      <ul class="menu menu-horizontal px-1">
        <li><a href="/">Dashboard</a></li>
        <li><a href="/offices">Offices</a></li>
        <li><a href="/users">Users</a></li>
      </ul>
    </div>
    <div class="navbar-end">
      {#if user}
        <div class="dropdown dropdown-end">
          <div tabindex="0" role="button" class="btn btn-ghost btn-circle avatar">
            <div class="w-10 rounded-full">
              <div class="bg-primary text-primary-content rounded-full w-10 h-10 flex items-center justify-center">
                {user.username.charAt(0).toUpperCase()}
              </div>
            </div>
          </div>
          <ul tabindex="0" class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52">
            <li><span class="text-sm opacity-70">{user.email}</span></li>
            <li><span class="text-sm opacity-70">Role: {user.role}</span></li>
            <li><hr /></li>
            <li><button on:click={handleLogout}>Logout</button></li>
          </ul>
        </div>
      {/if}
    </div>
  </div>

  <!-- Main Content -->
  <div class="container mx-auto px-4 py-8">
    <div class="mb-8">
      <h1 class="text-4xl font-bold text-primary mb-4">Welcome, {user?.username || 'User'}!</h1>
      <p class="text-lg opacity-70">Manage your office locations and resources.</p>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
      <div class="stat bg-base-100 shadow rounded-lg">
        <div class="stat-title">Total Offices</div>
        <div class="stat-value text-primary">{offices.length}</div>
        <div class="stat-desc">Active office locations</div>
      </div>
      <div class="stat bg-base-100 shadow rounded-lg">
        <div class="stat-title">Your Role</div>
        <div class="stat-value text-secondary">{user?.role || 'User'}</div>
        <div class="stat-desc">Current permissions</div>
      </div>
      <div class="stat bg-base-100 shadow rounded-lg">
        <div class="stat-title">Status</div>
        <div class="stat-value text-success">Active</div>
        <div class="stat-desc">System operational</div>
      </div>
    </div>

    <!-- Offices Section -->
    <div class="bg-base-100 shadow rounded-lg p-6">
      <div class="flex justify-between items-center mb-6">
        <h2 class="text-2xl font-bold">Office Locations</h2>
        <button class="btn btn-primary" on:click={() => goto('/offices/new')}>
          Add Office
        </button>
      </div>

      {#if loading}
        <div class="flex justify-center py-8">
          <span class="loading loading-spinner loading-lg"></span>
        </div>
      {:else if error}
        <div class="alert alert-error">
          <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <span>Error loading offices: {error}</span>
        </div>
      {:else if offices.length === 0}
        <div class="text-center py-8">
          <p class="text-lg opacity-70 mb-4">No offices found.</p>
          <button class="btn btn-primary" on:click={() => goto('/offices/new')}>
            Create First Office
          </button>
        </div>
      {:else}
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {#each offices as office}
            <div class="card bg-base-200 shadow-lg hover:shadow-xl transition-shadow">
              <div class="card-body">
                <h3 class="card-title text-lg">{office.name}</h3>
                <p class="text-sm opacity-70">{office.address}</p>
                <div class="flex flex-wrap gap-2 mt-4">
                  <div class="badge badge-outline">
                    Max Items: {office.settings.maxItemsPerUser}
                  </div>
                  <div class="badge badge-outline">
                    {office.settings.timezone}
                  </div>
                  {#if office.settings.allowPublicComments}
                    <div class="badge badge-success">Public Comments</div>
                  {/if}
                </div>
                <div class="card-actions justify-end mt-4">
                  <button 
                    class="btn btn-primary btn-sm" 
                    on:click={() => viewOffice(office.id)}
                  >
                    View Details
                  </button>
                </div>
              </div>
            </div>
          {/each}
        </div>
      {/if}
    </div>
  </div>
</div>
