import { getToken } from './auth';

const BASE_URL = '/api';

async function authenticatedFetch(url: string, options?: RequestInit) {
  const token = getToken();
  const headers: HeadersInit = {
    'Content-Type': 'application/json',
    ...(options?.headers || {}),
  };

  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }

  const res = await fetch(url, { ...options, headers });

  if (!res.ok) {
    // Handle unauthorized or forbidden responses globally if needed
    if (res.status === 401 || res.status === 403) {
      // Optionally redirect to login or show a message
      console.error('Authentication error', res.status);
    }
    throw new Error(`Failed to fetch: ${res.statusText}`);
  }
  return res;
}

export async function fetchOffices() {
  const res = await authenticatedFetch(`${BASE_URL}/offices`);
  return await res.json();
}

export async function fetchOfficeUsers(officeId: number) {
  const res = await authenticatedFetch(`${BASE_URL}/offices/${officeId}/users`);
  return await res.json();
}

export async function fetchItems(officeId: number) {
  const res = await authenticatedFetch(`${BASE_URL}/offices/${officeId}/items`);
  return await res.json();
}

export async function fetchItemDetails(itemId: number) {
  const res = await authenticatedFetch(`${BASE_URL}/items/${itemId}`);
  return await res.json();
}

// USER MANAGEMENT
export interface UserPayload {
  username: string;
  email: string;
  role: 'User' | 'Admin' | 'OfficeAdmin' | string;
  officeId: number;
  firstName: string;
  lastName: string;
}

// Call to the backend API to get all users

export async function getUsers() {
  const res = await authenticatedFetch(`${BASE_URL}/users`);
  return await res.json();
}

// Call to the backend API to create user

export async function createUser(user: UserPayload) {
  const res = await authenticatedFetch(`${BASE_URL}/users`, {
      method: 'POST',
      body: JSON.stringify(user)
  });
  return await res.json();
}

// Call to the backend API to update user

export async function updateUser(id: number, user: UserPayload) {
  const res = await authenticatedFetch(`${BASE_URL}/users/${id}`, {
    method: 'PUT',
    body: JSON.stringify(user)
  });
  return await res.json();
}

// Call to the backend API to delete user

export async function deleteUser(id: number) {
  const res = await authenticatedFetch(`${BASE_URL}/users/${id}`, {
    method: 'DELETE'
  });

  if (!res.ok){
    throw new Error(`Failed to delete user: ${res.status}`);
  }

  if (res.status !== 204){
    return await res.json();
  }
  return;
}