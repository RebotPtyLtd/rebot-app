<script lang="ts">
  import '../app.css';
  import { goto } from '$app/navigation';
  import { browser } from '$app/environment';
  import { page } from '$app/stores';
  import { authStore } from '$lib/stores/authStore';
  import { logout } from '$lib/auth';

  let { children } = $props();
  let isAuthenticated = $state(false);
  let loggedInUser: { id: number; email: string; username: string; role: string } | null = $state(null);

  // Subscribe to the authStore
  $effect(() => {
    authStore.subscribe(state => {
      isAuthenticated = state.isAuthenticated;
      loggedInUser = state.user;
      if (browser && !state.isAuthenticated && $page.url.pathname !== '/login') {
        goto('/login');
      }
    });
  });

  function handleLogout() {
    logout();
    goto('/login');
  }

</script>




{#if isAuthenticated || $page.url.pathname === '/login'}
  <div class="min-h-screen flex flex-col">
    <header class="bg-indigo-600 text-white p-4 flex justify-between items-center">
      <h1 class="text-xl font-bold">My Office App</h1>
      <nav class="flex items-center space-x-4">
        {#if isAuthenticated && loggedInUser}
          <span class="text-white text-sm">Welcome, {loggedInUser.username || loggedInUser.email}!</span>
          <button onclick={handleLogout} class="bg-indigo-700 hover:bg-indigo-800 text-white font-bold py-2 px-4 rounded">
            Logout
          </button>
        {/if}
      </nav>
    </header>
    <main class="flex-grow">
      {@render children()}
    </main>
  </div>
{:else}
  <!-- Optionally show a loading spinner or nothing while redirecting -->
  <div class="flex min-h-screen items-center justify-center bg-gray-100">
    <p>Redirecting to login...</p>
  </div>
{/if}


