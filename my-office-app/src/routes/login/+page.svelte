<script>
	import { token, user } from '$lib/stores';
	import { fetchCurrentUser } from '$lib/api';
	import { goto } from '$app/navigation';

	let inputToken = '';
	let error = '';

	const login = async () => {
		token.set(inputToken);
		try {
			const data = await fetchCurrentUser();
			user.set(data);
			goto('/');
		} catch {
			token.set('');
			error = 'Login failed';
		}
	};
</script>

<main class="mx-auto max-w-md p-6">
	<h1 class="mb-4 text-2xl font-bold">Login</h1>
	{#if error}<p class="mb-2 text-red-600">{error}</p>{/if}
	<input class="mb-4 w-full border p-2" placeholder="Token" bind:value={inputToken} />
	<button class="bg-blue-600 px-4 py-2 text-white" on:click={login}>Login</button>
</main>
