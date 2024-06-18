import Card from "@/components/card";
import React from "react";
import Image from "next/image";
import getData from "@/app/api/data";
import VerifyURL from "@/utils/verifyURL";

type Props = {};

const Dashboard = async (props: Props) => {
  VerifyURL
  const student_data = await getData();
  // const stud = {
  //   success: true,
  //   // data: [
  //   //   { id: 1, course_name: "Software Engineering", course_code: "CPEN 208" },
  //   //   { id: 2, course_name: "Linear Cirsuits", course_code: "CPEN 204" },
  //   //   { id: 3, course_name: "Academic Writing 2", course_code: "CBAS 210" },
  //   //   { id: 4, course_name: "Database Design", course_code: "CPEN 204" },
  //   //   { id: 5, course_name: "Data Structures", course_code: "CPEN 211" },
  //   // ],
  // };
  return (
    <>
      {/* Profile */}
      <div className="flex">
        <Card className="flex-grow h-56 flex p-8 justify-between rounded-3xl hover:shadow-2xl hover:translate-y-2 w-screen">
          <div className="flex flex-col justify-between ">
            <div className="flex flex-col gap-4 flex-grow">
              <div className="text-[#0a7aaa] font-semibold text-lg sm:text-2xl">
                Samuel Kojo Anafi Antwi
              </div>
              <div className="sm:text-lg">11164744</div>
            </div>
            <div className="text-[#265162]">GHS 2000.00</div>
          </div>
          <div className="self-center sm:pr-9">
            <Image
              src="/background.jpg"
              alt="alt"
              width={200}
              height={200}
              className="rounded-full overflow-hidden w-[100px] h-[100px]"
            />
          </div>
        </Card>
      </div>

      {/* Courses */}
      <div>
        <div className="font-bold text-3xl p-4 min-h-fit">Courses</div>
        <div className="flex overflow-x-scroll overflow-clip  gap-12 py-3 pb-4 bg-clip-content scrollbar-none sm:scrollbar-track-rounded-full sm:scrollbar-thumb-rounded-full sm:scrollbar md:scrollbar-thumb-[#94b5c2]  h-fit">
          {student_data.data.map(
            (course: {
              id: number;
              course_name: string;
              course_code: string;
            }) => (
              <Card
                key={course.id}
                className="flex-grow flex flex-col p-8 justify-start gap-3 rounded-3xl hover:shadow-xl hover:-translate-y-2 h-[20rem] min-w-64"
              >
                <div>{course.course_name}</div>
                <div>{course.course_code}</div>
                <div className="overflow-clip">{course.id}</div>
              </Card>
            )
          )}
        </div>
      </div>
      <div>Hello</div>
      <div>Hello</div>
      <div>Hello</div>
      <div>Hello</div>
      <div>Hello</div>
      <div>Hello</div>
      <div>Hello</div>
      <div>Hello</div>
      <div>Hello</div>
      <div>Hello</div>
      <div>Hello</div>
      <div>Hello</div>
      <div>Hello</div>
      <div>Hello</div>
      <div>Hello</div>
      <div>Hello</div>
    </>
  );
};

export default Dashboard;
