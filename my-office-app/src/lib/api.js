// src/lib/api.js

const BASE_URL = '/api'; // This assumes your backend is proxied locally

export async function fetchOffices() {
  const res = await fetch(`${BASE_URL}/offices`);
  if (!res.ok) throw new Error('Failed to fetch offices');
  return await res.json();
}

export async function fetchOfficeUsers(officeId) {
  const res = await fetch(`${BASE_URL}/offices/${officeId}/users`);
  if (!res.ok) throw new Error('Failed to fetch users');
  return await res.json();
}

export async function fetchItems(officeId) {
  const res = await fetch(`${BASE_URL}/offices/${officeId}/items`);
  if (!res.ok) throw new Error('Failed to fetch items');
  return await res.json();
}

export async function fetchItemDetails(itemId) {
  const res = await fetch(`${BASE_URL}/items/${itemId}`);
  if (!res.ok) throw new Error('Failed to fetch item');
  return await res.json();
}
