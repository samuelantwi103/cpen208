// import { student_data } from "./data";

// export async function GET() {
//   return Response.json(student_data);
// }

// export async function POST(request: Request) {
//   const student = await request.json();
//   const newStudent = {
//     id: student_data.length + 1,
//     name: student.name,
//     age: student.age,
//   };
//   student_data.push(newStudent)
//   return new Response(JSON.stringify(newStudent), {
//     headers: {
//       "Content-Type": "application/json",
//     },
//     status: 201,
//   });
// }
