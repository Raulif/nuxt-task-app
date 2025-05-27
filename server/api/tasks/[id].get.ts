import { eq } from 'drizzle-orm';
import db from '~/lib/db';
import { z } from 'zod';
import { tasks } from '~/lib/db/schema';

export const idParamsSchema = z.object({
  id: z.coerce.number(),
});

export default defineEventHandler(async (event) => {
  const result = await getValidatedRouterParams(
    event,
    idParamsSchema.safeParse
  );
  if (!result.success) {
    return sendError(
      event,
      createError({
        status: 422,
        statusMessage: 'Invalid id',
      })
    );
  }

  const task = await db.query.tasks.findFirst({
    where: eq(tasks.id, result.data.id),
  });

  if (!task) {
    return sendError(
      event,
      createError({
        status: 404,
        statusMessage: 'Task not found',
      })
    );
  }
  return task;
});
