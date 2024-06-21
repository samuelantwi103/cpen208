"use client";
import Link from "next/link";
import React, { createContext, useState, useEffect } from "react";
import { Menu } from "lucide-react";
import clsx from "clsx";
import useStore from "@/app/api/toggle";

type Props = {};

const isLoginRegister = createContext(true);
const NavBar = (props: Props) => {
  const { isOpen, setIsOpen } = useStore();
  const toggleSidebar = () => setIsOpen(!isOpen);
  return (
    <nav className="flex sticky top-0 text-white p-4 sm:px-6 xl:pl-[15vw] align backdrop-blur-md z-[500] bg-[#ccd0c9a6]">
      <ul className="flex justify-between w-full text-nowrap items-center">
        <li className="md:hidden hover:cursor-pointer" onClick={toggleSidebar}>
          <Menu color="#000000" />
        </li>
        <li>
          <Link
            href={"/"}
            className="font-bold text-2xl text-[#0A7AAA]"
            scroll={false}
          >
            CPEN UG
          </Link>
        </li>
        <li className="flex justify-between h-fit sm:gap-3 items-center text-black">
          <Link href={""} className={clsx("hidden sm:block")} scroll={false}>
            <div>About</div>
          </Link>
          <Link href={""} className="hidden sm:block" scroll={false}>
            <div>Contact Us</div>
          </Link>
        </li>
        <li className="flex justify-center  w-fit  text-white gap-3">
          <Link href={"/login"} scroll={false}>
            <div className="px-4 py-1 border-[#0A7AAA] text-black border-2 rounded-full min-h-[35px]">
              Log In
            </div>
          </Link>
          <Link href={"/signup"} scroll={false}>
            <div className="bg-[#0A7AAA] px-4 py-1 rounded-full min-h-[35px]">
              Register
            </div>
          </Link>
        </li>
      </ul>
    </nav>
  );
};

export default NavBar;
