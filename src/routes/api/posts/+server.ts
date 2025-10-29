import { getPosts } from "$lib/api/posts.remote";
import { json } from "@sveltejs/kit";

export async function GET() {
  const posts = await getPosts();
  return json(posts);
}
