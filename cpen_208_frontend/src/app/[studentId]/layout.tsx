import SideNav from "@/components/SideNav";
import React from "react";
import { ReactNode } from "react";

export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <div className="h-screen  flex justify-between">
      <div className="hidden md:block">
        <SideNav />
      </div>
      <div className="px-5 w-full md:min-w-[75%]">
        <div className="flex flex-col gap-10 flex-none flex-grow  h-screen overflow-hidden">
          {children}
        </div>
      </div>
    </div>
  );
}
