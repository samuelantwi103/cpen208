import { Metadata } from "next";

// import { redirect } from "next/navigation";


type Props = {
  params: {
    studentId: string;
  };
};

export const generateMetadata = ({ params }: Props) => {
  return {
    title: `Student: Profile`,
  };
};



export default function StudentProfile({ params }: Props) {
  // const student_data = await getData()
  // if (params.studentId != "samuel"){
  //   redirect('/login')
  // }
  return (
    <div className="min-h-[calc(100vh-131px)] mx-20 lg:max-w-[50rem] sm:max-w-[30rem]">
      Profile Details
    </div>
  );
}
