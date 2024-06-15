import Card from "@/components/card";
import React from "react";
import Image from "next/image";

type Props = {};

const Dashboard = (props: Props) => {
  const course_data = [
    {
      code: "CS101",
      title: "Introduction to Computer Science",
      description:
        "This course provides a broad introduction to the fundamental concepts of computer science.",
      image_link: "https://example.com/course_images/cs101.jpg",
    },
    {
      code: "MATH202",
      title: "Calculus II",
      description:
        "This course builds upon the concepts of Calculus I, focusing on integration techniques and applications.",
      image_link: "https://example.com/course_images/math202.jpg",
    },
    {
      code: "ENG310",
      title: "Creative Writing",
      description:
        "Develop your writing skills and explore different creative writing techniques in this course.",
      image_link: "https://example.com/course_images/eng310.jpg",
    },
  ];
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
        <div
          className="flex overflow-x-scroll overflow-clip   gap-12 py-3 pb-4 bg-clip-content"
          style={{ scrollbarWidth: "none" }}
        >
          {course_data.map((course) => (
            <Card
              key={course.code}
              className="flex-grow flex flex-col p-8 justify-between rounded-3xl hover:shadow-xl hover:-translate-y-2 z-10 h-[360px]"
            >
              <div>{course.title}</div>
              <div>{course.code}</div>
              <div>{course.description}</div>
            </Card>
          ))}
        </div>
      </div>
    </>
  );
};

export default Dashboard;
