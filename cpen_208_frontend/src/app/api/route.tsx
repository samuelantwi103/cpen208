export async function POST() {
  const data = {};
  const res = await fetch("", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "API-Key": process.env.DATA_API_KEY!,
    },
    body: JSON.stringify({
      course_code: "CPEN 214",
      course_name: "Diff Eqn",
    }),
  });
}
