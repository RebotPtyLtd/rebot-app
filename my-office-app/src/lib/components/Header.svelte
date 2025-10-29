<script lang="ts">
	import { authStore } from '$lib/stores/authStore';
	import { clearAuth } from '$lib/auth';
	import { goto } from '$app/navigation';

	function handleLogout() {
		clearAuth();
		goto('/login');
	}
</script>

<header class="bg-base-200 shadow-md">
	<div class="container mx-auto navbar">
		<div class="flex-1">
			<a href="/" class="btn btn-ghost normal-case text-xl text-primary">MyOffice</a>
		</div>
		<div class="flex-none">
			{#if $authStore.isAuthenticated}
				<ul class="menu menu-horizontal px-1">
					<li><a href="/offices">Offices</a></li>
					<li>
						<button on:click={handleLogout} class="btn btn-ghost">Logout</button>
					</li>
				</ul>
			{/if}
		</div>
	</div>
</header>
