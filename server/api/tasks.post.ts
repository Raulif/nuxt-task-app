import db from '~/lib/db';
import { InsertTasksSchema } from '~/lib/db/schema';
import { tasks } from '~/lib/db/schema';

export default defineEventHandler(async (event) => {
  const result = await readValidatedBody(event, InsertTasksSchema.safeParse);
  if (!result.success) {
    return sendError(
      event,
      createError({
        status: 422,
        statusMessage: 'Invalid task',
      }),
    );
  }
  const [created] = await db.insert(tasks).values(result.data).returning();
  return created;
});
