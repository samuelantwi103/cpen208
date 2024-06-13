import { Metadata } from "next";

type Props = {
  params: {
    studentId: string;
  };
};

export const generateMetadata = ({params}: Props) => {
  return {
    title: `Student: ${params.studentId}`
  }
}

export default function StudentProfile({ params }: Props) {
  return <div className="min-h-[calc(100vh-131px)] mx-20 lg:max-w-[50rem] sm:max-w-[30rem]">Name: {params.studentId}</div>;
}
