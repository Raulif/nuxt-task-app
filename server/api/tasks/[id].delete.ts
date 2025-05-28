import { eq } from 'drizzle-orm';
import db from '~/lib/db';
import { idParamsSchema, tasks } from '~/lib/db/schema';
export default defineEventHandler(async (event) => {
  const result = await getValidatedRouterParams(
    event,
    idParamsSchema.safeParse,
  );
  if (!result.success) {
    return sendError(
      event,
      createError({
        status: 422,
        statusMessage: 'Invalid task id',
      }),
    );
  }

  const { id } = result.data;
  const res = await db.delete(tasks).where(eq(tasks.id, id)).returning();

  if (!res) {
    return sendError(
      event,
      createError({
        status: 404,
        statusMessage: 'Task could not be deleted',
      }),
    );
  }
  return res;
});
