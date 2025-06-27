<script>
	import { onMount } from 'svelte';
	import { page } from '$app/stores';
	import { fetchItems, addItem, fetchComments, addComment } from '$lib/api';
	import { user } from '$lib/stores';
	import { goto } from '$app/navigation';

	let items = [];
	let comments = {};
	let commentInputs = {};
	let newTitle = '';
	let newDescription = '';
	let error = null;

	$: officeId = +$page.params.id;

	const isAdmin = () => {
		return (
			$user &&
			($user.role === 'Admin' || ($user.role === 'OfficeAdmin' && $user.officeId === officeId))
		);
	};

	async function loadComments(id) {
		if (comments[id]) return;
		try {
			const data = await fetchComments(id);
			comments[id] = data.comments;
		} catch {
			comments[id] = [];
		}
	}

	onMount(async () => {
		if (!$user) {
			goto('/login');
			return;
		}
		try {
			const data = await fetchItems(officeId);
			items = data.items;
		} catch (err) {
			error = err.message;
		}
	});

	const createItem = async () => {
		try {
			const item = await addItem({
				title: newTitle,
				description: newDescription,
				officeId,
				createdBy: $user.id
			});
			items = [...items, item];
			newTitle = '';
			newDescription = '';
		} catch {
			alert('Failed to create item');
		}
	};

	const createComment = async (id) => {
		try {
			const comment = await addComment({
				itemId: id,
				userId: $user.id,
				content: commentInputs[id]
			});
			comments[id] = [...(comments[id] || []), comment];
			commentInputs[id] = '';
		} catch {
			alert('Failed to create comment');
		}
	};
</script>

<main class="p-6">
	<h1 class="mb-4 text-2xl font-bold">Items for Office {officeId}</h1>
	{#if error}
		<p class="text-red-600">{error}</p>
	{:else if items.length === 0}
		<p>Loading...</p>
	{:else}
		<ul class="space-y-4">
			{#each items as item (item.id)}
				<li class="rounded border p-4">
					<div class="font-semibold">{item.title}</div>
					<div class="mb-2 text-sm text-gray-600">{item.description}</div>
					<button class="text-sm text-blue-600" on:click={() => loadComments(item.id)}
						>Load comments</button
					>
					{#if comments[item.id]}
						<ul class="ml-4 mt-2 space-y-1">
							{#each comments[item.id] as c (c.id)}
								<li class="text-sm">{c.content}</li>
							{/each}
						</ul>
						{#if isAdmin()}
							<div class="mt-2 flex gap-2">
								<input
									class="flex-1 border p-1"
									placeholder="Comment"
									bind:value={commentInputs[item.id]}
								/>
								<button class="bg-blue-600 px-2 text-white" on:click={() => createComment(item.id)}
									>Add</button
								>
							</div>
						{/if}
					{/if}
				</li>
			{/each}
		</ul>
	{/if}

	{#if isAdmin()}
		<div class="mt-6">
			<h2 class="mb-2 font-semibold">Add Item</h2>
			<input class="mr-2 border p-1" placeholder="Title" bind:value={newTitle} />
			<input class="mr-2 border p-1" placeholder="Description" bind:value={newDescription} />
			<button class="bg-blue-600 px-2 py-1 text-white" on:click={createItem}>Add</button>
		</div>
	{/if}
</main>
