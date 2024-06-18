// export const student_data = [
//   {
//     id: 1,
//     name: "Samuel",
//     age: 12
//   },
//   {
//     id: 2,
//     name: "Roland",
//     age: 13
//   },
// ];

export default async function getData() {
  const res = await fetch(
    "http://localhost:8001/course_services/list_of_courses"
  );
  console.log("Data fetching")
  // res.json;
  return res.json();
}

// export const data = getData
