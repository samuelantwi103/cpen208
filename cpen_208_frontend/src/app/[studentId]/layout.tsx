import SideNav from "@/components/SideNav";
import React from "react";
import { ReactNode } from "react";

export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <div className="h-screen lg:max-w-[40rem] sm:max-w-[30rem] flex">
      <div className="w-full flex-none md:w-64">
        <SideNav />
      </div>
      <div className="flex-grow p-6 md:overflow-y-auto md:p-12">{children}</div>
    </div>
  );
}
