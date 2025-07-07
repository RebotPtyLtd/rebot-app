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
      console.log('+layout.svelte: authStore updated. isAuthenticated:', isAuthenticated, 'User:', loggedInUser);
      if (browser && !state.isAuthenticated && $page.url.pathname !== '/login') {
        console.log('+layout.svelte: Redirecting to login.');
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
    <header class="navbar bg-primary text-primary-content p-4">
      <div class="container mx-auto flex justify-between items-center">
        <h1 class="text-xl font-bold">My Office App</h1>
        <nav class="flex items-center space-x-4">
          {#if isAuthenticated && loggedInUser}
            <span class="text-sm">Welcome, {loggedInUser.username || loggedInUser.email}!</span>
            <button onclick={handleLogout} class="btn btn-primary btn-sm">
              Logout
            </button>
          {/if}
        </nav>
      </div>
    </header>
    <main class="flex-grow p-4 container mx-auto">
      {@render children()}
    </main>
    <footer class="footer footer-center p-4 bg-primary text-primary-content">
      <aside>
        <p>&copy; 2025 My Office App. All rights reserved.</p>
      </aside>
    </footer>
  </div>
{:else}
  <!-- Optionally show a loading spinner or nothing while redirecting -->
  <div class="flex min-h-screen items-center justify-center bg-base-100">
    <p>Redirecting to login...</p>
  </div>
{/if}
