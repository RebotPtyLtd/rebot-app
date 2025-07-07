import tailwindcss from '@tailwindcss/vite';
import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

// Check if we're running in Docker by looking for the environment variable
const isDocker = process.env.DOCKER_ENV === 'true';

export default defineConfig({
	plugins: [tailwindcss(), sveltekit()],
	server: {
		proxy:{
			'/api': isDocker 
				? 'http://wiremock:8080' 
				: 'http://localhost:8080'
		}
	}
});
