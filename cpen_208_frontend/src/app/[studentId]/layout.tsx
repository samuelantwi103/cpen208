import SideNav from "@/components/SideNav";
import React from "react";
import { ReactNode } from "react";

export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <div className="h-screen lg:max-w-[40rem] sm:max-w-[30rem] flex justify-between">
      <div className="flex-grow">
      <SideNav />
      </div>
      <div className="w-full flex-none md:w-64">
      {children}
      </div>
    </div>
  );
}
