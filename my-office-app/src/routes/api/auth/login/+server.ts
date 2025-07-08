import { json } from '@sveltejs/kit';
import type { RequestEvent } from '@sveltejs/kit';

const WIREMOCK_URL = process.env.DOCKER_ENV === 'true' 
  ? 'http://wiremock:8080' 
  : 'http://localhost:8080';

export const POST = async ({ request }: RequestEvent) => {
  try {
    const body = await request.json();
    
    const response = await fetch(`${WIREMOCK_URL}/api/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    });

    if (!response.ok) {
      const errorText = await response.text();
      return json({ error: errorText }, { status: response.status });
    }

    const data = await response.json();
    return json(data);
  } catch (error) {
    console.error('Login proxy error:', error);
    return json({ error: 'Internal server error' }, { status: 500 });
  }
}; 