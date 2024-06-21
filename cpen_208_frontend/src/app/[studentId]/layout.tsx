"use client";
import SideNav from "@/components/SideNav";
import React from "react";
import { ReactNode } from "react";
import useStore from "@/app/api/toggle";

export default function Layout({ children }: { children: React.ReactNode }) {
  const { isOpen } = useStore();
  return (
    <div className="min-h-full  flex justify-between">
      <SideNav />

      <div className="px-5 w-full md:min-w-[75%] bg-transparent min-h-screen h-fit flex-grow">
        <div className="flex flex-col gap-10 flex-none flex-grow overflow-hidden">
          {children}
        </div>
      </div>
    </div>
  );
}
