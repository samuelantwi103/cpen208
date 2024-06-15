'use client'
import clsx from "clsx";
import { ReactNode } from "react";

interface Props {
  children: React.ReactNode;
  className?: string;
}

export default function Card({children, className, ...props}:Props) {
  return <div className={clsx("w-fit bg-[#E5F4FA] p-3 rounded-lg", className)} {...props}>
    {children}
  </div>
}
