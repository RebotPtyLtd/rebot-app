import { json } from '@sveltejs/kit';
import type { RequestEvent } from '@sveltejs/kit';

const WIREMOCK_URL = process.env.DOCKER_ENV === 'true' 
  ? 'http://wiremock:8080' 
  : 'http://localhost:8080';

export const GET = async ({ request }: RequestEvent) => {
  try {
    const authHeader = request.headers.get('authorization');
    
    if (!authHeader) {
      return json({ error: 'No authorization header' }, { status: 401 });
    }

    const response = await fetch(`${WIREMOCK_URL}/api/auth/me`, {
      method: 'GET',
      headers: {
        'Authorization': authHeader,
      },
    });

    if (!response.ok) {
      const errorText = await response.text();
      return json({ error: errorText }, { status: response.status });
    }

    const data = await response.json();
    return json(data);
  } catch (error) {
    console.error('Auth me proxy error:', error);
    return json({ error: 'Internal server error' }, { status: 500 });
  }
}; 