import SideNav from "@/components/SideNav";
import React from "react";
import { ReactNode } from "react";

export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-full  flex justify-between">
      <div className="hidden md:block">
        <SideNav />
      </div>
      <div className="px-5 w-full md:min-w-[75%] bg-transparent min-h-screen h-fit">
        <div className="flex flex-col gap-10 flex-none flex-grow overflow-hidden">
          {children}
        </div>
      </div>
    </div>
  );
}
