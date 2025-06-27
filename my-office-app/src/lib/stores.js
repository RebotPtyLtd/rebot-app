import { writable } from 'svelte/store';

export const token = writable('');
export const user = writable(null);

if (typeof localStorage !== 'undefined') {
	const saved = localStorage.getItem('token');
	if (saved) token.set(saved);
	token.subscribe((value) => {
		if (value) localStorage.setItem('token', value);
		else localStorage.removeItem('token');
	});
}
