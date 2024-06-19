import { NextApiRequest, NextApiResponse } from "next";

async function handler(req: NextApiRequest, res: NextApiResponse){
  if (req.method !== 'POST' ){
    return res.status(405).json({message: 'Method not allowed'})
  }
}

// export async function POST(request: Request) {
//   const data = {};
//   const res = await fetch("", {
//     method: "POST",
//     headers: {
//       "Content-Type": "application/json",
//     },
//     body: JSON.stringify({
//       course_code: "CPEN 214",
//       course_name: "Diff Eqn",
//     }),
//   });
// }
