import { writable } from 'svelte/store';
import { browser } from '$app/environment';

interface User {
  id: number;
  email: string;
  username: string;
  role: string;
}

interface AuthState {
  isAuthenticated: boolean;
  user: User | null;
}

const initialAuthState: AuthState = {
  isAuthenticated: false,
  user: null,
};

export const authStore = writable<AuthState>(initialAuthState);

// Initialize store from localStorage if in browser environment
if (browser) {
  const token = localStorage.getItem('token');
  const userString = localStorage.getItem('user');
  if (token && userString) {
    try {
      const user = JSON.parse(userString);
      authStore.set({ isAuthenticated: true, user });
    } catch (e) {
      console.error("Failed to parse user from localStorage", e);
      // Clear invalid data
      localStorage.removeItem('token');
      localStorage.removeItem('user');
    }
  }
}

export function setAuth(token: string, user: User) {
  if (browser) {
    localStorage.setItem('token', token);
    localStorage.setItem('user', JSON.stringify(user));
  }
  authStore.set({ isAuthenticated: true, user });
}

export function clearAuth() {
  if (browser) {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
  }
  authStore.set({ isAuthenticated: false, user: null });
}
