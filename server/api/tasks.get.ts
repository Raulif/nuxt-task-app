export default defineEventHandler(async (event) => {
  await new Promise((res) => setTimeout(res, 2000));
  return sendError(event, createError({
    status: 500,
    statusMessage: 'StatusMessage: Oh no!'
  }))
  return [
    {
      id: 1,
      title: 'Learn Nuxt',
      done: false,
    },
    {
      id: 2,
      title: 'Learn Vue',
      done: false,
    },
  ];
});
