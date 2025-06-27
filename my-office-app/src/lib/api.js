// src/lib/api.js
import { get } from 'svelte/store';
import { token } from '$lib/stores';

const BASE_URL = '/api';

function authHeaders(extra = {}) {
	const t = get(token);
	return t ? { ...extra, Authorization: `Bearer ${t}` } : extra;
}

export async function fetchOffices() {
	const res = await fetch(`${BASE_URL}/offices`, { headers: authHeaders() });
	if (!res.ok) throw new Error('Failed to fetch offices');
	return await res.json();
}

export async function fetchUsers() {
	const res = await fetch(`${BASE_URL}/users`, { headers: authHeaders() });
	if (!res.ok) throw new Error('Failed to fetch users');
	return await res.json();
}

export async function fetchOfficeUsers(officeId) {
	const res = await fetch(`${BASE_URL}/offices/${officeId}/users`, { headers: authHeaders() });
	if (!res.ok) throw new Error('Failed to fetch users');
	return await res.json();
}

export async function fetchItems(officeId) {
	const res = await fetch(`${BASE_URL}/offices/${officeId}/items`, { headers: authHeaders() });
	if (!res.ok) throw new Error('Failed to fetch items');
	return await res.json();
}

export async function fetchItemDetails(itemId) {
	const res = await fetch(`${BASE_URL}/items/${itemId}`, { headers: authHeaders() });
	if (!res.ok) throw new Error('Failed to fetch item');
	return await res.json();
}

export async function fetchComments(itemId) {
	const res = await fetch(`${BASE_URL}/items/${itemId}/comments`, { headers: authHeaders() });
	if (!res.ok) throw new Error('Failed to fetch comments');
	return await res.json();
}

export async function fetchCurrentUser() {
	const res = await fetch(`${BASE_URL}/auth/me`, { headers: authHeaders() });
	if (!res.ok) throw new Error('Failed to fetch current user');
	return await res.json();
}

export async function addItem(item) {
	const res = await fetch(`${BASE_URL}/items`, {
		method: 'POST',
		headers: authHeaders({ 'Content-Type': 'application/json' }),
		body: JSON.stringify(item)
	});
	if (!res.ok) throw new Error('Failed to create item');
	return await res.json();
}

export async function updateItem(id, item) {
	const res = await fetch(`${BASE_URL}/items/${id}`, {
		method: 'PUT',
		headers: authHeaders({ 'Content-Type': 'application/json' }),
		body: JSON.stringify(item)
	});
	if (!res.ok) throw new Error('Failed to update item');
	return await res.json();
}

export async function addComment(comment) {
	const res = await fetch(`${BASE_URL}/comments`, {
		method: 'POST',
		headers: authHeaders({ 'Content-Type': 'application/json' }),
		body: JSON.stringify(comment)
	});
	if (!res.ok) throw new Error('Failed to create comment');
	return await res.json();
}

export async function updateComment(id, comment) {
	const res = await fetch(`${BASE_URL}/comments/${id}`, {
		method: 'PUT',
		headers: authHeaders({ 'Content-Type': 'application/json' }),
		body: JSON.stringify(comment)
	});
	if (!res.ok) throw new Error('Failed to update comment');
	return await res.json();
}
