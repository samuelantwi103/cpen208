'use client'
import { ReactNode } from "react";

export default function Card({children}:{children: ReactNode}) {
  return <div className="w-fit bg-[#E5F4FA]">
    {children}
  </div>
}
