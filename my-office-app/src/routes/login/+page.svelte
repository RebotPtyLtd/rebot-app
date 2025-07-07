<script lang="ts">
  import { goto } from '$app/navigation';
  import { browser } from '$app/environment';
  import { setAuth } from '$lib/auth';
  import { authStore } from '$lib/stores/authStore';
  import { onMount } from 'svelte';

  let email = '';
  let password = '';
  let error: string | null = null;

  // Redirect authenticated users away from login page
  onMount(() => {
    if (browser) {
      const unsubscribe = authStore.subscribe(state => {
        if (state.isAuthenticated) {
          goto('/');
        }
      });
      // Clean up subscription on unmount
      return unsubscribe;
    }
  });

  async function handleLogin() {
    error = null;
    console.log('Attempting to log in with email:', email);
    try {
      const url = '/api/auth/login';
      console.log('Fetching URL:', url);
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      });

      console.log('Response status:', response.status);

      if (!response.ok) {
        const errText = await response.text(); // Get raw text for debugging
        console.error('Login failed response:', response.status, errText);
        try {
          const errData = JSON.parse(errText);
          throw new Error(errData.message || `Login failed: ${response.status} ${response.statusText}`);
        } catch (parseError) {
          throw new Error(`Login failed: ${response.status} ${response.statusText}. Response was not valid JSON: ${errText}`);
        }
      }

      const data = await response.json();
      console.log('Login successful, received data:', data);
      if (browser) {
        setAuth(data.token, data.user);
      }
      goto('/');
    } catch (e: any) {
      console.error('Caught error during login:', e);
      error = e.message;
    }
  }
</script>

<div class="hero min-h-screen bg-base-100">
  <div class="hero-content flex-col lg:flex-row-reverse">
    <div class="text-center lg:text-left">
      <h1 class="text-5xl font-bold text-primary">Login now!</h1>
      <p class="py-6">Access your office management portal.</p>
    </div>
    <div class="card shrink-0 w-full max-w-sm shadow-2xl bg-base-100">
      <form on:submit|preventDefault={handleLogin} class="card-body">
        <h2 class="text-2xl font-bold text-center text-primary mb-6">Login</h2>
        <div class="form-control">
          <label for="email" class="label">
            <span class="label-text">Email</span>
          </label>
          <input
            type="email"
            id="email"
            placeholder="email"
            class="input input-bordered"
            bind:value={email}
            required
          />
        </div>
        <div class="form-control">
          <label for="password" class="label">
            <span class="label-text">Password</span>
          </label>
          <input
            type="password"
            id="password"
            placeholder="password"
            class="input input-bordered"
            bind:value={password}
            required
          />
        </div>
        {#if error}
          <p class="text-error text-sm mt-2">{error}</p>
        {/if}
        <div class="form-control mt-6">
          <button type="submit" class="btn btn-primary">Login</button>
        </div>
      </form>
    </div>
  </div>
</div>
