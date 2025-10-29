import { redirect } from "@sveltejs/kit";
import { form, getRequestEvent, query } from "$app/server";
import { auth } from "$lib/server/auth";
import { signupSchema, loginSchema } from "$lib/schema/auth";

export const signup = form(signupSchema, async (user) => {
  await auth.api.signUpEmail({ body: user });
  redirect(307, `/admin`);
});

export const login = form(loginSchema, async (user) => {
  const { request } = getRequestEvent();
  await auth.api.signInEmail({ body: user, headers: request.headers });
  redirect(303, "/admin");
});

export const signout = form(async () => {
  const { request } = getRequestEvent();
  await auth.api.signOut({ headers: request.headers });
  redirect(303, "/");
});

export const getUser = query(async () => {
  const { locals } = getRequestEvent();
  if (!locals.user) {
    redirect(307, "/auth/login");
  }
  return locals.user;
});
