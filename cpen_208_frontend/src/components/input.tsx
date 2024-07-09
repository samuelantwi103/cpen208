import clsx from "clsx";
import { ReactNode } from "react";
interface InputProps {
  label: string;
  className?: string;
  value?: string;
  onChange?:  (e: React.ChangeEvent<HTMLInputElement>) => void;

}

export default function Input({label, className, value, onChange}:InputProps){
  return <div className="flex flex-col space-x-2 font-bold  lg:max-w-[40rem] sm:max-w-[30rem] mt-2 p-2 bg-[#93B4C1] rounded-xl">
  <div className="text-[#3E4345] px-2">{label}</div>
<input className={clsx("bg-transparent", className)} value = {value} onChange={onChange} required></input>
</div>
}