<script lang="ts">
  import { goto } from '$app/navigation';
  import { browser } from '$app/environment';
  import { setAuth } from '$lib/auth';

  let email = '';
  let password = '';
  let error: string | null = null;

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

<div class="flex min-h-screen items-center justify-center bg-gray-100">
  <div class="w-full max-w-md rounded-lg bg-white p-8 shadow-md">
    <h2 class="mb-6 text-center text-2xl font-bold text-gray-800">Login</h2>
    <form on:submit|preventDefault={handleLogin}>
      <div class="mb-4">
        <label for="email" class="mb-2 block text-sm font-medium text-gray-700"
          >Email</label
        >
        <input
          type="email"
          id="email"
          class="w-full rounded-md border border-gray-300 px-3 py-2 focus:border-indigo-500 focus:outline-none"
          bind:value={email}
          required
        />
      </div>
      <div class="mb-6">
        <label
          for="password"
          class="mb-2 block text-sm font-medium text-gray-700"
          >Password</label
        >
        <input
          type="password"
          id="password"
          class="w-full rounded-md border border-gray-300 px-3 py-2 focus:border-indigo-500 focus:outline-none"
          bind:value={password}
          required
        />
      </div>
      {#if error}
        <p class="mb-4 text-red-500">{error}</p>
      {/if}
      <button
        type="submit"
        class="w-full rounded-md bg-indigo-600 px-4 py-2 text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
        >Login</button
      >
    </form>
  </div>
</div>
