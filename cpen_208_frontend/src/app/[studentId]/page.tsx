import { Metadata } from "next";
import getData from "../api/data";


type Props = {
  params: {
    studentId: string;
  };
};

export const generateMetadata = ({ params }: Props) => {
  return {
    title: `Student: ${params.studentId}`,
  };
};



export default async function StudentProfile({ params }: Props) {
  const student_data = await getData()
  return (
    <div className="min-h-[calc(100vh-131px)] mx-20 lg:max-w-[50rem] sm:max-w-[30rem]">
      Name: {params.studentId}
      Course: {student_data.data[0].course_name}
    </div>
  );
}
