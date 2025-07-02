import { browser } from '$app/environment';
import { authStore, setAuth as setAuthStore, clearAuth } from './stores/authStore';

export function getToken(): string | null {
  if (browser) {
    return localStorage.getItem('token');
  }
  return null;
}

export function isAuthenticated(): boolean {
  let authenticated = false;
  authStore.subscribe(state => {
    authenticated = state.isAuthenticated;
  })(); // Immediately invoke to get current value
  return authenticated;
}

export function logout(): void {
  clearAuth();
}

// Add role to the payload
export function setAuth(token: string, user: { id: number; email: string; username: string; role: string; OfficeId: number }) {
  setAuthStore(token, user);
}