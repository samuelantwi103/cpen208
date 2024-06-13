import { ReactNode } from "react";
interface InputProps {
  label: string;
  placeholder?: string;
}

export default function Input({label, placeholder}:InputProps){
  return <div className="flex flex-col space-x-2 font-bold  lg:max-w-[40rem] sm:max-w-[30rem] mt-2 p-2 bg-[#93B4C1] rounded-xl">
  <div className="text-[#3E4345] px-2">{label}</div>
  <input className=" bg-transparent"></input>
</div>
}