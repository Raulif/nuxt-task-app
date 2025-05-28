import { eq } from 'drizzle-orm';
import db from '~/lib/db';
import { UpdateTasksSchema, tasks } from '~/lib/db/schema';

export default defineEventHandler(async (event) => {
  const result = await readValidatedBody(event, UpdateTasksSchema.safeParse);
  if (!result.success) {
    return sendError(
      event,
      createError({
        status: 422,
        statusMessage: 'Invalid task data',
      }),
    );
  }

  const { id, title, done } = result.data;

  const updatedData = { done, ...(title ? { title } : {}) };
  const res = await db
    .update(tasks)
    .set(updatedData)
    .where(eq(tasks.id, id as number))
    .returning();

  if (!res.length) {
    return sendError(
      event,
      createError({
        status: 404,
        statusMessage: 'Task could not updated',
      }),
    );
  }

  return res[0];
});
