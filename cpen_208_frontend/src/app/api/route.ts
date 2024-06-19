export async function POST(request: Request) {
  const data = {};
  const res = await fetch("", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      course_code: "CPEN 214",
      course_name: "Diff Eqn",
    }),
  });
}
