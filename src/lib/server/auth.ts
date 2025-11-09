import { betterAuth } from 'better-auth';
import { drizzleAdapter } from 'better-auth/adapters/drizzle';
import { sveltekitCookies } from 'better-auth/svelte-kit';
import { db } from '$lib/server/database';
import { getRequestEvent, query } from '$app/server';
import { redirect } from '@sveltejs/kit';

export const auth = betterAuth({
	database: drizzleAdapter(db, { provider: 'sqlite' }),
	plugins: [sveltekitCookies(getRequestEvent)],
	emailAndPassword: { enabled: true },
});

export async function requireAuth() {
	const session = await getSession();
	return session?.user ?? redirect(307, '/auth/login');
}

export const getSession = query(async () => {
	return auth.api.getSession({
		headers: getRequestEvent().request.headers,
	});
});
