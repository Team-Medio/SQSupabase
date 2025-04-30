import "jsr:@supabase/functions-js/edge-runtime.d.ts";

export const ErrorResponse = (message: string, status: number):Response => new Response(String(message), {
    headers: { 'Content-Type': 'application/json' },
    status: status,
});
export const SuccessResponse = (data: any):Response => new Response(JSON.stringify(data), {
    headers: { 'Content-Type': 'application/json' },
    status: 200,
  });